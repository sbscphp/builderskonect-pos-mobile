// ignore_for_file: deprecated_member_use

import 'package:builders_konnect/core/core.dart';

class BottomNavColumn extends StatelessWidget {
  const BottomNavColumn({
    super.key,
    required this.icon,
    required this.labelText,
    this.isActive = false,
    required this.onPressed,
  });

  final dynamic icon;
  final String labelText;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          (icon is String)
              ? SvgPicture.asset(
                  icon,
                  color: isActive ? AppColors.primaryBlue : AppColors.neutral7,
                  height: Sizer.height(25),
                  width: Sizer.width(25),
                )
              : Icon(
                  icon,
                  color: isActive ? AppColors.primaryBlue : AppColors.neutral7,
                  size: Sizer.height(25),
                ),
          YBox(2),
          Text(
            labelText,
            style: AppTypography.text12.withCustomColor(
              isActive ? AppColors.primaryBlue : AppColors.neutral9,
            ),
          ),
        ],
      ),
    );
  }
}
