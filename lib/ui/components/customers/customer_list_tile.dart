import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomerListTile extends StatelessWidget {
  const CustomerListTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.customerId,
    this.date,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final String customerId;
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
          CustomCircleAvatar(
            showBorder: false,
            size: 24,
            avatarUrl: AppUtils.dummyImage,
            onTap: () {},
          ),
          XBox(8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.text14,
                ),
                YBox(4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Id: ",
                        style: textTheme.text12?.copyWith(
                          color: AppColors.gray500,
                          fontFamily: "Roboto",
                        ),
                      ),
                      TextSpan(
                        text: customerId,
                        style: textTheme.text12?.semiBold.copyWith(
                          color: colorScheme.primaryColor,
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
              Text(
                "Channel: ",
                style: textTheme.text14?.copyWith(
                  color: AppColors.gray500,
                ),
              ),
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
