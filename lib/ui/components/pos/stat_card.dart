import 'package:builders_konnect/core/core.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.iconPath,
    required this.bgColor,
    required this.borderColor,
    this.borderButtomColor,
    required this.amountColor,
    this.onTap,
  });

  final String title;
  final String value;
  final String? iconPath;
  final Color bgColor;
  final Color borderColor;
  final Color? borderButtomColor;
  final Color amountColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(Sizer.radius(16)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizer.radius(6)),
          color: bgColor,
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: borderButtomColor ?? AppColors.blue2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.text12?.copyWith(
                        color: colorScheme.black45,
                      ),
                    ),
                  ),
                  Skeleton.replace(
                    replacement: Bone.circle(
                      size: Sizer.height(14),
                    ),
                    child: SvgPicture.asset(
                      iconPath ?? AppSvgs.bag,
                      colorFilter: ColorFilter.mode(
                        amountColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                ],
              ),
            ),
            YBox(16),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.text18?.medium.copyWith(
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
