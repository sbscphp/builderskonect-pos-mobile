import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class RenewSubscriptionScreen extends ConsumerStatefulWidget {
  const RenewSubscriptionScreen({super.key});

  @override
  ConsumerState<RenewSubscriptionScreen> createState() =>
      _RenewSubscriptionScreenState();
}

class _RenewSubscriptionScreenState
    extends ConsumerState<RenewSubscriptionScreen> {
  final discountCodeC = TextEditingController();
  final discountCodeFocus = FocusNode();

  @override
  void dispose() {
    discountCodeC.dispose();
    discountCodeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.white,
      appBar: CustomAppbar(
        title: "Renew Subscription",
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
              border: Border.all(color: AppColors.neutral4),
              borderRadius: BorderRadius.circular(Sizer.radius(8)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Summary",
                  style: textTheme.text16?.medium,
                ),
                YBox(16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 9,
                      child: CustomTextField(
                        controller: discountCodeC,
                        focusNode: discountCodeFocus,
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
                          onTap: () async {},
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
                        keyText: "Basic Plan",
                        valueText: "N 30,000",
                      ),
                      YBox(16),
                      PlansRowText(
                        keyText: "Discount",
                        valueText: "N 3,000",
                      ),
                      YBox(16),
                      PlansRowText(
                        keyText: "VAT",
                        valueText: "N 300",
                      ),
                      YBox(16),
                      PlansRowText(
                        keyText: "Total Cost",
                        valueText: "N 30,000",
                        keyTextStyle: textTheme.text16,
                        valueTextStyle: textTheme.text16?.bold.copyWith(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          YBox(30),
          CustomBtn.solid(
            text: "Continue",
            onTap: () async {},
          )
        ],
      ),
    );
  }
}
