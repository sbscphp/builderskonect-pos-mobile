import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomerReturnsTab extends ConsumerStatefulWidget {
  const CustomerReturnsTab({
    super.key,
    required this.customer,
  });

  final CustomerData customer;

  @override
  CustomerReturnsTabState createState() => CustomerReturnsTabState();
}

class CustomerReturnsTabState extends ConsumerState<CustomerReturnsTab> {
  final searchC = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchOverViewData();
      _scrollListener();
    });
  }

  fetchOverViewData() {
    ref
        .read(customerVmodel)
        .getCustomerReturnsOverview(customerId: widget.customer.id ?? '');
  }

  _scrollListener() {
    final vm = ref.watch(customerVmodel);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!vm.busy(paginateState) &&
            vm.csReviewpageNumber < (vm.csReviewlastPage ?? 1)) {
          vm.getCustomerReturnsOverview(
              customerId: widget.customer.id ?? '',
              busyObjectName: paginateState);
        }
      }
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    // final refundsVm = ref.watch(refundReturnsVm);
    final vm = ref.watch(customerVmodel);

    return RefreshIndicator(
      onRefresh: () async {
        fetchOverViewData();
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
            child: LoadableContentBuilder(
                isBusy: vm.busy(getState),
                isError: vm.error(getState),
                loadingBuilder: (p0) {
                  return SizedBox(
                    height: Sizer.height(500),
                    width: Sizer.screenWidth,
                    child: SizerLoader(
                      height: double.infinity,
                    ),
                  );
                },
                errorBuilder: (ctx) {
                  return SizedBox(
                    height: Sizer.height(500),
                    width: Sizer.screenWidth,
                    child: ErrorState(
                      message: "Failed to load store sales overview",
                      onPressed: () {},
                    ),
                  );
                },
                contentBuilder: (context) {
                  if (vm.customerReturns.isEmpty) {
                    return SizedBox(
                      height: Sizer.height(500),
                      child: EmptyListState(
                          text: "Customer currently have no Returns."),
                    );
                  }
                  return Column(
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
                                    "Active",
                                    "Expired",
                                    "Scheduled"
                                  ],
                                  selectedValue: "All",
                                ),
                                SelectorGroup(
                                  key: "type",
                                  title: "Loyalty Type",
                                  selectedValue: "All",
                                  options: [
                                    "All",
                                    "Discount",
                                    "Coupon",
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
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
                              title: "TOTAL REFUND VALUE",
                              value: AppUtils.formatNumber(
                                  decimalPlaces: 2,
                                  number: double.tryParse(vm.customerReturnStats
                                              ?.totalRefundValue ??
                                          '0') ??
                                      0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ProductColText(
                                  textColor: colorScheme.black85,
                                  title: "Total Returns",
                                  value: AppUtils.formatNumber(
                                      number: vm.customerReturnStats
                                              ?.totalReturns ??
                                          0),
                                  valueTextSize: Sizer.text(12),
                                ),
                                ProductColText(
                                  textColor: colorScheme.black85,
                                  title: "Approved Returns",
                                  value: AppUtils.formatNumber(
                                      number: vm.customerReturnStats
                                              ?.approvedRequest ??
                                          0),
                                  valueTextSize: Sizer.text(12),
                                  valueColor: AppColors.green7,
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
                                      number: vm.customerReturnStats
                                              ?.cancelledRequest ??
                                          0),
                                  valueTextSize: Sizer.text(12),
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
                        onFilter: () {},
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: searchC,
                        isRequired: false,
                        showLabelHeader: false,
                        hintText: "Search by product id, name etc.",
                        onChanged: (value) {
                          Debouncer().performAction(action: () async {
                            await vm.getCustomerReturnsOverview(
                                customerId: widget.customer.id ?? '',
                                q: value,
                                busyObjectName: searchState);
                          });
                          setState(() {});
                        },
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {},
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
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: Sizer.height(14),
                        ),
                        itemCount: vm.customerReturns.length,
                        separatorBuilder: (_, __) => HDivider(),
                        itemBuilder: (ctx, i) {
                          final refund = vm.customerReturns[i];
                          return CustomColWidget(
                            firstColText: refund.orderID ?? "",
                            subTitle: "total items: ",
                            subTitle2: "2",
                            status: refund.status ?? "",
                            date: refund.dateReturned?.toLocal(),
                            onTap: () {
                              // Navigator.pushNamed(
                              //   context,
                              //   RoutePath.viewReturnsScreen,
                              //   arguments: refund,
                              // );
                            },
                          );
                        },
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
