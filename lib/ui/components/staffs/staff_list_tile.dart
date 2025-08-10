import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class StaffListTile extends StatelessWidget {
  const StaffListTile({
    super.key,
    required this.title,
    required this.staffId,
    required this.status,
    this.subTitle2,
    required this.role,
    this.onTap,
  });

  final String title;
  final String staffId;
  final String? subTitle2;
  final String status;
  final String role;
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
                          color: colorScheme.black45,
                          fontFamily: "Roboto",
                        ),
                      ),
                      TextSpan(
                        text: staffId,
                        style: textTheme.text12?.copyWith(
                          color: colorScheme.black45,
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
                role,
                style: textTheme.text12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
