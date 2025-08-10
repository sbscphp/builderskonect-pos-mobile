import 'package:builders_konnect/core/core.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    this.isRead = false,
    required this.title,
    required this.message,
    required this.time,
    this.onTap,
  });

  final bool isRead;
  final String title;
  final String message;
  final String time;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Sizer.width(16),
          vertical: Sizer.height(14),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(Sizer.radius(4)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                bottom: Sizer.width(10),
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.neutral4,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: Sizer.height(6),
                    width: Sizer.width(6),
                    margin: EdgeInsets.only(
                      right: Sizer.height(8),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.red2D,
                      borderRadius: BorderRadius.circular(Sizer.radius(40)),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.text14?.medium
                                .copyWith(color: AppColors.blue4F)),
                        YBox(2),
                        Text(
                          message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.text12
                              ?.copyWith(color: AppColors.blue4F),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            YBox(8),
            Row(
              children: [
                Text(
                  time,
                  style: textTheme.text12?.copyWith(color: AppColors.neutral8),
                ),
                Spacer(),
                InkWell(
                  onTap: () {},
                  child: Text(
                    "View",
                    style: textTheme.text12
                        ?.copyWith(color: AppColors.primaryBlue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
