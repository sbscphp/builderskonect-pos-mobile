import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class AllSalesOverview extends ConsumerStatefulWidget {
  const AllSalesOverview({super.key});

  @override
  ConsumerState<AllSalesOverview> createState() => _AllSalesOverviewState();
}

class _AllSalesOverviewState extends ConsumerState<AllSalesOverview> {
  final searchC = TextEditingController();
  final searchFocus = FocusNode();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollListener();
      ref.read(salesVmodel).getSalesOverview();
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    searchFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    final vm = ref.watch(salesVmodel);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!vm.busy(paginateState) && vm.pageNumber <= (vm.lastPage ?? 1)) {
          vm.getSalesOverview(stateObjectName: paginateState);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final salesVm = ref.watch(salesVmodel);
    return Builder(builder: (context) {
      if (salesVm.busy(getState)) {
        return SizerLoader(
          height: Sizer.height(500),
        );
      }
      if (salesVm.error(getState)) {
        return ErrorState(
          onPressed: () {
            salesVm.getSalesOverview();
          },
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          salesVm.getSalesOverview();
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
                    title: "Sales Overview",
                    subTitle: "View and manage offline and online sales",
                    trailingWidget: NewButtonWidget(
                      onTap: () {
                        Navigator.pushNamed(context, RoutePath.newSalesScreen);
                      },
                    ),
                    onFilter: () {},
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
                          title: "TOTAL SALES VALUE",
                          value:
                              "${AppUtils.nairaSymbol}${salesVm.salesStats?.totalSalesValue}",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Total Sales",
                              value: AppUtils.formatNumber(
                                  number: salesVm.salesStats?.totalSales ?? 0),
                              valueTextSize: 12,
                            ),
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Online Sales",
                              value:
                                  "${AppUtils.nairaSymbol}${salesVm.salesStats?.onlineSales}",
                              valueTextSize: 12,
                              valueColor: AppColors.purple6,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Walk-in Sales",
                              value:
                                  "${AppUtils.nairaSymbol}${salesVm.salesStats?.offlineSales}",
                              valueTextSize: 12,
                              valueColor: AppColors.red2D,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  YBox(24),
                  FilterHeader(
                    title: "Sales List",
                    subTitle: "See all sales made in your business",
                    onFilter: () {
                      ModalWrapper.bottomSheet(
                          context: context,
                          widget: FilterDataModal(
                            selectorGroups: [
                              SelectorGroup(
                                key: "status",
                                title: "Status",
                                options: [
                                  "All",
                                  "Shipped",
                                  "Failed",
                                  "Completed"
                                ],
                                selectedValue: "All",
                              ),
                            ],
                            // showPriceRange: true,//todo:NOT IN DOC
                            onFilter: (filterData) {
                              // printty("Filter applied: $filterData");
                              salesVm.getSalesOverview(
                                  dateFilter: filterData["date_filter"],
                                  status: filterData["selectorGroups"]
                                              ["status"] ==
                                          "All"
                                      ? ''
                                      : (filterData["selectorGroups"]["status"]
                                              as String)
                                          .toLowerCase());
                            },
                          ));
                    },
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: searchC,
                    isRequired: false,
                    showLabelHeader: false,
                    hintText: "Search by product id, name etc.",
                    onChanged: (value) {
                      setState(() {});
                    },
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (searchC.text.isNotEmpty)
                          InkWell(
                            onTap: () {},
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
                            decoration: BoxDecoration(),
                            child: SvgPicture.asset(AppSvgs.search),
                          ),
                        ),
                      ],
                    ),
                  ),
                  YBox(10),
                  Builder(builder: (context) {
                    if (salesVm.salesData.isEmpty) {
                      return SizedBox(
                        child: EmptyListState(
                          text: "No Data",
                        ),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: Sizer.height(14),
                      ),
                      itemCount: salesVm.salesData.length,
                      separatorBuilder: (_, __) => HDivider(),
                      itemBuilder: (ctx, i) {
                        final data = salesVm.salesData[i];
                        return CustomColWidget(
                          firstColText: "#${data.orderNumber ?? ""}",
                          subTitle: "Total items: ",
                          subTitle2: data.itemsCount?.toString() ?? "",
                          status: data.status ?? "",
                          date: data.orderDate?.toLocal(),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutePath.viewSalesOrderScreen,
                              arguments: data.id,
                            );
                          },
                        );
                      },
                    );
                  }),
                  if (salesVm.busy(paginateState))
                    SpinKitLoader(
                      size: 16,
                      color: AppColors.neutral5,
                    ),
                  if (salesVm.error(paginateState))
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ErrorState(
                        onPressed: () {
                          salesVm.getSalesOverview(
                              stateObjectName: paginateState);
                        },
                        isPaginationType: true,
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
