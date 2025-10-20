import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ReturnRefundScreen extends ConsumerStatefulWidget {
  const ReturnRefundScreen({super.key});

  @override
  ConsumerState<ReturnRefundScreen> createState() => _ReturnRefundScreenState();
}

class _ReturnRefundScreenState extends ConsumerState<ReturnRefundScreen> {
  final searchC = TextEditingController();
  final searchFocus = FocusNode();
  final _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _init();
      _scrollListener();
    });
  }

  _init() async {
    await ref.read(refundReturnsVm).getReturnsOverview();
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
      final refundsVm = ref.read(refundReturnsVm);
      refundsVm.getReturnsOverview(q: query.trim());
    });
  }

  void _clearSearch() {
    searchC.clear();
    final refundsVm = ref.read(refundReturnsVm);
    refundsVm.getReturnsOverview();
  }

  _scrollListener() {
    final vm = ref.watch(refundReturnsVm);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!vm.busy(paginateState) && vm.pageNumber <= (vm.lastPage ?? 1)) {
          vm.getReturnsOverview(busyObjectName: paginateState);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final refundsVm = ref.watch(refundReturnsVm);
    final staffRef = ref.watch(staffVm);
    return BusyOverlay(
      show: refundsVm.busy(getState),
      child: Scaffold(
          appBar: CustomAppbar(
            title: "Returns and Refund",
          ),
          body: !staffRef.hasAccessToReturns
              ? RequestAccessWidget(
                  isLoading: staffRef.busy(RowParams.returns),
                  onRequestAccess: () async {
                    final res = await staffRef
                        .requestApplicationAccess(RowParams.returns);

                    handleApiResponse(response: res);
                  },
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    refundsVm.getReturnsOverview();
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
                              title: "Returns & Refund Overview",
                              subTitle: "View and manage logged returns ",
                              trailingWidget: NewButtonWidget(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RoutePath.logNewReturnScreen);
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
                                borderRadius:
                                    BorderRadius.circular(Sizer.radius(4)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ProductColText(
                                    title: "TOTAL REFUND VALUE",
                                    value: AppUtils.formatNumber(
                                        decimalPlaces: 2,
                                        number: double.tryParse(refundsVm
                                                    .stats?.totalRefundValue ??
                                                '0') ??
                                            0),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ProductColText(
                                        textColor: colorScheme.black85,
                                        title: "Total Returns",
                                        value: AppUtils.formatNumber(
                                            number:
                                                refundsVm.stats?.totalReturns ??
                                                    0),
                                        valueTextSize: 12,
                                      ),
                                      ProductColText(
                                        textColor: colorScheme.black85,
                                        title: "Approved Returns",
                                        value: AppUtils.formatNumber(
                                            number: refundsVm
                                                    .stats?.approvedRequest ??
                                                0),
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
                                        title: "Rejected Returns",
                                        value: AppUtils.formatNumber(
                                            number: refundsVm
                                                    .stats?.cancelledRequest ??
                                                0),
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
                              title: "Logged Returns",
                              subTitle: "See all logged returns your business",
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
                                            "Processing",
                                            "Cancelled",
                                            "Completed",
                                          ],
                                          // selectedValue: staffStatus,
                                        ),
                                      ],
                                      showPriceRange: true,
                                      onFilter: (filterData) {
                                        printty("Filter applied: $filterData");
                                        // staffViewModel.getDashboardStats();
                                      },
                                      onReset: () {
                                        printty("Filters reset");
                                        // Handle reset action here
                                      },
                                    ));
                              },
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: searchC,
                              focusNode: searchFocus,
                              isRequired: false,
                              showLabelHeader: false,
                              hintText: "Search by return id, product name etc",
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
                                        padding:
                                            EdgeInsets.all(Sizer.width(10)),
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
                                      padding: EdgeInsets.all(Sizer.width(14)),
                                      decoration: BoxDecoration(
                                          border: Border(
                                        left: BorderSide(
                                          color: AppColors.neutral5,
                                          width: 1,
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
                                isBusy: refundsVm.busy(getState),
                                isError: refundsVm.error(getState),
                                items: refundsVm.refundData,
                                loadingBuilder: (p0) {
                                  return SizedBox.shrink();
                                },
                                emptyBuilder: (context) {
                                  return SizedBox(
                                    height: Sizer.height(600),
                                    child: EmptyListState(
                                      text: "No Data",
                                    ),
                                  );
                                },
                                contentBuilder: (context) {
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(
                                      top: Sizer.height(14),
                                    ),
                                    itemCount: refundsVm.refundData.length,
                                    separatorBuilder: (_, __) => HDivider(),
                                    itemBuilder: (ctx, i) {
                                      final refund = refundsVm.refundData[i];
                                      return CustomColWidget(
                                        firstColText: refund.orderId ?? "",
                                        subTitle: "total items: ",
                                        subTitle2: "2",
                                        status: refund.status ?? "",
                                        date: refund.dateReturned?.toLocal(),
                                        onTap: () {
                                          Navigator.pushNamed(
                                            context,
                                            RoutePath.viewReturnsScreen,
                                            arguments: refund,
                                          );
                                        },
                                      );
                                    },
                                  );
                                }),
                            if (refundsVm.busy(paginateState))
                              SpinKitLoader(
                                size: 16,
                                color: AppColors.neutral5,
                              ),
                            if (refundsVm.error(paginateState))
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: ErrorState(
                                  onPressed: () {
                                    refundsVm.getReturnsOverview(
                                        busyObjectName: paginateState);
                                  },
                                  isPaginationType: true,
                                ),
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }
}
