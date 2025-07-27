import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardVmodel)
        ..getDashboardStats()
        ..getProductOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dashVm = ref.watch(dashboardVmodel);
    return Scaffold(
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
        leadingWidget: Container(
          height: Sizer.height(40),
          width: Sizer.width(40),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Sizer.radius(40)),
              border: Border.all(
                color: AppColors.primaryBlue,
                width: 2,
              )),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Sizer.radius(40)),
            child: ref.watch(authVmodel).user?.avatar != null
                ? MyCachedNetworkImage(
                    imageUrl: ref.watch(authVmodel).user!.avatar,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Iconsax.user,
                    size: Sizer.width(20),
                  ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: Sizer.width(16),
          right: Sizer.width(16),
          bottom: Sizer.height(50),
        ),
        children: [
          YBox(16),
          Container(
            padding: EdgeInsets.all(
              Sizer.radius(12),
            ),
            decoration: BoxDecoration(
              color: colorScheme.white,
              border: Border.all(color: AppColors.yellow3D),
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppSvgs.reviewIcon,
                        height: Sizer.height(32),
                      ),
                      XBox(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Account Under Review",
                              style: textTheme.text14?.medium,
                            ),
                            YBox(2),
                            Text(
                              "Your account has not yet being verified. You will gain access to the full features when your account is approved.",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.text12,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                XBox(10),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: Sizer.width(24),
                )
              ],
            ),
          ),
          YBox(16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Sizer.width(16),
              vertical: Sizer.height(14),
            ),
            width: Sizer.screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.banner),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome Onboard!",
                  style: textTheme.text16?.medium.copyWith(
                    color: colorScheme.white,
                  ),
                ),
                YBox(4),
                Text(
                  "Complete your business profile by uploading your business logo",
                  style: textTheme.text12?.copyWith(
                    color: colorScheme.white,
                  ),
                ),
                YBox(10),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizer.width(8),
                        vertical: Sizer.height(4),
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.white,
                        borderRadius: BorderRadius.circular(Sizer.radius(4)),
                      ),
                      child: Text(
                        "Upload Logo",
                        style: textTheme.text12?.copyWith(
                          color: colorScheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
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
                Text("My To-dos", style: textTheme.text16?.medium),
                YBox(16),
                Row(
                  children: [
                    Expanded(
                      child: MyTodoRol(
                        leadiconPath: AppSvgs.shop,
                        trailIconPath: AppSvgs.checkCircle,
                        title: "Create a store",
                        onTap: () {
                          // Navigator.pushNamed(context, RoutePath.profileScreen);
                        },
                      ),
                    ),
                    XBox(8),
                    Expanded(
                      child: MyTodoRol(
                        leadiconPath: AppSvgs.plusCircle,
                        trailIconPath: AppSvgs.chevronRight,
                        title: "Add products",
                        onTap: () {
                          // Navigator.pushNamed(context, RoutePath.profileScreen);
                        },
                      ),
                    )
                  ],
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
                Text("Track and measure store performance and analytics ",
                    style:
                        textTheme.text12?.copyWith(color: colorScheme.black45)),
                YBox(16),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: "Total Products",
                            value: dashVm.statModel?.totalProducts ?? "0",
                            bgColor: AppColors.blueFF,
                            borderColor: AppColors.blue5,
                            amountColor: AppColors.primaryBlue,
                            onTap: () {},
                          ),
                        ),
                        XBox(16),
                        Expanded(
                          child: StatCard(
                            title: "Revenue Generated",
                            value: dashVm.statModel?.revenueGenerated ?? "0",
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
                            value: dashVm.statModel?.totalSalesOrders ?? "0",
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
                            value:
                                dashVm.statModel?.totalCustomers?.toString() ??
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Revenue Analytics",
                              style: textTheme.text16?.medium),
                          Text(
                              "Get insights into revenue analytics right here.",
                              style: textTheme.text12
                                  ?.copyWith(color: colorScheme.black45)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        AppSvgs.filter,
                        height: Sizer.height(32),
                      ),
                    )
                  ],
                ),
                YBox(16),
                StatCard(
                  title: "Total Revenue",
                  value: dashVm.revenueAndTrafficModel?.revenue ?? "0",
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
                      onTap: () {},
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
                            value: dashVm.revenueAndTrafficModel?.traffic?.pos
                                    ?.value ??
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
                            value: dashVm.revenueAndTrafficModel?.traffic?.omp
                                    ?.value ??
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
          OverviewWidget(
            title: 'Products Overview',
            subtitle: 'View top selling products and total amount sold',
            data: [
              OverviewData(
                name: 'Cement',
                amount: 4544,
                color: const Color(0xFF4F8EF7),
                percentage: 25,
              ),
              OverviewData(
                name: 'Paint',
                amount: 4544,
                color: const Color(0xFF00BCD4),
                percentage: 20,
              ),
              OverviewData(
                name: 'Tiles',
                amount: 4544,
                color: const Color(0xFF4CAF50),
                percentage: 15,
              ),
              OverviewData(
                name: 'Cement Mixer',
                amount: 4544,
                color: const Color(0xFFFFA726),
                percentage: 20,
              ),
              OverviewData(
                name: 'Paint brush',
                amount: 4544,
                color: const Color(0xFFEF5350),
                percentage: 10,
              ),
              OverviewData(
                name: 'Others',
                amount: 4544,
                color: const Color(0xFF9C27B0),
                percentage: 10,
              ),
            ],
            totalValue: 0,
            totalLabel: 'Products sold',
            valuePrefix: '₦',
          ),
        ],
      ),
    );
  }
}

class MyTodoRol extends StatelessWidget {
  const MyTodoRol({
    super.key,
    required this.leadiconPath,
    required this.trailIconPath,
    required this.title,
    this.onTap,
  });

  final String leadiconPath;
  final String trailIconPath;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Sizer.width(12),
          vertical: Sizer.height(12),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.text6),
          borderRadius: BorderRadius.circular(Sizer.radius(4)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(leadiconPath),
            XBox(8),
            Expanded(
              child: Text(
                title,
                style: textTheme.text14?.copyWith(
                  color: AppColors.neutral9,
                ),
              ),
            ),
            SvgPicture.asset(trailIconPath),
          ],
        ),
      ),
    );
  }
}

class QuickActionCol extends StatelessWidget {
  const QuickActionCol({
    super.key,
    required this.title,
    required this.svgPath,
    this.onTap,
  });

  final String title;
  final String svgPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Sizer.width(12),
              vertical: Sizer.height(10),
            ),
            decoration: BoxDecoration(
              color: AppColors.dayBreakBlue,
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child: SvgPicture.asset(
              svgPath,
              height: Sizer.height(24),
            ),
          ),
          YBox(4),
          Text(
            title,
            style: textTheme.text14,
          )
        ],
      ),
    );
  }
}
