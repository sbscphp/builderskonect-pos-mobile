import 'package:builders_konnect/core/core.dart';

class RegSteps extends StatelessWidget {
  const RegSteps({
    super.key,
    this.isActive = false,
    required this.number,
    required this.text,
  });

  final bool isActive;
  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: Sizer.width(18),
          height: Sizer.height(18),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryBlue : AppColors.transparent,
            borderRadius: BorderRadius.circular(Sizer.radius(20)),
            border: Border.all(
              color: isActive
                  ? AppColors.transparent
                  : AppColors.black.withValues(alpha: 0.25),
            ),
          ),
          child: Center(
            child: Text(
              number,
              style: AppTypography.text12.withCustomColor(
                isActive
                    ? AppColors.white
                    : AppColors.black.withValues(alpha: 0.25),
              ),
            ),
          ),
        ),
        XBox(6),
        Text(
          text,
          style: AppTypography.text12.withCustomColor(
            isActive
                ? AppColors.black.withValues(alpha: 0.83)
                : AppColors.black.withValues(alpha: 0.25),
          ),
        )
      ],
    );
  }
}
