// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/barcode/barcode_scanner_screen.dart';
import 'package:builders_konnect/ui/components/components.dart';
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

  List<CatalogueModel> productCatalogues = [];

  @override
  void initState() {
    super.initState();
    searchC.addListener(() {
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

        // If no exact match found, show warning
        if (exactMatch.isEmpty) {
          showWarningToast(
              'No exact barcode match found. Added closest result.');
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
      body: ListView(
        padding: EdgeInsets.only(
          left: Sizer.width(16),
          right: Sizer.width(16),
          bottom: Sizer.height(50),
        ),
        children: [
          YBox(16),
          Container(
            height: Sizer.screenHeight * 0.8,
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
                AnimatedSize(
                  duration: Duration(milliseconds: 500),
                  child: Builder(builder: (context) {
                    if (!isSearching) {
                      return SizedBox.shrink();
                    }

                    if (catalogueVm.busy(getState)) {
                      return SizerLoader(
                        height: Sizer.height(300),
                      );
                    }
                    return Container(
                      margin: EdgeInsets.only(top: Sizer.height(8)),
                      padding: EdgeInsets.all(Sizer.radius(16)),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(Sizer.radius(2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      constraints: BoxConstraints(
                        maxHeight: Sizer.height(300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Can’t find the product you want to add?",
                            style: textTheme.text14,
                          ),
                          YBox(5),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RoutePath.addProductRequestScreen);
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
                          ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(
                              top: Sizer.height(16),
                              bottom: Sizer.height(30),
                            ),
                            itemCount: catalogueVm.catalogueProducts.length,
                            separatorBuilder: (_, __) => HDivider(),
                            itemBuilder: (ctx, i) {
                              final product = catalogueVm.catalogueProducts[i];
                              return ProductWithSkuListTile(
                                showTrailing: false,
                                productTitle: product.name ?? '',
                                subTitle: product.productType?.name ?? '',
                                productImage: product.primaryMediaUrl ?? '',
                                onTap: () {
                                  if (productCatalogues.contains(product)) {
                                    productCatalogues.remove(product);
                                  } else {
                                    productCatalogues.add(product);
                                  }
                                  setState(() {});
                                },
                              );
                            },
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
                                    child: ProductWithSkuListTile(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      productTitle: product.name ?? '',
                                      subTitle: product.productType?.name ?? '',
                                      productImage:
                                          product.primaryMediaUrl ?? '',
                                      trailingWidget:
                                          SvgPicture.asset(AppSvgs.infoC),
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, RoutePath.addProductScreen,
                                            arguments: product);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
