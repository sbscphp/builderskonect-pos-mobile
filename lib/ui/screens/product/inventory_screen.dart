import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final searchC = TextEditingController();
  final searchFocus = FocusNode();
  final _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(productInventoryVmodel).getInventoryProducts();
      _scrollListener();
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    searchFocus.dispose();
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _performSearch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final productVm = ref.read(productInventoryVmodel);
      productVm.getInventoryProducts(
          q: query.trim(), busyObjectName: searchState);
    });
  }

  void _clearSearch() {
    searchC.clear();
    final productVm = ref.read(productInventoryVmodel);
    productVm.getInventoryProducts();
  }

  _scrollListener() {
    final vm = ref.watch(productInventoryVmodel);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!vm.busy(paginateState) && vm.pageNumber <= (vm.lastPage ?? 1)) {
          vm.getInventoryProducts(busyObjectName: paginateState);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final productVm = ref.watch(productInventoryVmodel);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Inventory",
      ),
      body: Builder(
        builder: (context) {
          if (productVm.busy(getState)) {
            return const Center(
              child: SizerLoader(
                height: double.infinity,
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              await productVm.getInventoryProducts();
            },
            child: ListView(
              padding: EdgeInsets.only(
                left: Sizer.width(16),
                right: Sizer.width(16),
                bottom: Sizer.height(50),
              ),
              controller: _scrollController,
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
                      FilterHeader(
                        title: "Inventory Overview",
                        subTitle: "View and manage products inventory.",
                      ),
                      YBox(16),
                      Container(
                        width: double.infinity,
                        height: Sizer.height(200),
                        padding: EdgeInsets.all(Sizer.radius(16)),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.blueDD9),
                          borderRadius: BorderRadius.circular(Sizer.radius(4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductColText(
                              title: "TOTAL PRODUCTS VALUE",
                              value:
                                  "${AppUtils.nairaSymbol}${AppUtils.formatNumber(decimalPlaces: 2, number: productVm.productStats?.totalProductsValue ?? 0)}",
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Total Products",
                                    value: AppUtils.formatNumber(
                                        number: double.tryParse(productVm
                                                    .productStats
                                                    ?.totalProducts ??
                                                "0") ??
                                            0),
                                    valueTextSize: 12,
                                  ),
                                ),
                                Expanded(
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Available",
                                    value: AppUtils.formatNumber(
                                        number: double.tryParse(productVm
                                                    .productStats
                                                    ?.availableProducts ??
                                                "0") ??
                                            0),
                                    valueTextSize: 12,
                                    valueColor: AppColors.red2D,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Sold-out Products",
                                    value: AppUtils.formatNumber(
                                        number: double.tryParse(productVm
                                                    .productStats
                                                    ?.totalSoldProducts ??
                                                "0") ??
                                            0),
                                    valueTextSize: 12,
                                    valueColor: AppColors.green1A,
                                  ),
                                ),
                                Expanded(
                                  child: ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Low Stocks",
                                    value: AppUtils.formatNumber(
                                        number: productVm.productStats
                                                ?.lowStockProducts ??
                                            0),
                                    valueTextSize: 12,
                                    valueColor: AppColors.red2D,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      YBox(40),
                      FilterHeader(
                        title: "Inventory List",
                        subTitle: "See all products in inventory",
                        onFilter: () {
                          ModalWrapper.bottomSheet(
                            context: context,
                            widget: FilterDataModal(
                              title: "Filter Products",
                              subtitle: "Filter products by multiple criteria",
                              dateTitle: "Product Added Date",
                              selectorGroups: [
                                SelectorGroup(
                                  key: "status",
                                  title: "Status",
                                  options: [
                                    "All",
                                    "Active",
                                    "Inactive",
                                  ],
                                  // selectedValue: "All",
                                ),
                              ],
                              showPriceRange: true,
                              onFilter: (filterData) {
                                printty("Filter applied: $filterData");
                              },
                              onReset: () {
                                printty("Filters reset");
                                // Handle reset action here
                              },
                            ),
                          );
                        },
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: searchC,
                        focusNode: searchFocus,
                        isRequired: false,
                        showLabelHeader: false,
                        hintText: "Search by product id, name etc.",
                        onChanged: (value) {
                          setState(() {});
                          _performSearch(value);
                        },
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (searchC.text.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  _clearSearch();
                                  setState(() {});
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(Sizer.width(10)),
                                  child: Icon(
                                    Icons.close,
                                    size: Sizer.width(20),
                                    color: AppColors.gray500,
                                  ),
                                ),
                              ),
                            InkWell(
                              onTap: () {
                                _performSearch(searchC.text);
                              },
                              child: Container(
                                padding: EdgeInsets.all(Sizer.width(10)),
                                decoration: BoxDecoration(
                                    border: Border(
                                  left: BorderSide(
                                    color: AppColors.neutral5,
                                  ),
                                )),
                                child: SvgPicture.asset(AppSvgs.search),
                              ),
                            ),
                          ],
                        ),
                      ),
                      YBox(10),
                      LoadableContentBuilder(
                          isBusy: productVm.busy(searchState),
                          items: productVm.inventoryProducts,
                          loadingBuilder: (context) {
                            return SizerLoader(height: 300);
                          },
                          emptyBuilder: (context) {
                            return SizedBox(
                              height: Sizer.height(240),
                              child: EmptyListState(
                                text: "No data",
                              ),
                            );
                          },
                          contentBuilder: (context) {
                            return Column(
                              children: [
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(
                                    top: Sizer.height(14),
                                    bottom: Sizer.height(20),
                                  ),
                                  itemCount: productVm.inventoryProducts.length,
                                  separatorBuilder: (_, __) => HDivider(),
                                  itemBuilder: (ctx, i) {
                                    final product =
                                        productVm.inventoryProducts[i];
                                    return ProductWithStatusListTile(
                                      productImage:
                                          product.primaryMediaUrl ?? "",
                                      productTitle: product.name ?? '',
                                      subTitle: product.productType ?? '',
                                      subTitle1: "Category: ",
                                      subValue1: product.category ?? 'N/A',
                                      subTitle2: "Stock level: ",
                                      subValue2: "${product.quantity} left",
                                      status: product.status ?? '',
                                      onTap: () {
                                        ModalWrapper.bottomSheet(
                                          context: context,
                                          widget: StoreOptionModal(options: [
                                            ModalOption(
                                              title: "View inventory details",
                                              onTap: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  RoutePath
                                                      .inventoryDetailsScreen,
                                                  arguments: product,
                                                );
                                              },
                                            ),
                                            ModalOption(
                                              title: "Edit inventory",
                                              onTap: () {
                                                Navigator.pop(context);
                                                // ModalWrapper.bottomSheet(
                                                //   context: context,
                                                //   widget: EditInventoryModal(
                                                //     product: product,
                                                //   ),
                                                // );
                                                Navigator.pushNamed(
                                                  context,
                                                  RoutePath.editInventoryScreen,
                                                  arguments: product,
                                                );
                                              },
                                            ),
                                            ModalOption(
                                              title: "Trigger Re-order",
                                              textColor: AppColors.red2D,
                                              onTap: () async {
                                                Navigator.pop(context);
                                                final result =
                                                    await ModalWrapper
                                                        .bottomSheet(
                                                  context: context,
                                                  widget: ConfirmationModal(
                                                    modalConfirmationArg:
                                                        ModalConfirmationArg(
                                                      iconPath:
                                                          AppSvgs.infoCircleRed,
                                                      title: "Trigger Reorder",
                                                      description:
                                                          "Are you sure you want to trigger a reorder of this product? Procurement will be notified of this restock request.",
                                                      solidBtnText:
                                                          "Yes, trigger",
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

                                                if (result == true) {
                                                  final res = await ref
                                                      .read(
                                                          productInventoryVmodel)
                                                      .triggerReorder(
                                                    ids: [product.id ?? ''],
                                                  );

                                                  handleApiResponse(
                                                      response: res,
                                                      onSuccess: () {
                                                        productVm
                                                            .getInventoryProducts();
                                                      });
                                                }
                                              },
                                            ),
                                          ]),
                                        );
                                      },
                                    );
                                  },
                                ),
                                if (productVm.busy(paginateState))
                                  SpinKitLoader(
                                    size: 16,
                                    color: AppColors.neutral5,
                                  ),
                                if (productVm.error(paginateState))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: ErrorState(
                                      onPressed: () {
                                        productVm.getInventoryProducts(
                                            busyObjectName: paginateState);
                                      },
                                      isPaginationType: true,
                                    ),
                                  )
                              ],
                            );
                          }),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
