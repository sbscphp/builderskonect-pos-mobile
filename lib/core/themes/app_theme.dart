import 'package:builders_konnect/core/core.dart';

class AppTheme {
  static TextStyle withBold(TextStyle baseStyle) {
    return baseStyle.copyWith(fontWeight: FontWeight.bold);
  }

  static TextStyle withSemiBold(TextStyle baseStyle) {
    return baseStyle.copyWith(fontWeight: FontWeight.w600);
  }

  static TextStyle withMedium(TextStyle baseStyle) {
    return baseStyle.copyWith(fontWeight: FontWeight.w500);
  }

  // Helper method to create TextTheme with ColorScheme colors
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      bodySmall: TextStyle(
        fontSize: Sizer.text(12),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      bodyMedium: TextStyle(
        fontSize: Sizer.text(14),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      bodyLarge: TextStyle(
        fontSize: Sizer.text(16),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      displaySmall: TextStyle(
        fontSize: Sizer.text(18),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      displayMedium: TextStyle(
        fontSize: Sizer.text(20),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      displayLarge: TextStyle(
        fontSize: Sizer.text(22),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      headlineSmall: TextStyle(
        fontSize: Sizer.text(24),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      headlineMedium: TextStyle(
        fontSize: Sizer.text(26),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      headlineLarge: TextStyle(
        fontSize: Sizer.text(28),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      titleSmall: TextStyle(
        fontSize: Sizer.text(30),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      titleMedium: TextStyle(
        fontSize: Sizer.text(32),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      titleLarge: TextStyle(
        fontSize: Sizer.text(34),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      labelSmall: TextStyle(
        fontSize: Sizer.text(36),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      labelMedium: TextStyle(
        fontSize: Sizer.text(38),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
      labelLarge: TextStyle(
        fontSize: Sizer.text(40),
        fontFamily: 'Roboto',
        color: colorScheme.black85,
      ),
    );
  }

  static ThemeData lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(),
    scaffoldBackgroundColor: AppColors.grayF5,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    fontFamily: 'Roboto',
    useMaterial3: true,
  ).copyWith(
    textTheme: _buildTextTheme(const ColorScheme.light()),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(),
    scaffoldBackgroundColor:
        const Color(0xFF121212), // Material dark background
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    fontFamily: 'Roboto',
    useMaterial3: true,
  ).copyWith(
    textTheme: _buildTextTheme(const ColorScheme.dark()),
  );
}
