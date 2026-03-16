// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class DiscountManagementScreen extends ConsumerStatefulWidget {
  const DiscountManagementScreen({super.key});

  @override
  ConsumerState<DiscountManagementScreen> createState() =>
      _DiscountManagementScreenState();
}

class _DiscountManagementScreenState
    extends ConsumerState<DiscountManagementScreen> {
  final searchC = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDiscountDashboardData();
      _scrollListener();
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _fetchDiscountDashboardData() async {
    await ref.read(discountVm).getDashboardStats();
  }

  _scrollListener() {
    final vm = ref.watch(discountVm);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!vm.busy(paginateState) && vm.pageNumber < (vm.lastPage ?? 1)) {
          vm.getDashboardStats(busyObjectName: paginateState);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final discountViewModel = ref.watch(discountVm);
    final staffRef = ref.watch(staffVm);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Discount Management",
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutePath.newDiscountScreen);
        },
        child: Icon(Icons.add),
      ),
      body: !staffRef.hasAccessToDiscount
          ? RequestAccessWidget(
              isLoading: staffRef.busy(RowParams.customer),
              onRequestAccess: () async {
                final res =
                    await staffRef.requestApplicationAccess(RowParams.discount);
                handleApiResponse(response: res);
              },
            )
          : LoadableContentBuilder(
              isBusy: discountViewModel.isBusy,
              isError: discountViewModel.hasError,
              loadingBuilder: (p0) {
                return SizerLoader(
                  height: double.infinity,
                );
              },
              errorBuilder: (ctx) {
                return ErrorState(
                  message: "Failed to load store sales overview",
                  onPressed: () {},
                );
              },
              contentBuilder: (context) {
                return SizedBox(
                  height: Sizer.screenHeight,
                  width: Sizer.screenWidth,
                  child: BusyOverlay(
                    show: discountViewModel.busy(firstState),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        _fetchDiscountDashboardData();
                      },
                      child: ListView(
                        controller: _scrollController,
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
                              borderRadius:
                                  BorderRadius.circular(Sizer.radius(4)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FilterHeader(
                                  title: "Discounts Overview",
                                  subTitle:
                                      "View and manage all discounts created",
                                  trailingWidget: NewButtonWidget(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        RoutePath.newDiscountScreen,
                                      );
                                      // ModalWrapper.bottomSheet(
                                      //   context: context,
                                      //   widget: StoreOptionModal(options: [
                                      //     ModalOption(
                                      //       title: "Add New Discount",
                                      //       onTap: () {
                                      //         Navigator.pushNamed(
                                      //           context,
                                      //           RoutePath.newDiscountScreen,
                                      //         );
                                      //       },
                                      //     ),
                                      //     ModalOption(
                                      //       title: "Add New Coupon",
                                      //       onTap: () {
                                      //         Navigator.pushNamed(
                                      //           context,
                                      //           RoutePath.newCouponScreen,
                                      //         );
                                      //       },
                                      //     ),
                                      //   ]),
                                      // );
                                    },
                                  ),
                                ),
                                YBox(24),
                                Container(
                                  width: double.infinity,
                                  height: Sizer.height(196),
                                  padding: EdgeInsets.all(Sizer.radius(16)),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColors.blueDD9),
                                    borderRadius:
                                        BorderRadius.circular(Sizer.radius(4)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ProductColText(
                                        title: "TOTAL DISCOUNTS",
                                        value: AppUtils.formatNumber(
                                          number: discountViewModel
                                                  .discountOverviewModel
                                                  ?.stats
                                                  ?.total ??
                                              0,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: ProductColText(
                                              textColor: colorScheme.black85,
                                              title: "Total Active",
                                              value: AppUtils.formatNumber(
                                                number: discountViewModel
                                                        .discountOverviewModel
                                                        ?.stats
                                                        ?.active ??
                                                    0,
                                              ),
                                              valueTextSize: 12,
                                              valueColor: AppColors.primaryBlue,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: ProductColText(
                                              textColor: colorScheme.black85,
                                              title: "Total Expired",
                                              value: AppUtils.formatNumber(
                                                number: discountViewModel
                                                        .discountOverviewModel
                                                        ?.stats
                                                        ?.expired ??
                                                    0,
                                              ),
                                              valueTextSize: 12,
                                              valueColor: AppColors.green1A,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 7,
                                            child: ProductColText(
                                              textColor: colorScheme.black85,
                                              title: "Total Scheduled",
                                              value: AppUtils.formatNumber(
                                                number: discountViewModel
                                                        .discountOverviewModel
                                                        ?.stats
                                                        ?.scheduled ??
                                                    0,
                                              ),
                                              valueTextSize: 12,
                                              valueColor: AppColors.primaryBlue,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: ProductColText(
                                              textColor: colorScheme.black85,
                                              title: "Redemption",
                                              value: '0',
                                              valueTextSize: 12,
                                              valueColor: AppColors.red2D,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                YBox(24),
                                FilterHeader(
                                  title: "Discount List",
                                  subTitle: "See all discounts created",
                                  onFilter: () async {
                                    final res = await ModalWrapper.bottomSheet(
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
                                          //type no longer available
                                          // SelectorGroup(
                                          //   key: "type",
                                          //   title: "Loyalty Type",
                                          //   selectedValue: "All",
                                          //   options: [
                                          //     "All",
                                          //     "Discount",
                                          //     "Coupon",
                                          //   ],
                                          // ),
                                        ],
                                        onFilter: (data) async {
                                          await discountViewModel
                                              .getDashboardStats(
                                                  busyObjectName: firstState,
                                                  dateFilter:
                                                      data["date_filter"],
                                                  status: data["selectorGroups"]
                                                              ["status"] ==
                                                          "All"
                                                      ? ''
                                                      : (data["selectorGroups"]
                                                                  ["status"]
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
                                  isRequired: false,
                                  showLabelHeader: false,
                                  hintText: "Search by discount name etc",
                                  onChanged: (value) {
                                    Debouncer().performAction(action: () async {
                                      await discountViewModel.getDashboardStats(
                                          q: value,
                                          busyObjectName: searchState);
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
                                              discountViewModel
                                                  .getDashboardStats(
                                                      busyObjectName:
                                                          searchState);
                                            });
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
                                        onTap: () {},
                                        child: Container(
                                          padding:
                                              EdgeInsets.all(Sizer.width(10)),
                                          decoration: BoxDecoration(
                                              border: Border(
                                            left: BorderSide(
                                              color: AppColors.neutral5,
                                            ),
                                          )),
                                          child:
                                              SvgPicture.asset(AppSvgs.search),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                YBox(10),
                                Builder(builder: (context) {
                                  if (discountViewModel.isBusy) {
                                    return SizerLoader(
                                      height: Sizer.height(300),
                                    );
                                  }
                                  if (discountViewModel.discounts.isEmpty) {
                                    return SizedBox(
                                      height: Sizer.height(300),
                                      child: EmptyListState(
                                        text: "No Data",
                                      ),
                                    );
                                  }
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.only(
                                      top: Sizer.height(14),
                                      bottom: Sizer.height(50),
                                    ),
                                    itemCount:
                                        discountViewModel.discounts.length,
                                    separatorBuilder: (_, __) => HDivider(),
                                    itemBuilder: (ctx, i) {
                                      final discount =
                                          discountViewModel.discounts[i];
                                      return DiscountListTile(
                                        title: discount.name ?? 'N/A',
                                        code: discount.code ?? 'N/A',
                                        amount: discount.type == 'amount'
                                            ? "N ${AppUtils.formatNumber(
                                                number: num.parse(discount
                                                        .amount
                                                        ?.toString() ??
                                                    '0'),
                                              )}"
                                            : "${discount.percent ?? '0'}%",
                                        type: discount.type ?? 'N/A',
                                        status: discount.status ?? 'N/A',
                                        date: discount.startDate ??
                                            DateTime.now(),
                                        onTap: () {},
                                      );
                                    },
                                  );
                                }),
                                if (discountViewModel.busy(paginateState))
                                  SpinKitLoader(
                                    size: 16,
                                    color: AppColors.neutral5,
                                  ),
                                if (discountViewModel.error(paginateState))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: ErrorState(
                                      onPressed: () {
                                        discountViewModel.getDashboardStats(
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
                    ),
                  ),
                );
              }),
    );
  }
}
