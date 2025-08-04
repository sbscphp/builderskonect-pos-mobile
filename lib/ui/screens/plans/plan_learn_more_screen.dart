import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PlanLearnMoreScreen extends ConsumerStatefulWidget {
  const PlanLearnMoreScreen({super.key, required this.arg});

  final PlanFeatureArg arg;

  @override
  ConsumerState<PlanLearnMoreScreen> createState() =>
      _PlanLearnMoreScreenState();
}

class _PlanLearnMoreScreenState extends ConsumerState<PlanLearnMoreScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppbar(title: ""),
      body: Container(
        padding: EdgeInsets.only(
          top: Sizer.height(16),
        ),
        width: Sizer.screenWidth,
        child: Column(
          children: [
            Text(
              "${widget.arg.name} Feature",
              style: textTheme.text20?.medium,
            ),
            YBox(8),
            Text(
              "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: double.tryParse(widget.arg.priceItem.amount ?? '0') ?? 0)} ${widget.arg.duration}",
              style: textTheme.text14?.copyWith(
                color: colorScheme.primaryColor,
              ),
            ),
            YBox(15),
            Expanded(
                child: ListView(
              padding: EdgeInsets.only(
                top: Sizer.height(15),
                bottom: Sizer.height(50),
              ),
              children: [
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     vertical: Sizer.height(14),
                //     horizontal: Sizer.height(16),
                //   ),
                //   decoration: BoxDecoration(
                //       color: AppColors.neutral3,
                //       border: Border(
                //         top: BorderSide(
                //             color: AppColors.black.withValues(alpha: 0.06),
                //             width: 1),
                //         bottom: BorderSide(
                //             color: AppColors.black.withValues(alpha: 0.06),
                //             width: 1),
                //       )),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         "Feature",
                //         style: textTheme.text14,
                //       ),
                //       Column(
                //         children: [
                //           Text(
                //             widget.arg.name,
                //             style: textTheme.text14,
                //           ),
                //           YBox(4),
                //           Text(
                //             "${AppUtils.nairaSymbol}${AppUtils.formatNumber(number: double.tryParse(widget.arg.priceItem.amount ?? '0') ?? 0)} ${widget.arg.duration}",
                //             style: textTheme.text12?.copyWith(
                //               color: colorScheme.black45,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.arg.planFeature.length,
                  itemBuilder: (crx, i) {
                    final feature = widget.arg.planFeature[i];
                    return PlanTableRow(
                      keyText: feature.name ?? '',
                      // value: feature.value,
                    );
                  },
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
