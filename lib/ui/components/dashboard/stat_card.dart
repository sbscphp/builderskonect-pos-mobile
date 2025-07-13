import 'package:builders_konnect/core/core.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.amount,
    this.iconPath,
    required this.bgColor,
    required this.borderColor,
    this.borderButtomColor,
    required this.amountColor,
    this.onTap,
  });

  final String title;
  final String amount;
  final String? iconPath;
  final Color bgColor;
  final Color borderColor;
  final Color? borderButtomColor;
  final Color amountColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    title,
                    style: AppTypography.text12.copyWith(
                        color: AppColors.black.withValues(alpha: 0.45)),
                  ),
                  Spacer(),
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
              amount,
              style: AppTypography.text20.medium.withCustomColor(amountColor),
            ),
          ],
        ),
      ),
    );
  }
}
