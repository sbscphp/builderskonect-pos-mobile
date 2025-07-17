import 'package:builders_konnect/core/core.dart';

extension CustomColorScheme on ColorScheme {
  // Custom text color variants
  Color get primaryColor =>
      brightness == Brightness.light ? AppColors.primaryBlue : Colors.red;
  Color get secondaryColor =>
      brightness == Brightness.light ? AppColors.neutral5 : Colors.red;
  Color get white =>
      brightness == Brightness.light ? AppColors.white : Colors.red;

  Color get text6 => brightness == Brightness.light
      ? AppColors.black.withValues(alpha: 0.06)
      : Colors.red;
  Color get black25 => brightness == Brightness.light
      ? AppColors.black.withValues(alpha: 0.25)
      : Colors.red;
  Color get black45 => brightness == Brightness.light
      ? AppColors.black.withValues(alpha: 0.45)
      : Colors.red;
  Color get black85 => brightness == Brightness.light
      ? AppColors.black.withValues(alpha: 0.85)
      : Colors.red;

  // Color get textTertiary => brightness == Brightness.light ? AppColors.gullGrey : Colors.red;
  // Color get text4 => brightness == Brightness.light ? AppColors.mirageBlack : Colors.red;
  // Color get text5 => brightness == Brightness.light ? AppColors.minskBlue : Colors.red;
  // Color get text6 => brightness == Brightness.light ? AppColors.ebonyBlack : Colors.red;
  // Color get text7 => brightness == Brightness.light ? AppColors.rockBlack : Colors.red;
  // Color get text8 => brightness == Brightness.light ? AppColors.oxfordBlue : Colors.red;

  // Color get subTextPrimary => brightness == Brightness.light ? ColorPath.paleGrey : Colors.red;
  // Color get subTextSecondary => brightness == Brightness.light ? ColorPath.oxfordBlue : Colors.red;
  // Color get subTextTertiary => brightness == Brightness.light ? ColorPath.fiordGrey : Colors.red;

  Color get themeBg =>
      brightness == Brightness.light ? Colors.black : Colors.white;
  Color get themeTextColor =>
      brightness == Brightness.light ? Colors.white : Colors.black;
  Color get themeContainerColor =>
      brightness == Brightness.light ? Colors.white : Colors.black;
  // Color get notificaltionBg => brightness == Brightness.light ? ColorPath.athensGrey5 : const Color.fromARGB(255, 207, 204, 204);
  // Color get themeTextColor => brightness == Brightness.light ? Colors.white : Colors.black;
  // Color get notificaltionBg => brightness == Brightness.light ? ColorPath.athensGrey5 : const Color.fromARGB(255, 24, 23, 23);
}
