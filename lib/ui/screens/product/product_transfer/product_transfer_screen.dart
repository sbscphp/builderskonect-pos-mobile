import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductTransferScreen extends ConsumerStatefulWidget {
  const ProductTransferScreen({super.key});

  @override
  ConsumerState<ProductTransferScreen> createState() =>
      _ProductTransferScreenState();
}

class _ProductTransferScreenState extends ConsumerState<ProductTransferScreen> {
  final searchC = TextEditingController();
  final searchFocus = FocusNode();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchOverviewData();
      scrollListener();
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    searchFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  fetchOverviewData({bool isRefresh = false}) async {
    final vm = ref.read(productTransferVm);
    if (isRefresh) {
      await vm.getTransferProducts();
    } else if (vm.transferProducts.isEmpty) {
      await vm.getTransferProducts();
    }
  }

  scrollListener() {
    final vm = ref.watch(productTransferVm);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!vm.busy(paginateState) && vm.pageNumber <= (vm.lastPage ?? 1)) {
          vm.getTransferProducts(busyObjectName: paginateState);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productTransferVm);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Product Transfers",
      ),
      body: LoadableContentBuilder(
          isBusy: vm.busy(getState),
          isError: vm.error(getState),
          loadingBuilder: (p0) {
            return SizerLoader(
              height: double.infinity,
            );
          },
          errorBuilder: (ctx) {
            return ErrorState(
              message: "Failed to load store sales overview",
              onPressed: () {
                fetchOverviewData();
              },
            );
          },
          contentBuilder: (context) {
            return RefreshIndicator(
              onRefresh: () async {
                fetchOverviewData(isRefresh: true);
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
                    height: Sizer.screenHeight * 0.8,
                    padding: EdgeInsets.all(Sizer.radius(16)),
                    decoration: BoxDecoration(
                      color: colorScheme.white,
                      borderRadius: BorderRadius.circular(Sizer.radius(4)),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FilterHeader(
                            title: "Product Transfer Overview",
                            subTitle: "View and manage products transfers.",
                            trailingWidget: NewButtonWidget(
                              onTap: () {
                                Navigator.pushNamed(context,
                                    RoutePath.productTransferRequestScreen);
                              },
                            ),
                          ),
                          YBox(16),
                          Container(
                            width: double.infinity,
                            height: Sizer.height(140),
                            padding: EdgeInsets.all(Sizer.radius(16)),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.blueDD9),
                              borderRadius:
                                  BorderRadius.circular(Sizer.radius(4)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ProductColText(
                                  title: "STOCK RECEIVED VALUE",
                                  value:
                                      "${AppUtils.nairaSymbol}${AppUtils.formatNumber(decimalPlaces: 2, number: vm.stockValue)}",
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ProductColText(
                                      textColor: colorScheme.black85,
                                      title: "No of Stock Received",
                                      value: vm.stockReceived,
                                      valueTextSize: 12,
                                      // valueColor: AppColors.green1A,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          YBox(40),
                          FilterHeader(
                            title: "Transfers List",
                            subTitle:
                                "See all products going in and out of your inventory.",
                            onFilter: () {
                              ModalWrapper.bottomSheet(
                                context: context,
                                widget: FilterDataModal(
                                  title: "Filter Products",
                                  subtitle:
                                      "Filter products by multiple criteria",
                                  dateTitle: "Date Requested",
                                  selectorGroups: [
                                    SelectorGroup(
                                      key: "status",
                                      title: "Status",
                                      options: [
                                        "All",
                                        "Pending",
                                        "Approved",
                                        "Decline",
                                        // "Request Sent",
                                        "Action Taken",
                                        // "Low stock",
                                      ],
                                      selectedValue: "All",
                                    ),
                                  ],
                                  onFilter: (filterData) {
                                    vm.getTransferProducts(
                                        busyObjectName: filterState,
                                        dateFilter: filterData['date_filter'],
                                        status: filterData["selectorGroups"]
                                                    ["status"] ==
                                                "All"
                                            ? ''
                                            : (filterData["selectorGroups"]
                                                    ["status"] as String)
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
                            hintText: "Search by transfer id, store etc.",
                            onChanged: (value) {
                              Debouncer().performAction(action: () async {
                                await vm.getTransferProducts(
                                    q: value, busyObjectName: searchState);
                              });
                              setState(() {});
                            },
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (searchC.text.isNotEmpty)
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        searchC.clear();
                                      });
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
                                  onTap: () {},
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
                          Builder(builder: (context) {
                            if (vm.busy(filterState) || vm.busy(searchState)) {
                              return SizerLoader(
                                height: 200,
                              );
                            }
                            if (vm.transferProducts.isEmpty) {
                              return EmptyListState(text: "No Data Found!");
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(
                                top: Sizer.height(14),
                              ),
                              itemCount: vm.transferProducts.length,
                              separatorBuilder: (_, __) => HDivider(),
                              itemBuilder: (ctx, i) {
                                final product = vm.transferProducts[i];
                                return CustomColWidget(
                                  firstColText:
                                      "#${product.reference ?? '---'}",
                                  subTitle: "Qty Requested:",
                                  subTitle2:
                                      product.quantity?.toString() ?? '0',
                                  status: product.status ?? '',
                                  date:
                                      (product.dateInitiated ?? DateTime.now())
                                          .toLocal(),
                                  onTap: () {
                                    // Navigator.pushNamed(
                                    //   context,
                                    //   RoutePath.viewSalesOrderScreen,
                                    //   arguments: data.id,
                                    // );
                                    Navigator.pushNamed(context,
                                        RoutePath.viewProductTransferScreen,
                                        arguments: product.id ?? ''
                                        // arguments: data.id,
                                        );
                                  },
                                );
                              },
                            );
                          }),
                          if (vm.busy(paginateState))
                            SpinKitLoader(
                              size: 16,
                              color: AppColors.neutral5,
                            ),
                          if (vm.error(paginateState))
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: ErrorState(
                                onPressed: () {
                                  vm.getTransferProducts(
                                      busyObjectName: paginateState);
                                },
                                isPaginationType: true,
                              ),
                            )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
