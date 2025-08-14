import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class OrderSummaryStep extends ConsumerStatefulWidget {
  const OrderSummaryStep({
    super.key,
  });

  @override
  ConsumerState<OrderSummaryStep> createState() => _OrderSummaryStepState();
}

class _OrderSummaryStepState extends ConsumerState<OrderSummaryStep> {
  final discountCodeC = TextEditingController();

  @override
  void dispose() {
    discountCodeC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.only(
        top: Sizer.height(16),
        bottom: Sizer.height(60),
        left: Sizer.width(16),
        right: Sizer.width(16),
      ),
      children: [
        Container(
          padding: EdgeInsets.all(Sizer.radius(16)),
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 9,
                    child: CustomTextField(
                      controller: discountCodeC,
                      isRequired: false,
                      labelText: 'Apply Discount Code ',
                      optionalText: '(if any)',
                      hintText: 'GT27365ER',
                      showLabelHeader: true,
                    ),
                  ),
                  XBox(8),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: Sizer.height(7),
                      ),
                      child: CustomBtn(
                        // isLoading: subVm.busy(discountState),
                        height: 44,
                        text: "Apply",
                        onTap: () async {
                          if (discountCodeC.text.trim().isNotEmpty) {
                            // final res = await _initSetup(
                            //     discountCodeC.text.trim(), true);

                            // handleApiResponse(
                            //   response: res,
                            //   showSuccessToast: false,
                            // );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              YBox(16),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizer.width(16),
                  vertical: Sizer.height(20),
                ),
                decoration: BoxDecoration(
                  color: AppColors.dayBreakBlue,
                  borderRadius: BorderRadius.circular(Sizer.radius(8)),
                ),
                child: Column(
                  children: [
                    PlansRowText(
                      keyText: 'Subtotal',
                      valueText:
                          "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: 2000)}",
                    ),
                    YBox(14),
                    PlansRowText(
                      keyText: "Discount",
                      valueText:
                          "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: 4000)}",
                    ),
                    YBox(14),
                    PlansRowText(
                      keyText: "VAT",
                      valueText:
                          "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: 2000)}",
                    ),
                    YBox(14),
                    PlansRowText(
                      keyText: "Total Cost",
                      valueText:
                          "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: 2000)}",
                      keyTextStyle: textTheme.text16,
                      valueTextStyle: textTheme.text16?.bold.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              YBox(150),
              CustomBtn.solid(
                text: "Pause Sales",
                isOutline: true,
                outlineColor: AppColors.neutral5,
                textStyle: textTheme.text16,
                onTap: () {},
              ),
              YBox(24),
              CustomBtn.solid(
                text: "Next",
                onTap: () {
                  Navigator.of(context).pushNamed(
                    RoutePath.pricingPlansScreen,
                  );
                },
              ),
              YBox(30),
            ],
          ),
        ),
      ],
    );
  }
}
