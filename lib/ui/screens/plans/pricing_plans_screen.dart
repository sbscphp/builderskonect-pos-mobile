import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:collection/collection.dart';

class PricingPlansScreen extends ConsumerStatefulWidget {
  const PricingPlansScreen({super.key, this.isUpgrade = false});

  final bool isUpgrade;

  @override
  ConsumerState<PricingPlansScreen> createState() => _PricingPlansScreenState();
}

class _PricingPlansScreenState extends ConsumerState<PricingPlansScreen> {
  bool isYearly = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(subscriptionVModel).getSubscriptionPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subVm = ref.watch(subscriptionVModel);
    return BusyOverlay(
      show: subVm.isBusy,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppbar(title: ""),
        body: Container(
          padding: EdgeInsets.only(
            left: Sizer.width(16),
            right: Sizer.width(16),
            top: Sizer.height(16),
          ),
          width: Sizer.screenWidth,
          child: Column(
            children: [
              Text(
                "Pricing Plans",
                style: Theme.of(context).textTheme.text20?.medium,
              ),
              YBox(16),
              PricingTab(
                isYearly: isYearly,
                onChanged: (value) => setState(() => isYearly = value),
              ),
              YBox(10),
              Expanded(
                child: LoadableContentBuilder(
                    isBusy: subVm.isBusy,
                    isError: subVm.hasError,
                    items: subVm.subscriptionPlans,
                    loadingBuilder: (ctx) {
                      return SizedBox.shrink();
                    },
                    errorBuilder: (ctx) {
                      return ErrorState(
                        message: "Failed to load pricing plans",
                        onPressed: () {
                          ref.read(subscriptionVModel).getSubscriptionPlans();
                        },
                      );
                    },
                    emptyBuilder: (ctx) {
                      return EmptyListState(
                        text: "No pricing plans available",
                      );
                    },
                    contentBuilder: (ctx) {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: subVm.subscriptionPlans.length,
                        padding: EdgeInsets.only(
                          top: Sizer.height(20),
                          bottom: Sizer.height(50),
                        ),
                        separatorBuilder: (_, __) => YBox(16),
                        itemBuilder: (_, i) {
                          final plan = subVm.subscriptionPlans[i];
                          PriceItem? monthlyPriceItem = plan.priceItems
                              ?.firstWhereOrNull((e) =>
                                  e.interval?.toLowerCase() == 'monthly');

                          PriceItem? yearlyPriceItem = plan.priceItems
                              ?.firstWhereOrNull((e) =>
                                  e.interval?.toLowerCase() == 'annually');

                          PriceItem? priceItem =
                              isYearly ? yearlyPriceItem : monthlyPriceItem;

                          return PricingCard(
                            icon: Icons.home_outlined,
                            title: plan.name ?? '',
                            description: plan.description ?? '',
                            price:
                                "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: double.tryParse(priceItem?.amount ?? '0') ?? 0)}",
                            period: isYearly ? '/ per year' : '/ per month',
                            onSubscribe: () {
                              // Early return if no price item available
                              if (!widget.isUpgrade && priceItem == null) {
                                return;
                              }

                              final route = widget.isUpgrade
                                  ? RoutePath.renewSubscriptionScreen
                                  : RoutePath.getStartedScreen;

                              final arguments = widget.isUpgrade
                                  ? SubcriptionArg(
                                      isUpgrade: true,
                                      priceItemId: priceItem?.id ?? '',
                                      planName: plan.name ?? '',
                                    )
                                  : PlanFeatureArg(
                                      planFeature: plan.features ?? [],
                                      name: plan.name ?? '',
                                      duration: isYearly ? '/ year' : '/ month',
                                      priceItem: priceItem!,
                                    );

                              Navigator.pushNamed(
                                context,
                                route,
                                arguments: arguments,
                              );
                            },
                            onLearnMore: () {
                              if (widget.isUpgrade) {}
                              Navigator.pushNamed(
                                context,
                                RoutePath.planLearnMoreScreen,
                                arguments: PlanFeatureArg(
                                  planFeature: plan.features ?? [],
                                  name: plan.name ?? '',
                                  duration: isYearly ? '/ year' : '/ month',
                                  priceItem: priceItem ?? PriceItem(),
                                  isUpgrade: widget.isUpgrade,
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
