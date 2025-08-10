import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class DiscountListTile extends StatelessWidget {
  const DiscountListTile({
    super.key,
    required this.title,
    required this.code,
    required this.status,
    required this.type,
    required this.amount,
    this.date,
    this.onTap,
  });

  final String title;
  final String code;
  final String amount;
  final String type;
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: textTheme.text14,
                      ),
                    ),
                    OrderStatus(status: status),
                  ],
                ),
                YBox(4),
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Code: ",
                              style: textTheme.text12?.medium.copyWith(
                                color: AppColors.gray500,
                                fontFamily: "Roboto",
                              ),
                            ),
                            TextSpan(
                              text: code,
                              style: textTheme.text14?.copyWith(
                                color: colorScheme.primaryColor,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ],
                        ),
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
                YBox(4),
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Type: ",
                              style: textTheme.text12?.medium.copyWith(
                                color: AppColors.gray500,
                                fontFamily: "Roboto",
                              ),
                            ),
                            TextSpan(
                              text: type,
                              style: textTheme.text12?.medium.copyWith(
                                fontFamily: "Roboto",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
