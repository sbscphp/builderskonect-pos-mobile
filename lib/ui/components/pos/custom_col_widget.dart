import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomColWidget extends StatelessWidget {
  const CustomColWidget({
    super.key,
    required this.firstColText,
    required this.subTitle,
    required this.status,
    this.subTitle2,
    this.date,
    this.onTap,
  });

  final String firstColText;
  final String subTitle;
  final String? subTitle2;
  final String status;
  final DateTime? date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstColText,
                  style: textTheme.text14?.medium
                      .copyWith(color: AppColors.primaryBlue),
                ),
                YBox(4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: subTitle,
                        style: textTheme.text12?.medium.copyWith(
                          color: AppColors.gray500,
                          fontFamily: "Roboto",
                        ),
                      ),
                      if (subTitle2 != null)
                        TextSpan(
                          text: subTitle2,
                          style: textTheme.text12?.medium.copyWith(
                            color: colorScheme.black85,
                            fontFamily: "Roboto",
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OrderStatus(status: status),
              YBox(8),
              Text(
                date != null
                    ? AppUtils.dateFirstYear(date ?? DateTime.now())
                    : 'N/A',
                style: textTheme.text12?.medium.copyWith(
                  color: AppColors.gray500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
