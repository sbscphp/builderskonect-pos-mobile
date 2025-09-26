import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/barcode/barcode_scanner_screen.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SelectProductsStep extends ConsumerStatefulWidget {
  const SelectProductsStep({
    super.key,
    this.onNext,
  });

  final Function()? onNext;

  @override
  ConsumerState<SelectProductsStep> createState() => _SelectProductsTabState();
}

class _SelectProductsTabState extends ConsumerState<SelectProductsStep> {
  final searchC = TextEditingController();
  final searchF = FocusNode();
  Timer? _debounce;

  bool isSearching = false;
  // final List<ProductModel> _productList = [];

  @override
  void initState() {
    super.initState();
    searchC.addListener(() {
      _updateSearchingState();
    });

    searchF.addListener(() {
      _updateSearchingState();
    });
  }

  void _updateSearchingState() {
    final salesVm = ref.read(salesVmodel);
    // Show search results when:
    // 1. Search field is focused AND
    // 2. Either there's search text OR there are products in the list
    isSearching = searchF.hasFocus &&
        (searchC.text.isNotEmpty || salesVm.productList.isNotEmpty);
    setState(() {});
  }

  // Search with debounce
  void _searchProducts(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(productInventoryVmodel).getInventoryProducts(q: query.trim());
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
      final salesVm = ref.read(salesVmodel);

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
            salesVm.productList.indexWhere((p) => p.id == product.id);

        if (existingProductIndex != -1) {
          // Update quantity of existing product
          final currentQuantity =
              salesVm.productList[existingProductIndex].quantity ?? 0;
          salesVm.productList[existingProductIndex] = salesVm
              .productList[existingProductIndex]
              .copyWith(quantity: currentQuantity + 1);
          showSuccessToastMessage(
              'Quantity updated for "${product.name}" (${currentQuantity + 1})');
        } else {
          // Add new product to selection
          salesVm.productList.add(product.copyWith(quantity: 1));
          showSuccessToastMessage(
              'Product "${product.name}" added to selection');
        }

        // Close search results by removing focus
        searchF.unfocus();

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
    final inventoryProductVm = ref.watch(productInventoryVmodel);
    final salesVm = ref.watch(salesVmodel);

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
              ),

              // Search results
              AnimatedSize(
                duration: Duration(milliseconds: 500),
                child: Builder(builder: (context) {
                  if (inventoryProductVm.busy(getState)) {
                    return SizerLoader(
                      height: Sizer.height(300),
                    );
                  }

                  if (searchF.hasFocus &&
                      inventoryProductVm.inventoryProducts.isNotEmpty) {
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
                        itemCount: inventoryProductVm.inventoryProducts.length,
                        separatorBuilder: (_, __) => HDivider(),
                        itemBuilder: (ctx, i) {
                          final product =
                              inventoryProductVm.inventoryProducts[i];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Sizer.width(16),
                            ),
                            child: SalesProductWidget(
                              productTitle: product.name ?? '',
                              subTitle: product.productType ?? '',
                              productImage: product.primaryMediaUrl ?? '',
                              sku: product.quantity?.toString() ?? '',
                              onTap: () {
                                printty(
                                    "product image ${product.primaryMediaUrl}");
                                final existingProductIndex = salesVm.productList
                                    .indexWhere((p) => p.id == product.id);
                                if (existingProductIndex != -1) {
                                  salesVm.productList[
                                      existingProductIndex] = salesVm.productList[
                                          existingProductIndex]
                                      .copyWith(
                                          quantity: (salesVm
                                                      .productList[
                                                          existingProductIndex]
                                                      .quantity ??
                                                  0) +
                                              1);
                                } else {
                                  salesVm.productList
                                      .add(product.copyWith(quantity: 1));
                                }

                                // Close search results by removing focus
                                searchF.unfocus();

                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return SizedBox.shrink();
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
              if (salesVm.productList.isNotEmpty)
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
                      itemCount: salesVm.productList.length,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => HDivider(),
                      itemBuilder: (ctx, i) {
                        final product = salesVm.productList[i];
                        return SalesProductWidget(
                          productTitle: product.name ?? '',
                          subTitle: product.productType ?? '',
                          productImage: product.primaryMediaUrl ?? '',
                          sku: product.sku ?? '',
                          showPriceQty: true,
                          quantity: product.quantity ?? 0,
                          unitPrice:
                              "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: double.tryParse(product.costPrice ?? "0") ?? 0)}",
                          totalAmount:
                              "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: double.tryParse(product.retailPrice ?? "0") ?? 0)}",
                          onTap: () {
                            printty("${product.quantity}");
                          },
                          onRemove: () {
                            salesVm.productList.removeAt(i);
                            setState(() {});
                          },
                          onQtyChanged: (newQuantity) {
                            if (newQuantity <= 0) {
                              salesVm.productList.removeAt(i);
                            } else {
                              salesVm.productList[i] = salesVm.productList[i]
                                  .copyWith(quantity: newQuantity);
                            }
                            setState(() {});
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
              YBox((salesVm.productList.isEmpty) ? 300 : 10),
              CustomBtn(
                text: "Next",
                online: salesVm.productList.isNotEmpty,
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
