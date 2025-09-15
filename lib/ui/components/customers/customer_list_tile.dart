import 'package:builders_konnect/core/core.dart';

class CustomerListTile extends StatelessWidget {
  const CustomerListTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.customerId,
    this.channel,
    this.onTap,
  });

  final String title;
  final String subTitle;
  final String customerId;
  final String? channel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SvgPicture.asset(
            AppSvgs.circleAvatar,
            height: Sizer.height(24),
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
                channel ?? "",
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
