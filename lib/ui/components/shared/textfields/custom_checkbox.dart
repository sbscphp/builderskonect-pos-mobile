import 'package:builders_konnect/core/core.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    this.onTap,
    this.isSelected = false,
  });

  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isSelected ? Sizer.width(17) : Sizer.width(16),
        height: isSelected ? Sizer.height(17) : Sizer.height(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.transparent,
          borderRadius: BorderRadius.circular(Sizer.radius(2)),
          border: Border.all(color: AppColors.neutral5),
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color: AppColors.white,
                size: Sizer.height(12),
              )
            : null,
      ),
    );
  }
}

class CustomRadioBtn extends StatelessWidget {
  const CustomRadioBtn({
    super.key,
    this.onTap,
    this.isSelected = false,
  });

  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: Sizer.width(isSelected ? 18 : 16),
        height: Sizer.height(isSelected ? 18 : 16),
        padding: EdgeInsets.all(
          Sizer.radius(isSelected ? 3 : 2),
        ),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? AppColors.primaryBlue : AppColors.grayDD),
          borderRadius: BorderRadius.circular(Sizer.radius(20)),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : AppColors.white,
            borderRadius: BorderRadius.circular(Sizer.radius(20)),
          ),
        ),
      ),
    );
  }
}
