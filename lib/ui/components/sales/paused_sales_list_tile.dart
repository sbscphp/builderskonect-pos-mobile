import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PausedSalesListTile extends StatelessWidget {
  const PausedSalesListTile({
    super.key,
    required this.firstColText,
    required this.subTitle,
    required this.status,
    required this.amount,
    required this.totalItems,
    this.date,
    this.onTap,
  });

  final String firstColText;
  final String subTitle;
  final String amount;
  final String totalItems;
  final String status;
  final DateTime? date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                firstColText,
                style: textTheme.text14?.medium
                    .copyWith(color: AppColors.primaryBlue),
              ),
              if (status.isNotEmpty) OrderStatus(status: status),
            ],
          ),
          YBox(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                  ],
                ),
              ),
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
          YBox(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Amount: ",
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                        fontFamily: "Roboto",
                      ),
                    ),
                    TextSpan(
                      text: amount,
                      style: textTheme.text12?.medium.copyWith(
                        color: colorScheme.primaryColor,
                        fontFamily: "Roboto",
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Total items: ",
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                        fontFamily: "Roboto",
                      ),
                    ),
                    TextSpan(
                      text: totalItems,
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.neutral11,
                        fontFamily: "Roboto",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          YBox(8),
          CustomBtn(
            height: 32,
            textSize: 14,
            onTap: () {},
            text: "Resume sales",
          )
        ],
      ),
    );
  }
}
