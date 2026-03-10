import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class AllProductsAndInventory extends ConsumerStatefulWidget {
  const AllProductsAndInventory({super.key});

  @override
  ConsumerState<AllProductsAndInventory> createState() =>
      _AllProductsAndInventoryState();
}

class _AllProductsAndInventoryState
    extends ConsumerState<AllProductsAndInventory> {
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

  void _performSearch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final productVm = ref.read(productInventoryVmodel);
      productVm.getInventoryProducts(
        q: query.trim(),
        busyObjectName: searchState,
      );
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
    return Builder(
      builder: (context) {
        if (productVm.busy(getState)) {
          return const Center(
            child: SizerLoader(
              height: double.infinity,
            ),
          );
        }
        if (productVm.error(getState)) {
          return ErrorState(
            onPressed: () {
              productVm.getInventoryProducts();
            },
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
                      title: "Products and Inventory",
                      subTitle: "View products in your business",
                      // todo:::NOTE::: > FEATURE not FEASIBLE on MOBILE
                      // trailingWidget: NewButtonWidget(
                      //   onTap: () {
                      //     Navigator.pushNamed(
                      //         context, RoutePath.searchAddProductScreen);
                      //   },
                      // ),
                    ),
                    YBox(16),
                    Container(
                      width: double.infinity,
                      height: Sizer.height(140),
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
                            title: "TOTAL PRODUCT VALUE",
                            value:
                                "${AppUtils.nairaSymbol}${AppUtils.formatNumber(decimalPlaces: 2, number: productVm.productStats?.totalProductsValue ?? 0)}",
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ProductColText(
                                textColor: colorScheme.black85,
                                title: "Total Products",
                                value:
                                    "${productVm.productStats?.totalProducts ?? 0}",
                                valueTextSize: 12,
                                // valueColor: AppColors.green1A,
                              ),
                              ProductColText(
                                textColor: colorScheme.black85,
                                title: "Total Sales",
                                value:
                                    "${AppUtils.nairaSymbol}${AppUtils.formatNumber(decimalPlaces: 2, number: double.tryParse(productVm.productStats?.totalSales?.toString() ?? "0") ?? 0)}",
                                valueTextSize: 12,
                                valueColor: AppColors.green1A,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    YBox(40),
                    FilterHeader(
                      title: "All Products",
                      subTitle: "See all products added to your business.",
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
                                  "Not active",
                                  "Sold out",
                                  "Low stock",
                                ],
                                selectedValue: "All",
                              ),
                            ],
                            // showPriceRange: true,
                            onFilter: (filterData) {
                              // printty("Filter applied: $filterData");
                              productVm.getInventoryProducts(
                                  busyObjectName: searchState,
                                  dateFilter: filterData['date_filter'],
                                  status: filterData["selectorGroups"]
                                              ["status"] ==
                                          "All"
                                      ? ''
                                      : (filterData["selectorGroups"]["status"]
                                              as String)
                                          .toLowerCase());
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
                                  bottom: Sizer.height(80),
                                ),
                                itemCount: productVm.inventoryProducts.length,
                                separatorBuilder: (_, __) => HDivider(),
                                itemBuilder: (ctx, i) {
                                  final product =
                                      productVm.inventoryProducts[i];
                                  return ProductWithStatusListTile(
                                    productImage: product.primaryMediaUrl ?? "",
                                    productTitle: product.name ?? '',
                                    subTitle: product.productType ?? '',
                                    subTitle1: "Price: ",
                                    subValue1:
                                        "${AppUtils.nairaSymbol}${AppUtils.formatNumber(decimalPlaces: 2, number: double.tryParse(product.costPrice ?? "0") ?? 0)}",
                                    subTitle2: "Stock level: ",
                                    subValue2: "${product.quantity} left",
                                    status: product.status ?? '',
                                    onTap: () {
                                      ModalWrapper.bottomSheet(
                                        context: context,
                                        widget: StoreOptionModal(options: [
                                          ModalOption(
                                            title: "View product details",
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                RoutePath
                                                    .viewProductDetailsScreen,
                                                arguments: product,
                                              );
                                            },
                                          ),
                                          // ModalOption(
                                          //   title: "Edit product details",
                                          //   onTap: () {},
                                          // ),
                                          ModalOption(
                                            title: "Delete product",
                                            textColor: AppColors.red2D,
                                            onTap: () {
                                              _deleteProduct(product.id ?? '');
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
                        })
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _deleteProduct(String productId) {
    final loadingProvider = StateProvider<bool>((ref) => false);
    ModalWrapper.bottomSheet(
      context: context,
      widget: Consumer(
        builder: (context, ref, child) {
          final isLoading = ref.watch(loadingProvider);
          return ConfirmationModal(
            modalConfirmationArg: ModalConfirmationArg(
              iconPath: AppSvgs.infoCircleRed,
              title: "Delete Product",
              description:
                  "Are you sure you want to delete this product from your product list and inventory? This cannot be undone.",
              solidBtnText: "Yes, delete",
              isLoading: isLoading,
              onSolidBtnOnTap: () async {
                final prodVm = ref.read(productInventoryVmodel);
                ref.read(loadingProvider.notifier).state = true;
                final ctx = NavKey.appNavKey.currentContext!;

                bool hasNavigated = false;

                try {
                  final res = await prodVm.deleteProduct(productId: productId);
                  handleApiResponse(
                    response: res,
                    onSuccess: () {
                      // Close the current modal first
                      if (context.mounted && !hasNavigated) {
                        Navigator.pop(ctx);
                        hasNavigated = true;
                      }

                      // Show success modal after a brief delay to prevent navigation conflicts
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (ctx.mounted) {
                          ModalWrapper.bottomSheet(
                            context: ctx,
                            widget: ConfirmationModal(
                              modalConfirmationArg: ModalConfirmationArg(
                                iconPath: AppSvgs.checkIcon,
                                title: "Product Deleted",
                                description:
                                    "The product has been deleted \nsuccessfully.",
                                solidBtnText: "Okay",
                                onSolidBtnOnTap: () {
                                  final currentCtx =
                                      NavKey.appNavKey.currentContext!;
                                  Navigator.pop(currentCtx);
                                },
                              ),
                            ),
                          );
                        }
                      });
                    },
                    onError: () {
                      // Close the modal on error
                      if (context.mounted && !hasNavigated) {
                        Navigator.pop(ctx);
                        hasNavigated = true;
                      }
                    },
                  );
                } catch (e) {
                  // Handle any unexpected errors
                  if (context.mounted && !hasNavigated) {
                    Navigator.pop(ctx);
                    hasNavigated = true;
                  }
                } finally {
                  if (context.mounted) {
                    ref.read(loadingProvider.notifier).state = false;
                    // Only pop if we haven't already navigated
                    if (!hasNavigated) {
                      Navigator.pop(ctx);
                    }
                  }
                }
              },
              onOutlineBtnOnTap: () {
                Navigator.pop(context);
              },
            ),
          );
        },
      ),
    );
  }
}
