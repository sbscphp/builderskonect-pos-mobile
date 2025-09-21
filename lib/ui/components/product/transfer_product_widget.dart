import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class TransferProductWidget extends StatelessWidget {
  const TransferProductWidget(
      {super.key,
      required this.productTitle,
      required this.productImage,
      required this.subTitle,
      required this.sku,
      this.showStock = true,
      this.onTap,
      this.onRemove,
      this.onChanged,
      this.enabled = true,
      this.controller,
      this.errText});

  final String productTitle;
  final String productImage;
  final String subTitle;
  final String sku;
  final bool showStock;
  final VoidCallback? onTap;
  final Function()? onRemove;
  final void Function(String)? onChanged;
  final bool enabled;
  final TextEditingController? controller;
  final String? errText;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ProductWithSkuListTile(
            productImage: productImage,
            productTitle: productTitle,
            subTitle: subTitle,
            sku: sku,
          ),
          if (showStock)
            Column(
              children: [
                YBox(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Mainland Stock: ",
                            style: textTheme.text12?.medium.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                          TextSpan(
                            text: "500",
                            style: textTheme.text12?.medium.copyWith(),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Your Stock: ",
                            style: textTheme.text12?.medium.copyWith(
                              color: AppColors.gray500,
                            ),
                          ),
                          TextSpan(
                            text: "02",
                            style: textTheme.text12?.medium.copyWith(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          if (onChanged != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                YBox(8),
                Row(
                  children: [
                    Text(
                      "Request Quantity:",
                      style: textTheme.text14?.medium
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    XBox(8),
                    Expanded(
                        child: CustomTextField(
                      controller: controller,
                      showLabelHeader: false,
                      enabled: enabled,
                      onChanged: onChanged,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ))
                  ],
                ),
                if (errText != null)
                  Text(
                    errText ?? '',
                    style: textTheme.text12?.copyWith(color: AppColors.red4F),
                  )
              ],
            ),
          if (onRemove != null)
            Column(
              children: [
                YBox(16),
                CustomBtn(
                  onlineColor: AppColors.red1,
                  outlineColor: AppColors.red1,
                  height: 40,
                  onTap: onRemove,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppSvgs.trash,
                        height: Sizer.height(14),
                      ),
                      XBox(8),
                      Text(
                        "Remove",
                        style: textTheme.text14?.copyWith(
                          color: AppColors.red22,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
