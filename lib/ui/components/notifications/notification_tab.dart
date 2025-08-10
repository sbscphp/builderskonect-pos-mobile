import 'package:builders_konnect/core/core.dart';

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
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
