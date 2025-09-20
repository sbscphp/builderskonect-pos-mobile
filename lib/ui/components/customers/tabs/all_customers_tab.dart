import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class AllCustomersTab extends ConsumerStatefulWidget {
  const AllCustomersTab({super.key});

  @override
  ConsumerState<AllCustomersTab> createState() => _AllCustomersTabState();
}

class _AllCustomersTabState extends ConsumerState<AllCustomersTab> {
  final searchC = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final customerVm = ref.read(customerVmodel);
      if (customerVm.customerData.isEmpty) {
        ref.read(customerVmodel).getCustomerOverview();
      }
      _scrollListener();
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _scrollListener() {
    final vm = ref.watch(customerVmodel);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!vm.busy(paginateState) && vm.pageNumber <= (vm.lastPage ?? 1)) {
          vm.getCustomerOverview(busyObjectName: paginateState);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customerVm = ref.watch(customerVmodel);
    return RefreshIndicator(
      onRefresh: () async {
        customerVm.getCustomerOverview();
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
                  title: "Customer Overview",
                  subTitle: "Manage online and walk-in customers",
                  // svgIcon: AppSvgs.circleAdd,
                  // trailingWidget: NewButtonWidget(
                  //   onTap: () {
                  //     Navigator.pushNamed(context, RoutePath.newCustomerScreen);
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
                        title: "TOTAL CUSTOMERS",
                        value:
                            customerVm.customerStats?.total.toString() ?? '0',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProductColText(
                            textColor: colorScheme.black85,
                            title: "Online Customers",
                            value: customerVm.onlineCustomerStats?.online
                                    .toString() ??
                                '0',
                            valueTextSize: 12,
                            valueColor: AppColors.primaryBlue,
                          ),
                          ProductColText(
                            textColor: colorScheme.black85,
                            title: "Walk-in Customers",
                            value: customerVm.onlineCustomerStats?.offline
                                    .toString() ??
                                '0',
                            valueTextSize: 12,
                            valueColor: AppColors.purple6,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                YBox(40),
                FilterHeader(
                  title: "All Customers",
                  subTitle: "See all customers that hav returns your business",
                  onFilter: () async {
                    ModalWrapper.bottomSheet(
                        context: context,
                        widget: FilterDataModal(
                          selectorGroups: [
                            SelectorGroup(
                              key: "channel",
                              title: "Channel",
                              options: [
                                "All",
                                "Online",
                                "Walk-in",
                              ],
                              // selectedValue: staffStatus,
                            ),
                          ],
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
                  isRequired: false,
                  showLabelHeader: false,
                  hintText: "Search by customer ID, name etc",
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
                Builder(builder: (context) {
                  if (customerVm.busy(getState)) {
                    return SizerLoader(height: 300);
                  }
                  if (customerVm.customerData.isEmpty) {
                    return SizedBox(
                      height: Sizer.height(300),
                      child: EmptyListState(
                        text: "No Data",
                      ),
                    );
                  }
                  return Column(
                    children: [
                      YBox(10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: Sizer.height(14),
                          bottom: Sizer.height(50),
                        ),
                        itemCount: customerVm.customerData.length,
                        separatorBuilder: (_, __) => HDivider(),
                        itemBuilder: (ctx, i) {
                          final customer = customerVm.customerData[i];
                          return CustomerListTile(
                            customerId: "#${customer.customerId ?? ""}",
                            title: customer.name ?? "N/A",
                            subTitle: customer.email ?? "N/A",
                            channel: customer.channel?.toLowerCase() ==
                                    "offline"
                                ? "Walk-in"
                                : customer.channel?.capitalizeFirst ?? "N/A",
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                RoutePath.viewCustomerScreen,
                                arguments: customer,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  );
                }),
                if (customerVm.busy(paginateState))
                  SpinKitLoader(
                    size: 16,
                    color: AppColors.neutral5,
                  ),
                if (customerVm.error(paginateState))
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: ErrorState(
                      onPressed: () {
                        customerVm.getCustomerOverview(
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
    );
  }
}
