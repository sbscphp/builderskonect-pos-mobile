import 'package:builders_konnect/core/core.dart';

extension AppTextTheme on TextTheme {
  TextStyle? get text12 => bodySmall;
  TextStyle? get text14 => bodyMedium;
  TextStyle? get text16 => bodyLarge;
  TextStyle? get text18 => displaySmall;
  TextStyle? get text20 => displayMedium;
  TextStyle? get text22 => displayLarge;
  TextStyle? get text24 => headlineSmall;
  TextStyle? get text26 => headlineMedium;
  TextStyle? get text28 => headlineLarge;
  TextStyle? get text30 => titleSmall;
  TextStyle? get text32 => titleMedium;
  TextStyle? get text34 => titleLarge;
  TextStyle? get text36 => labelSmall;
  TextStyle? get text38 => labelMedium;
  TextStyle? get text40 => labelLarge;
}

extension TextStyleExtensions on TextStyle {
  TextStyle get bold => AppTheme.withBold(this);
  TextStyle get medium => AppTheme.withMedium(this);
}
