import 'package:builders_konnect/core/core.dart';

class QuickActionCol extends StatelessWidget {
  const QuickActionCol({
    super.key,
    required this.title,
    required this.svgPath,
    this.onTap,
  });

  final String title;
  final String svgPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Sizer.width(12),
              vertical: Sizer.height(10),
            ),
            decoration: BoxDecoration(
              color: AppColors.dayBreakBlue,
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child: SvgPicture.asset(
              svgPath,
              height: Sizer.height(24),
            ),
          ),
          YBox(4),
          Text(
            title,
            style: textTheme.text14,
          )
        ],
      ),
    );
  }
}
