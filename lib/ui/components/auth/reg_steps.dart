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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
              style: textTheme.text12?.copyWith(
                color: isActive ? colorScheme.white : colorScheme.black25,
              ),
            ),
          ),
        ),
        XBox(6),
        Text(
          text,
          style: textTheme.text12?.copyWith(
            color: isActive ? colorScheme.black85 : colorScheme.black25,
          ),
        )
      ],
    );
  }
}
