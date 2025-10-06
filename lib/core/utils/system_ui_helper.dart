import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Helper class for managing system UI and safe areas
class SystemUIHelper {
  /// Get the bottom padding for navigation bar
  static double getBottomPadding(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Get the top padding for status bar
  static double getTopPadding(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Get horizontal padding for notches/cutouts
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    return EdgeInsets.only(
      left: padding.left,
      right: padding.right,
    );
  }

  /// Get all system UI padding
  static EdgeInsets getSystemPadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Check if device has navigation bar
  static bool hasNavigationBar(BuildContext context) {
    return MediaQuery.of(context).padding.bottom > 0;
  }

  /// Configure system UI overlay style for edge-to-edge
  static SystemUiOverlayStyle getSystemUIStyle({
    required bool isDarkMode,
    Color? statusBarColor,
    Color? navigationBarColor,
  }) {
    return SystemUiOverlayStyle(
      statusBarColor: statusBarColor ?? Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: navigationBarColor ?? Colors.transparent,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
    );
  }

  /// Widget wrapper for safe area with custom padding
  static Widget safeAreaWrapper({
    required Widget child,
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
    EdgeInsets? minimum,
  }) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      minimum: minimum ?? EdgeInsets.zero,
      child: child,
    );
  }

  /// Get safe bottom navigation height including system padding
  static double getSafeBottomNavHeight(BuildContext context, double baseHeight) {
    final bottomPadding = getBottomPadding(context);
    return baseHeight + bottomPadding;
  }
}