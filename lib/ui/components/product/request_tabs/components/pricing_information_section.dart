import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class PricingInformationSection extends ConsumerWidget {
  const PricingInformationSection({
    super.key,
    required this.costPricePerUnitC,
    required this.sellingPricePerUnitC,
    required this.discountPriceC,
    required this.isViewPricingInformation,
    required this.onTogglePricingInfo,
  });

  final TextEditingController costPricePerUnitC;
  final TextEditingController sellingPricePerUnitC;
  final TextEditingController discountPriceC;
  final bool isViewPricingInformation;
  final VoidCallback onTogglePricingInfo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Pricing FORM
        InkWell(
          onTap: onTogglePricingInfo,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Pricing Information",
                  style: textTheme.text16?.medium,
                ),
              ),
              Icon(isViewPricingInformation
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down)
            ],
          ),
        ),
        HDivider(),
        if (isViewPricingInformation)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            child: !isViewPricingInformation
                ? SizedBox.shrink()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: textTheme.text14,
                          children: [
                            TextSpan(
                              text: "All asterisk (",
                            ),
                            TextSpan(
                              text: "*",
                              style: textTheme.text14?.medium.copyWith(
                                color: Colors.red,
                              ),
                            ),
                            TextSpan(
                              text: ") are required fields",
                            ),
                          ],
                        ),
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: costPricePerUnitC,
                        labelText: 'Cost Price per Unit',
                        hintText: '0.00',
                        showLabelHeader: true,
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: sellingPricePerUnitC,
                        labelText: 'Selling Price per Unit',
                        hintText: '0.00',
                        showLabelHeader: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: discountPriceC,
                        labelText: 'Discount Price',
                        optionalText: "(Optional)",
                        hintText: '0.00',
                        showLabelHeader: true,
                        isRequired: false,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      YBox(16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: 4,
                            ),
                            child: CustomCheckbox(
                              isSelected: false,
                            ),
                          ),
                          XBox(8),
                          Expanded(
                            child: Text(
                              "Apply pricing information to other variants. (Information applied can be edited to specific variants)",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.text14,
                            ),
                          ),
                        ],
                      ),
                      YBox(48),
                    ],
                  ),
          ),
        YBox(16),
      ],
    );
  }
}
