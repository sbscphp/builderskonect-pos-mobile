import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomerOrdersTab extends ConsumerStatefulWidget {
  const CustomerOrdersTab({
    super.key,
    required this.customer,
  });

  final CustomerData customer;

  @override
  CustomerOrdersTabState createState() => CustomerOrdersTabState();
}

class CustomerOrdersTabState extends ConsumerState<CustomerOrdersTab> {
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
        .getCustomerOrderOverview(customerId: widget.customer.id ?? '');
  }

  _scrollListener() {
    final vm = ref.watch(customerVmodel);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!vm.busy(paginateState) &&
            vm.csReviewpageNumber < (vm.csReviewlastPage ?? 1)) {
          vm.getCustomerOrderOverview(
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
    final vm = ref.watch(customerVmodel);

    return Expanded(
      child: RefreshIndicator(
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
                    if (vm.customerOrders.isEmpty) {
                      return SizedBox(
                        height: Sizer.height(500),
                        child: EmptyListState(
                            text: "Customer currently have no Order."),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FilterHeader(
                          title: "Customer Orders",
                          subTitle: "View all customer orders below",
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
                                title: "TOTAL ORDERS VALUE",
                                value:
                                    "${AppUtils.nairaSymbol}${AppUtils.formatNumber(decimalPlaces: 2, number: num.tryParse(vm.customerOrderStats?.totalSalesValue ?? '0') ?? 0)}",
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ProductColText(
                                    textColor: colorScheme.black85,
                                    title: "Total Orders",
                                    value: AppUtils.formatNumber(
                                        number: num.tryParse(vm
                                                    .customerOrderStats
                                                    ?.totalSales
                                                    ?.toString() ??
                                                '0') ??
                                            0),
                                    valueTextSize: 12,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        YBox(24),
                        FilterHeader(
                          title: "All Orders",
                          subTitle: "See all orders by this customer",
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
                        CustomTextField(
                          controller: searchC,
                          isRequired: false,
                          showLabelHeader: false,
                          hintText: "Search by product id, name etc.",
                          onChanged: (value) {
                            Debouncer().performAction(action: () async {
                              await vm.getCustomerOrderOverview(
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
                          itemCount: vm.customerOrders.length,
                          separatorBuilder: (_, __) => HDivider(),
                          itemBuilder: (ctx, i) {
                            final order = vm.customerOrders[i];
                            return CustomColWidget(
                              firstColText: "#${order.orderNumber ?? "---"}",
                              subTitle: "total items: ",
                              subTitle2: "${order.itemsCount ?? 0}",
                              status: order.status ?? '',
                              date: order.date ?? DateTime.now(),
                              onTap: () {},
                            );
                          },
                        ),
                      ],
                    );
                  }),
            ),
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
                    vm.getCustomerOrderOverview(
                        customerId: widget.customer.id ?? '',
                        busyObjectName: paginateState);
                  },
                  isPaginationType: true,
                ),
              )
          ],
        ),
      ),
    );
  }
}
