import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Notifications",
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: Sizer.width(16),
              right: Sizer.width(16),
              top: Sizer.height(20),
              bottom: Sizer.height(10),
            ),
            child: Row(
              children: [
                NotificationTab(
                  text: "All",
                  isSelected: true,
                  onTap: () {},
                ),
                XBox(6),
                NotificationTab(
                  text: "Unread",
                  onTap: () {},
                  // isSelected: true,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: 10,
              padding: EdgeInsets.only(
                left: Sizer.width(16),
                right: Sizer.width(16),
                top: Sizer.height(10),
                bottom: Sizer.height(100),
              ),
              separatorBuilder: (_, __) => YBox(16),
              itemBuilder: (_, i) {
                return NotificationCard(
                  title: "New Product Request",
                  message: "Store B requested for 40 products",
                  time: "(Today) 10:30 PM",
                  onTap: () {},
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

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

class NotificationTab extends StatelessWidget {
  const NotificationTab({
    super.key,
    required this.text,
    this.isSelected = false,
    this.onTap,
  });

  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
        vertical: Sizer.height(7),
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.dayBreakBlue : AppColors.white,
        borderRadius: BorderRadius.circular(Sizer.radius(4)),
      ),
      child: Text(
        text,
        style: textTheme.text14?.copyWith(
            color: isSelected
                ? AppColors.primaryBlue
                : AppColors.black.withValues(alpha: 0.83)),
      ),
    );
  }
}
