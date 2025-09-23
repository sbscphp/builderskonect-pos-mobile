import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/barcode/barcode_scanner_screen.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SelectTransferProductsStep extends ConsumerStatefulWidget {
  const SelectTransferProductsStep({
    super.key,
    this.onNext,
  });

  final Function()? onNext;

  @override
  ConsumerState<SelectTransferProductsStep> createState() =>
      _SelectTransferProductsStepState();
}

class _SelectTransferProductsStepState
    extends ConsumerState<SelectTransferProductsStep> {
  final searchC = TextEditingController();
  final searchF = FocusNode();
  Timer? _debounce;

  bool isSearching = false;
  // final List<ProductModel> _productList = [];

  @override
  void initState() {
    super.initState();
    searchC.addListener(() {
      isSearching = searchC.text.isNotEmpty && searchF.hasFocus;
      setState(() {});
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // });
  }

  // Search with debounce
  void _searchProducts(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(productTransferVm).fetchProductsByStoreId(q: query.trim());
      // ref.read(productInventoryVmodel).getInventoryProducts(q: query.trim());
    });
  }

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
      final inventoryProductVm = ref.read(productInventoryVmodel);
      final vm = ref.read(productTransferVm);

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
      await inventoryProductVm.getInventoryProducts(q: barcode.trim());

      if (inventoryProductVm.inventoryProducts.isNotEmpty) {
        // Find exact match by SKU, EAN, or code
        final exactMatch = inventoryProductVm.inventoryProducts
            .where(
              (p) =>
                  p.sku?.toLowerCase() == barcode.toLowerCase() ||
                  p.ean?.toLowerCase() == barcode.toLowerCase() ||
                  p.code?.toLowerCase() == barcode.toLowerCase(),
            )
            .toList();

        final product = exactMatch.isNotEmpty
            ? exactMatch.first
            : inventoryProductVm.inventoryProducts.first;

        // Check if product is already in the list
        final existingProductIndex =
            vm.productList.indexWhere((p) => p.id == product.id);

        if (existingProductIndex != -1) {
          // Update quantity of existing product
          final currentQuantity =
              vm.productList[existingProductIndex].quantity ?? 0;
          vm.productList[existingProductIndex] = vm
              .productList[existingProductIndex]
              .copyWith(quantity: currentQuantity + 1);
          showSuccessToastMessage(
              'Quantity updated for "${product.name}" (${currentQuantity + 1})');
        } else {
          // Add new product to selection
          vm.productList.add(product.copyWith(quantity: 1));
          showSuccessToastMessage(
              'Product "${product.name}" added to selection');
        }

        setState(() {});

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
    final vm = ref.watch(productTransferVm);

    return ListView(
      padding: EdgeInsets.only(
        left: Sizer.width(16),
        right: Sizer.width(16),
        bottom: Sizer.height(50),
      ),
      children: [
        YBox(16),
        Container(
          padding: EdgeInsets.all(Sizer.radius(16)),
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: searchC,
                focusNode: searchF,
                isRequired: false,
                labelText: 'Search Products ',
                hintText: 'Search product by name, sku, etc.',
                showLabelHeader: true,
                onChanged: _searchProducts,
                suffixIcon: searchC.text.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                            onTap: () {
                              searchC.clear();
                              setState(() {});
                            },
                            child: Icon(Icons.clear)),
                      )
                    : null,
              ),
              if (vm.busy(transferItemState))
                LinearProgressIndicator(
                  color: AppColors.primaryBlue,
                  backgroundColor: Colors.transparent,
                ),
              AnimatedSize(
                duration: Duration(milliseconds: 500),
                child: Builder(builder: (context) {
                  if (!isSearching) {
                    return SizedBox.shrink();
                  }

                  if (vm.busy(storeProductState)) {
                    return SizerLoader(
                      height: Sizer.height(300),
                    );
                  }
                  return Container(
                    margin: EdgeInsets.only(top: Sizer.height(8)),
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
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                        top: Sizer.height(16),
                        bottom: Sizer.height(30),
                      ),
                      itemCount: vm.storeProducts.length,
                      separatorBuilder: (_, __) => HDivider(),
                      itemBuilder: (ctx, i) {
                        final product = vm.storeProducts[i];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizer.width(16),
                          ),
                          child: SalesProductWidget(
                            productTitle: product.name ?? '',
                            subTitle: product.productType ?? '',
                            productImage: product.primaryMediaUrl ?? '',
                            sku: product.sku?.toString() ?? '',
                            onTap: () async {
                              final res = await vm.fetchTransferItemDetail(
                                  product: product);

                              handleApiResponse(
                                  response: res,
                                  successMsg: "Product added to Request List");

                              if (!vm.error(transferItemState)) {
                                product.transferItemDetails =
                                    transferItemDetailsFromJson(
                                        json.encode(res.data['data']));
                              
                                final existingProductIndex = vm.productList
                                    .indexWhere((p) => p.id == product.id);
                                if (existingProductIndex != -1) {
                                  vm.productList[existingProductIndex] = vm
                                      .productList[existingProductIndex]
                                      .copyWith(
                                          quantity: (vm
                                                      .productList[
                                                          existingProductIndex]
                                                      .quantity ??
                                                  0) +
                                              1);
                                } else {
                                  vm.productList
                                      .add(product);
                                }
                              }
                              setState(() {});
                            },
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
              YBox(24),
              InkWell(
                onTap: () => _openBarcodeScanner(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizer.width(16),
                    vertical: Sizer.height(12),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neutral3,
                    borderRadius: BorderRadius.circular(Sizer.radius(4)),
                    border: Border.all(
                      color: AppColors.neutral5,
                    ),
                  ),
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
              HDivider(verticalPadding: 24),
              if (vm.productList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Product list",
                      style: textTheme.text16?.medium,
                    ),
                    YBox(16),
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: vm.productList.length,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => HDivider(),
                      itemBuilder: (ctx, i) {
                        final product = vm.productList[i];
                        return TransferProductWidget(
                          productTitle: product.name ?? '',
                          subTitle: product.productType ?? '',
                          productImage: product.primaryMediaUrl ?? '',
                          sku: product.sku ?? '',
                          otherStore: vm.selectedStore?.name ?? '',
                          otherStock: product.transferItemDetails?.sourceQty
                              ?.toString(),
                          yourStock: product.transferItemDetails?.destinyQty
                              ?.toString(),
                          onRemove: () {
                            vm.productList.removeAt(i);
                            setState(() {});
                          },
                          onTap: () {
                            printty("UI CALL :::>>> ${product.toJson()}");
                          },
                        );
                      },
                    ),
                    HDivider(verticalPadding: 24),
                    YBox(16),
                    // CustomBtn(
                    //   text: "Next",
                    //   onTap: widget.onNext,
                    // ),
                    // YBox(30),
                  ],
                ),
              YBox((vm.productList.isEmpty) ? 300 : 10),
              CustomBtn(
                text: "Next",
                online: vm.productList.isNotEmpty,
                onTap: () {
                  widget.onNext?.call();
                },
              ),
              YBox(30),
            ],
          ),
        ),
      ],
    );
  }
}
