import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class OrderAnalyticsScreen extends ConsumerStatefulWidget {
  const OrderAnalyticsScreen({super.key});

  @override
  ConsumerState<OrderAnalyticsScreen> createState() =>
      _OrderAnalyticsScreenState();
}

class _OrderAnalyticsScreenState extends ConsumerState<OrderAnalyticsScreen> {
  final searchC = TextEditingController();

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppbar(
        title: "Paused Sales",
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
            padding: EdgeInsets.all(Sizer.radius(16)),
            decoration: BoxDecoration(
              color: colorScheme.white,
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterHeader(
                  title: "Order Overview",
                  subTitle:
                      "Track and measure order analytics for your business",
                ),
                YBox(16),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: "Total Orders Value",
                            value: "0",
                            bgColor: AppColors.blueFF,
                            borderColor: AppColors.blue5,
                            amountColor: AppColors.primaryBlue,
                            onTap: () {},
                          ),
                        ),
                        XBox(16),
                        Expanded(
                          child: StatCard(
                            title: "Total Orders",
                            value: "0",
                            bgColor: AppColors.cyan1,
                            borderColor: AppColors.cyan4,
                            amountColor: AppColors.cyan7,
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
                            title: "Items Sold",
                            value: "0",
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
                            title: "Items Sold",
                            value: "0",
                            bgColor: AppColors.dust1,
                            borderColor: AppColors.dust4,
                            borderButtomColor: AppColors.purple2,
                            amountColor: AppColors.red22,
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
                FilterHeader(
                  title: "Revenue Analytics",
                  onFilter: () {},
                ),
                YBox(16),
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: "Walk-in",
                            value: "0",
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
                            value: "0",
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
                  title: "Top Selling Products",
                  subTitle: "See your top selling products",
                  onFilter: () {},
                ),
                YBox(16),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5,
                  separatorBuilder: (_, __) => HDivider(),
                  itemBuilder: (ctx, i) {
                    return Row(
                      children: [
                        Container(
                          height: Sizer.height(24),
                          width: Sizer.width(24),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryColor,
                            borderRadius: BorderRadius.circular(
                              Sizer.radius(30),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "21",
                              style: textTheme.text12?.copyWith(
                                color: colorScheme.white,
                              ),
                            ),
                          ),
                        ),
                        XBox(24),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: Sizer.width(26),
                                      height: Sizer.height(26),
                                      child: MyCachedNetworkImage(
                                        imageUrl: AppUtils.dummyImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    XBox(16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Premium Cement",
                                            style: textTheme.text14,
                                          ),
                                          YBox(4),
                                          Text(
                                            '10kg Smooth',
                                            style: textTheme.text12?.copyWith(
                                              color: colorScheme.black45,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                "250 sold",
                                style: textTheme.text14?.medium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
