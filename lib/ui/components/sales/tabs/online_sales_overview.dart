import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class OnlineSalesOverview extends ConsumerStatefulWidget {
  const OnlineSalesOverview({super.key});

  @override
  ConsumerState<OnlineSalesOverview> createState() =>
      _OnlineSalesOverviewState();
}

class _OnlineSalesOverviewState extends ConsumerState<OnlineSalesOverview> {
  final searchC = TextEditingController();
  final searchFocus = FocusNode();
  final _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getOnlineSales();
      _scrollListener();
    });
  }

  _getOnlineSales() {
    ref.read(salesVmodel).getSalesOverview(salesType: SalesType.omp.text);
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
      final salesVm = ref.read(salesVmodel);
      salesVm.getSalesOverview(q: query.trim(), salesType: SalesType.omp.text);
    });
  }

  void _clearSearch() {
    searchC.clear();
    final salesVm = ref.read(salesVmodel);
    salesVm.getSalesOverview(salesType: SalesType.omp.text);
  }

  _scrollListener() {
    final vm = ref.watch(salesVmodel);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!vm.busy(paginateState) && vm.pageNumber <= (vm.lastPage ?? 1)) {
          vm.getSalesOverview(
              stateObjectName: paginateState, salesType: SalesType.omp.text);
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
            _getOnlineSales();
          },
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          salesVm.getSalesOverview(salesType: SalesType.omp.text);
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
                          title: "TOTAL SALES VALUE",
                          value:
                              "${AppUtils.nairaSymbol}${salesVm.salesStats?.onlineSales}",
                        ),
                        ProductColText(
                          textColor: colorScheme.black85,
                          title: "Total Online Sales",
                          value: AppUtils.formatNumber(
                              number:
                                  salesVm.salesStats?.onlineSalesVolume ?? 0),
                          valueTextSize: 12,
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
                                  salesType: SalesType.omp.text,
                                  stateObjectName: searchState,
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
                    hintText: "Search by order id, name etc",
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
                            decoration: BoxDecoration(),
                            child: SvgPicture.asset(AppSvgs.search),
                          ),
                        ),
                      ],
                    ),
                  ),
                  YBox(10),
                  LoadableContentBuilder(
                      isBusy: salesVm.busy(searchState),
                      items: salesVm.salesData,
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
                              firstColText: data.orderNumber ?? "",
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
                              stateObjectName: paginateState,
                              salesType: SalesType.omp.text);
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
