// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/barcode/barcode_scanner_screen.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:builders_konnect/ui/screens/product/add_product_screen.dart';
import 'package:dotted_border/dotted_border.dart';

class SearchAddProductScreen extends ConsumerStatefulWidget {
  const SearchAddProductScreen({super.key});

  @override
  ConsumerState<SearchAddProductScreen> createState() =>
      _SearchAddProductScreenState();
}

class _SearchAddProductScreenState
    extends ConsumerState<SearchAddProductScreen> {
  final searchC = TextEditingController();
  final searchF = FocusNode();
  Timer? _debounce;

  bool isSearching = false;

  List<ProductCatalogueWithStatus> productCatalogues = [];
  bool isCreatingProducts = false;

  @override
  void initState() {
    super.initState();
    searchC.addListener(() {
      isSearching = searchC.text.isNotEmpty && searchF.hasFocus;
      setState(() {});
    });

    searchF.addListener(() {
      isSearching = searchC.text.isNotEmpty && searchF.hasFocus;
      setState(() {});
    });
  }

  // Search with debounce
  void _searchProducts(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(catalogueVmodel).getCatalogueProducts(q: query.trim());
    });
  }

  void _updateProduct(ProductCatalogueWithStatus updatedProduct) {
    final index = productCatalogues.indexWhere(
      (p) => p.catalogueModel.id == updatedProduct.catalogueModel.id,
    );

    if (index != -1) {
      setState(() {
        productCatalogues[index] = updatedProduct;
      });
    }
  }

  bool get _areAllProductsComplete {
    return productCatalogues.isNotEmpty &&
        productCatalogues.every((product) => product.isComplete);
  }

  void _createProductsFromCatalogue() async {
    if (!_areAllProductsComplete || isCreatingProducts) return;

    setState(() {
      isCreatingProducts = true;
    });

    try {
      // Validate all products before creating
      final incompleteProducts = <String>[];
      for (final productStatus in productCatalogues) {
        if (productStatus.formData == null ||
            !productStatus.formData!.isComplete) {
          incompleteProducts
              .add(productStatus.catalogueModel.name ?? 'Unknown Product');
        }
      }

      if (incompleteProducts.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Please complete information for: ${incompleteProducts.join(', ')}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }

      final products = productCatalogues.map((p) => p.toProduct()).toList();
      final params = ProductCatalogueParams(products: products);

      final productVm = ref.read(productInventoryVmodel);
      final response =
          await productVm.createProductFromCatalogue(params: params);

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('${products.length} product(s) created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? 'Failed to create products'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error creating products: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isCreatingProducts = false;
        });
      }
    }
  }

  // Open barcode scanner
  // Open barcode scanner
  void _openBarcodeScanner() async {
    try {
      // Check if camera permission is available before opening scanner
      final result = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (context) => BarcodeScannerScreen(
            onBarcodeScanned: (barcode) {
              // This callback can be used for additional handling if needed
              printty('Barcode scanned: $barcode');
            },
          ),
        ),
      );

      if (result != null && result.isNotEmpty) {
        // Search for product by barcode
        _searchProductByBarcode(result);
      } else if (result == null) {
        // User cancelled scanning
        printty('Barcode scanning cancelled by user');
      }
    } catch (e) {
      // Handle navigation or scanner errors
      showWarningToast('Unable to open barcode scanner. Please try again.');
      printty('Error opening barcode scanner: $e');
    }
  }

  // Search product by barcode and add to selection
  void _searchProductByBarcode(String barcode) async {
    try {
      final catalogueVm = ref.read(catalogueVmodel);

      // Validate barcode input
      if (barcode.trim().isEmpty) {
        showWarningToast('Invalid barcode scanned');
        return;
      }

      // Show loading state
      setState(() {
        isSearching = true;
      });

      // Search for product using barcode as query
      await catalogueVm.getCatalogueProducts(q: barcode.trim());

      if (catalogueVm.catalogueProducts.isNotEmpty) {
        // Find exact match by SKU, EAN, or code
        final exactMatch = catalogueVm.catalogueProducts
            .where(
              (p) =>
                  p.sku?.toLowerCase() == barcode.toLowerCase() ||
                  p.code?.toLowerCase() == barcode.toLowerCase() ||
                  p.code?.toLowerCase() == barcode.toLowerCase(),
            )
            .toList();

        final product = exactMatch.isNotEmpty
            ? exactMatch.first
            : catalogueVm.catalogueProducts.first;

        // Check if product is already in the list
        final existingIndex = productCatalogues.indexWhere(
          (p) => p.catalogueModel.id == product.id,
        );

        if (existingIndex == -1) {
          // Add product to the list
          setState(() {
            productCatalogues.add(
              ProductCatalogueWithStatus(
                catalogueModel: product,
              ),
            );
          });
        }

        // If no exact match found, show warning
        if (exactMatch.isEmpty) {
          showWarningToast(
              'No exact barcode match found. Added closest result.');
        } else {
          showWarningToast('Product added from barcode scan.');
        }
      } else {
        // Show error message if no product found
        showWarningToast('No product found with barcode: $barcode');
      }
    } catch (e) {
      // Handle any errors during the search process
      showWarningToast('Error searching for product. Please try again.');
      printty('Error in _searchProductByBarcode: $e');
    } finally {
      // Reset loading state
      setState(() {
        isSearching = false;
      });
    }
  }

  @override
  void dispose() {
    searchC.dispose();
    searchF.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final catalogueVm = ref.watch(catalogueVmodel);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Add Product",
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: Sizer.width(16),
          right: Sizer.width(16),
          bottom: Sizer.height(50),
        ),
        child: Column(
          children: [
            YBox(16),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(Sizer.radius(16)),
                decoration: BoxDecoration(
                  color: colorScheme.white,
                  borderRadius: BorderRadius.circular(Sizer.radius(4)),
                ),
                child: ListView(
                  children: [
                    CustomTextField(
                      controller: searchC,
                      focusNode: searchF,
                      isRequired: false,
                      labelText: 'Search here to add product',
                      hintText: 'Enter product name',
                      showLabelHeader: true,
                      onChanged: _searchProducts,
                    ),
                    YBox(24),

                    // suggestion catalogue products
                    AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      child: Builder(builder: (context) {
                        if (!isSearching ||
                            !searchF.hasFocus ||
                            catalogueVm.catalogueProducts.isEmpty) {
                          return SizedBox.shrink();
                        }

                        if (catalogueVm.busy(getState)) {
                          return SizerLoader(
                            height: Sizer.height(300),
                          );
                        }
                        return Container(
                          height: Sizer.screenHeight * 0.5,
                          margin: EdgeInsets.only(top: Sizer.height(8)),
                          padding: EdgeInsets.all(Sizer.radius(16)),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius:
                                BorderRadius.circular(Sizer.radius(2)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withValues(alpha: 0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          // constraints: BoxConstraints(
                          //   maxHeight: Sizer.height(300),
                          // ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Can’t find the product you want to add?",
                                style: textTheme.text14,
                              ),
                              YBox(5),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      RoutePath.addProductRequestScreen);
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: Sizer.height(2),
                                  ),
                                  child: Text(
                                    "Request to add product",
                                    style: textTheme.text14?.medium.copyWith(
                                      color: colorScheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                    top: Sizer.height(16),
                                    bottom: Sizer.height(30),
                                  ),
                                  itemCount:
                                      catalogueVm.catalogueProducts.length,
                                  separatorBuilder: (_, __) => HDivider(),
                                  itemBuilder: (ctx, i) {
                                    final product =
                                        catalogueVm.catalogueProducts[i];
                                    return ProductWithSkuListTile(
                                      showTrailing: false,
                                      productTitle: product.name ?? '',
                                      subTitle: product.productType?.name ?? '',
                                      productImage:
                                          product.primaryMediaUrl ?? '',
                                      onTap: () {
                                        final existingIndex =
                                            productCatalogues.indexWhere(
                                          (p) =>
                                              p.catalogueModel.id == product.id,
                                        );

                                        if (existingIndex != -1) {
                                          productCatalogues
                                              .removeAt(existingIndex);
                                        } else {
                                          productCatalogues.add(
                                            ProductCatalogueWithStatus(
                                              catalogueModel: product,
                                            ),
                                          );
                                        }

                                        // Close catalogue suggestions by removing focus (keep search text)
                                        searchF.unfocus();

                                        setState(() {});
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    YBox(24),
                    InkWell(
                      onTap: () => _openBarcodeScanner(),
                      child: Container(
                        color: AppColors.dayBreakBlue,
                        child: DottedBorder(
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizer.width(16),
                            vertical: Sizer.height(12),
                          ),
                          borderType: BorderType.RRect,
                          radius: Radius.circular(Sizer.radius(4)),
                          dashPattern: [5, 2],
                          strokeWidth: 1,
                          color: AppColors.primaryBlue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(AppSvgs.scan),
                              XBox(8),
                              Text(
                                'Tap here to scan product barcode',
                                style: textTheme.text14?.copyWith(
                                  color: AppColors.neutral10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    YBox(24),

                    // Catalogue Products selected
                    AnimatedSize(
                      duration: Duration(milliseconds: 500),
                      child: productCatalogues.isEmpty
                          ? SizedBox.shrink()
                          : Container(
                              padding: EdgeInsets.all(Sizer.radius(16)),
                              decoration: BoxDecoration(
                                color: AppColors.neutral2,
                                borderRadius: BorderRadius.circular(
                                  Sizer.radius(6),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Product list",
                                        style: textTheme.text16?.copyWith(
                                          color: AppColors.neutral10,
                                        ),
                                      ),
                                      XBox(10),
                                      Container(
                                        height: Sizer.height(24),
                                        width: Sizer.width(24),
                                        decoration: BoxDecoration(
                                          color: AppColors.dayBreakBlue,
                                          borderRadius: BorderRadius.circular(
                                            Sizer.radius(20),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "${productCatalogues.length}",
                                            style: textTheme.text12?.copyWith(
                                              color: AppColors.neutral10,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Text(
                                    "Tap on each product to add necessary product information",
                                    style: textTheme.text12?.copyWith(
                                      color: colorScheme.black45,
                                    ),
                                  ),
                                  YBox(16),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.only(
                                      top: Sizer.height(16),
                                      bottom: Sizer.height(30),
                                    ),
                                    itemCount: productCatalogues.length,
                                    separatorBuilder: (_, __) => HDivider(),
                                    itemBuilder: (ctx, i) {
                                      final product = productCatalogues[i];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Sizer.width(16),
                                        ),
                                        child: Dismissible(
                                          key: Key(
                                              'product_${product.catalogueModel.id}_$i'),
                                          confirmDismiss: (direction) async {
                                            if (direction ==
                                                DismissDirection.endToStart) {
                                              // Delete action (swipe left)
                                              return await ModalWrapper
                                                  .bottomSheet(
                                                context: context,
                                                widget: ConfirmationModal(
                                                  modalConfirmationArg:
                                                      ModalConfirmationArg(
                                                    iconPath:
                                                        AppSvgs.infoCircleRed,
                                                    title:
                                                        "Remove ${product.catalogueModel.name}",
                                                    description:
                                                        "Are you sure you want to remove ${product.catalogueModel.name} from your product list?",
                                                    solidBtnText: "Yes Remove",
                                                    onSolidBtnOnTap: () {
                                                      Navigator.pop(
                                                          context, true);
                                                    },
                                                    onOutlineBtnOnTap: () {
                                                      Navigator.pop(
                                                          context, false);
                                                    },
                                                  ),
                                                ),
                                              );
                                            } else if (direction ==
                                                DismissDirection.startToEnd) {
                                              // Edit action (swipe right)
                                              await _editProduct(product);
                                              return false; // Don't dismiss, just perform action
                                            }
                                            return false;
                                          },
                                          background: _buildSwipeBackground(
                                              isLeftSwipe: true),
                                          secondaryBackground:
                                              _buildSwipeBackground(
                                                  isLeftSwipe: false),
                                          child: ProductWithSkuListTile(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            productTitle:
                                                product.catalogueModel.name ??
                                                    '',
                                            subTitle: product.catalogueModel
                                                    .productType?.name ??
                                                '',
                                            productImage: product.catalogueModel
                                                    .primaryMediaUrl ??
                                                '',
                                            trailingWidget: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                product.isComplete
                                                    ? SvgPicture.asset(
                                                        AppSvgs.checkC)
                                                    : SvgPicture.asset(
                                                        AppSvgs.infoC)
                                              ],
                                            ),
                                            onTap: () async {
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddProductScreen(
                                                    productWithStatus: product,
                                                    onProductUpdated:
                                                        _updateProduct,
                                                  ),
                                                ),
                                              );

                                              if (result == 'remove') {
                                                setState(() {
                                                  productCatalogues
                                                      .remove(product);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                    ),
                    YBox(24),
                    if (productCatalogues.isNotEmpty)
                      CustomBtn(
                        onTap: _areAllProductsComplete && !isCreatingProducts
                            ? _createProductsFromCatalogue
                            : null,
                        online: _areAllProductsComplete && !isCreatingProducts,
                        isLoading: isCreatingProducts,
                        text: "Add Product(s)",
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeBackground({required bool isLeftSwipe}) {
    return Container(
      alignment: isLeftSwipe ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: Sizer.width(20)),
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [
      //       Colors.red.withValues(alpha: 0.8),
      //       Colors.red,
      //     ],
      //     begin: isLeftSwipe ? Alignment.centerLeft : Alignment.centerRight,
      //     end: isLeftSwipe ? Alignment.centerRight : Alignment.centerLeft,
      //   ),
      // ),
      child: Row(
        mainAxisAlignment:
            isLeftSwipe ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          InkWell(
            child: Container(
              // height: Sizer.height(46),
              // width: Sizer.width(60),
              padding: EdgeInsets.symmetric(
                horizontal: Sizer.width(16),
                vertical: Sizer.height(10),
              ),
              color: AppColors.dayBreakBlue,
              child: SvgPicture.asset(
                AppSvgs.edit,
                height: Sizer.height(24),
              ),
            ),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Sizer.width(16),
                vertical: Sizer.height(10),
              ),
              color: AppColors.red2D,
              child: SvgPicture.asset(
                AppSvgs.deleteWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Handle edit action when swiping right
  Future<void> _editProduct(ProductCatalogueWithStatus product) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductScreen(
          productWithStatus: product,
          onProductUpdated: _updateProduct,
        ),
      ),
    );

    if (result == 'remove') {
      setState(() {
        productCatalogues.remove(product);
      });
    }
  }
}
