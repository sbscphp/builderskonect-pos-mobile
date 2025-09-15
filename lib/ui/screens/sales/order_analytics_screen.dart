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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(salesVmodel)
        ..getOrderStatAnalytics()
        ..getTopSellingProducts();
      ref.read(dashboardVmodel).getRevenueAndTraffic();
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final salesVm = ref.watch(salesVmodel);
    return Scaffold(
      appBar: CustomAppbar(
        title: "Order Analytics",
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
                Builder(builder: (context) {
                  if (salesVm.busy(salesAnalysisStatState)) {
                    return StatShimmer();
                  }
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: "Orders Value",
                              value:
                                  "${AppUtils.nairaSymbol}${AppUtils.formatNumber(decimalPlaces: 2, number: double.tryParse(salesVm.salesAnalysisStatModel?.orderValue?.total ?? "0") ?? 0)}",
                              bgColor: AppColors.blueFF,
                              borderColor: AppColors.blue5,
                              amountColor: AppColors.primaryBlue,
                              onTap: () {},
                            ),
                          ),
                          XBox(16),
                          Expanded(
                            child: StatCard(
                              title: "Orders Total",
                              value: salesVm
                                      .salesAnalysisStatModel?.orders?.total
                                      ?.toString() ??
                                  "0",
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
                              value: salesVm.salesAnalysisStatModel?.itemsSold
                                      ?.total ??
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
                              title: "Return Rate",
                              value:
                                  "${salesVm.salesAnalysisStatModel?.returnsRate?.total ?? 0}%",
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
                  );
                }),
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
                Builder(builder: (context) {
                  if (ref.watch(dashboardVmodel).isBusy) {
                    return StatShimmer(row: 1);
                  }

                  final trafficData = ref.watch(dashboardVmodel).trafficData;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: "Walk-in",
                              value: trafficData?.pos?.value ?? "0",
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
                              value: trafficData?.omp?.value ?? "0",
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
                  );
                }),
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
                Builder(builder: (context) {
                  if (salesVm.busy(topSellingProductsState)) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      separatorBuilder: (_, __) => HDivider(),
                      itemBuilder: (ctx, i) {
                        return Skeletonizer(
                          child: TopSellingListTile(
                            imageUrl: AppUtils.dummyImage,
                            title: "Product Name",
                            subTitle: "Product SKU",
                            quantitySold: 0,
                          ),
                        );
                      },
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: salesVm.topSellingProducts.length,
                    separatorBuilder: (_, __) => HDivider(),
                    itemBuilder: (ctx, i) {
                      final product = salesVm.topSellingProducts[i];
                      return TopSellingListTile(
                        imageUrl: product.primaryImageUrl ?? "",
                        title: product.name ?? "",
                        subTitle: product.sku ?? "",
                        quantitySold: product.quantitySold ?? 0,
                      );
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TopSellingListTile extends StatelessWidget {
  const TopSellingListTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.quantitySold,
  });

  final String imageUrl;
  final String title;
  final String subTitle;
  final int quantitySold;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: Sizer.width(26),
                height: Sizer.height(26),
                child: MyCachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              XBox(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.text14,
                    ),
                    YBox(4),
                    Text(
                      subTitle,
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
          "$quantitySold sold",
          style: textTheme.text14?.medium,
        ),
      ],
    );
  }
}
