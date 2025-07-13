import 'package:builders_konnect/core/core.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(),
    scaffoldBackgroundColor: AppColors.grayF5,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    textTheme: TextTheme(
      bodySmall: AppTypography.text12,
      bodyMedium: AppTypography.text14,
      bodyLarge: AppTypography.text16,
      titleSmall: AppTypography.text18,
      // titleMedium: AppTypography.text20,
      titleLarge: AppTypography.text22,
    ),
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    textTheme: TextTheme(
      bodySmall: AppTypography.text12,
      bodyMedium: AppTypography.text14,
      bodyLarge: AppTypography.text16,
      titleSmall: AppTypography.text18,
      // titleMedium: AppTypography.text20,
      titleLarge: AppTypography.text22,
    ),
    useMaterial3: true,
  );

  //update status bar colors dynamically
  static void updateStatusBarBrightness({required ThemeMode themeMode}) {
    if (themeMode == ThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      );
    } else {
      debugPrint('here>>>>>');
      // systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
      //   statusBarColor: Colors.transparent,
      // ),
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    }
  }
}
