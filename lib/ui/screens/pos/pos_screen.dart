import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _callDashboardData();
    });
  }

  _callDashboardData() async {
    await ref.read(dashboardVmodel).getDashboardStats();
    await ref.read(dashboardVmodel).getMerchantCheckList();
    await ref.read(dashboardVmodel).getRevenueAndTraffic();
    await ref.read(dashboardVmodel).getProductOverview();
    await ref.read(staffVm).getApplicationAccess();
    await ref.read(vendorProfileVmodel).getVendorProfile();
    await ref.read(userProfileVmodel).getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dashVm = ref.watch(dashboardVmodel);
    final vendorProfileVm = ref.watch(vendorProfileVmodel);
    final staffRef = ref.watch(staffVm);
    final profileVm = ref.watch(vendorProfileVmodel);

    return SizedBox(
      height: Sizer.screenHeight,
      width: Sizer.screenWidth,
      child: BusyOverlay(
        show: dashVm.isBusy,
        child: Scaffold(
          key: _scaffoldKey,
          drawer: const CustomDrawer(),
          appBar: CustomAppbar(
            title: "Dashboard",
            trailingWidget: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePath.notificationScreen);
              },
              child: SvgPicture.asset(
                AppSvgs.notification,
                height: Sizer.height(32),
              ),
            ),
            leadingWidget: CustomCircleAvatar(
              avatarUrl: ref.read(authVmodel).user?.avatar,
              onTap: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          body: Builder(builder: (context) {
            if (dashVm.isBusy) {
              return Container();
            }
            if (!staffRef.hasAccessToDashboardOverview) {
              return RequestAccessWidget();
            }
            return RefreshIndicator(
              onRefresh: () async {
                await _callDashboardData();
              },
              child: ListView(
                padding: EdgeInsets.only(
                  left: Sizer.width(16),
                  right: Sizer.width(16),
                  bottom: Sizer.height(50),
                ),
                children: [
                  YBox(16),
                  if (vendorProfileVm.vendorProfile?.onboardingStatus !=
                      "approved")
                    InfoContainer(
                      show: _isExpanded,
                      title: "Account Under Review",
                      content:
                          "Your account has not yet being verified. You will gain access to the full features when your account is approved.",
                      onTap: () {
                        _isExpanded = !_isExpanded;
                        setState(() {});
                      },
                    ),
                  if ((profileVm.vendorProfile?.logo ?? "").isEmpty)
                    Padding(
                      padding: EdgeInsets.only(
                        top: Sizer.height(16),
                      ),
                      child: HomeWelcomeOnboardWidget(),
                    ),
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
                        Text("Quick Actions", style: textTheme.text16?.medium),
                        YBox(16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            QuickActionCol(
                              title: "Customers",
                              svgPath: AppSvgs.customer,
                              onTap: () {
                                Navigator.pushNamed(context,
                                    RoutePath.customersManagementScreen);
                              },
                            ),
                            QuickActionCol(
                              title: "Returns",
                              svgPath: AppSvgs.returns,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutePath.returnRefundScreen);
                              },
                            ),
                            QuickActionCol(
                              title: "Discounts",
                              svgPath: AppSvgs.discount,
                              onTap: () {
                                Navigator.pushNamed(context,
                                    RoutePath.discountManagementScreen);
                              },
                            ),
                            QuickActionCol(
                              title: "Staff",
                              svgPath: AppSvgs.userFilled,
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RoutePath.staffManagementScreen);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  if (!dashVm.showTodoCard)
                    Container(
                      margin: EdgeInsets.only(top: Sizer.height(16)),
                      padding: EdgeInsets.symmetric(vertical: Sizer.radius(16)),
                      decoration: BoxDecoration(
                        color: colorScheme.white,
                        borderRadius: BorderRadius.circular(Sizer.radius(4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Sizer.width(16)),
                            child: Text("My To-dos",
                                style: textTheme.text16?.medium),
                          ),
                          YBox(16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                XBox(16),
                                if (!dashVm.hasStore)
                                  MyTodoRol(
                                    leadiconPath: AppSvgs.shop,
                                    isDone: dashVm.hasStore,
                                    title: "Create a store",
                                  ),
                                if (!dashVm.hasProducts)
                                  MyTodoRol(
                                    leadiconPath: AppSvgs.plusCircle,
                                    isDone: dashVm.hasProducts,
                                    title: "Add products",
                                  ),
                                if (!dashVm.hasRole)
                                  MyTodoRol(
                                    leadiconPath: AppSvgs.plusCircle,
                                    isDone: dashVm.hasRole,
                                    title: "Create role",
                                  ),
                                if (!dashVm.hasStaff)
                                  MyTodoRol(
                                    leadiconPath: AppSvgs.plusCircle,
                                    isDone: dashVm.hasStaff,
                                    title: "Add user",
                                  ),
                                if (!dashVm.hasSales)
                                  MyTodoRol(
                                    leadiconPath: AppSvgs.plusCircle,
                                    isDone: dashVm.hasSales,
                                    title: "Create sales order",
                                  ),
                                XBox(30),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
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
                        Text("Overview", style: textTheme.text16?.medium),
                        Text(
                            "Track and measure store performance and analytics ",
                            style: textTheme.text12
                                ?.copyWith(color: colorScheme.black45)),
                        YBox(16),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    title: "Total Products",
                                    value: AppUtils.formatNumber(
                                      number: double.tryParse(
                                            dashVm.statModel?.totalProducts ??
                                                "0",
                                          ) ??
                                          0,
                                    ),
                                    bgColor: AppColors.blueFF,
                                    borderColor: AppColors.blue5,
                                    amountColor: AppColors.primaryBlue,
                                    onTap: () {},
                                  ),
                                ),
                                XBox(16),
                                Expanded(
                                  child: StatCard(
                                    title: "Revenue",
                                    value: dashVm.statModel?.revenueGenerated ??
                                        "0",
                                    bgColor: AppColors.magentaF8,
                                    borderColor: AppColors.magenta4,
                                    borderButtomColor: AppColors.magenta2,
                                    amountColor: AppColors.magenta6,
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                            YBox(16),
                            Row(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    title: "Total Sales Order",
                                    value: dashVm.statModel?.totalSalesOrders ??
                                        "0",
                                    borderButtomColor: AppColors.purple2,
                                    bgColor: AppColors.yellowE6,
                                    borderColor: AppColors.yellow4,
                                    amountColor: AppColors.yellow6,
                                    onTap: () {},
                                  ),
                                ),
                                XBox(16),
                                Expanded(
                                  child: StatCard(
                                    title: "Total Customers",
                                    value: dashVm.statModel?.totalCustomers
                                            ?.toString() ??
                                        "0",
                                    bgColor: AppColors.greenED,
                                    borderColor: AppColors.green4,
                                    borderButtomColor: AppColors.purple2,
                                    amountColor: AppColors.green7,
                                    iconPath: AppSvgs.chart,
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (staffRef.hasAccessToRevenueAnalytics)
                    Container(
                      padding: EdgeInsets.all(Sizer.radius(16)),
                      margin: EdgeInsets.only(
                        top: Sizer.radius(16),
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.white,
                        borderRadius: BorderRadius.circular(Sizer.radius(4)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FilterHeader(
                            title: "Revenue Analytics",
                            subTitle:
                                "Get insights into revenue analytics right here.",
                            onFilter: () {
                              ModalWrapper.bottomSheet(
                                  context: context,
                                  widget: FilterDataModal(
                                    modalHeight: Sizer.screenHeight * .4,
                                    onFilter: (filterData) {
                                      // printty(
                                      //     "Filter applied: $filterData");
                                      dashVm.getRevenueAndTraffic(
                                          dateFilter:
                                              filterData["date_filter"]);
                                    },
                                  ));
                            },
                          ),
                          YBox(16),
                          StatCard(
                            title: "Total Revenue",
                            value:
                                dashVm.revenueAndTrafficModel?.revenue ?? "0",
                            bgColor: AppColors.yellowE8,
                            borderColor: AppColors.yellow1C,
                            borderButtomColor: AppColors.yellowBF,
                            amountColor: AppColors.yellow1C,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text("Customer Traffic",
                                  style: textTheme.text16?.medium),
                            ),
                            InkWell(
                              onTap: () {
                                ModalWrapper.bottomSheet(
                                    context: context,
                                    widget: FilterDataModal(
                                      modalHeight: Sizer.screenHeight * .4,
                                      onFilter: (filterData) {
                                        // printty(
                                        //     "Filter applied: $filterData");
                                        dashVm.getRevenueAndTraffic(
                                            dateFilter:
                                                filterData["date_filter"]);
                                      },
                                    ));
                              },
                              child: SvgPicture.asset(
                                AppSvgs.filter,
                                height: Sizer.height(32),
                              ),
                            )
                          ],
                        ),
                        YBox(16),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: StatCard(
                                    title: "Walk-in",
                                    value: dashVm.revenueAndTrafficModel
                                            ?.traffic?.pos?.value ??
                                        "0",
                                    bgColor: AppColors.blueFF,
                                    borderColor: AppColors.blue5,
                                    amountColor: AppColors.primaryBlue,
                                    onTap: () {},
                                  ),
                                ),
                                XBox(16),
                                Expanded(
                                  child: StatCard(
                                    title: "Online",
                                    value: dashVm.revenueAndTrafficModel
                                            ?.traffic?.omp?.value ??
                                        "0",
                                    bgColor: AppColors.magentaF8,
                                    borderColor: AppColors.magenta4,
                                    borderButtomColor: AppColors.magenta2,
                                    amountColor: AppColors.magenta6,
                                    onTap: () {},
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  YBox(16),
                  ProductOverviewWidget(),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
