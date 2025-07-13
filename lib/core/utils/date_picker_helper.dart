// Show the modal that contains the CupertinoDatePicker

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCupertinoDatePicker {
  /// Configurable properties
  final BuildContext context;
  final VoidCallback? onDone;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final Function(DateTime) onDateTimeChanged;
  final DateTime? initialDateTime;
  final CupertinoDatePickerMode mode;
  final Color? backgroundColor;
  final Color? textColor;
  final double? height;
  final String cancelText;
  final String doneText;
  final TextStyle? actionTextStyle;
  final GlobalKey? navigationKey;

  CustomCupertinoDatePicker({
    required this.context,
    this.onDone,
    this.minimumDate,
    this.maximumDate,
    required this.onDateTimeChanged,
    this.initialDateTime,
    this.mode = CupertinoDatePickerMode.date,
    this.backgroundColor = Colors.white,
    this.textColor,
    this.height,
    this.cancelText = "Cancel",
    this.doneText = "Done",
    this.actionTextStyle,
    this.navigationKey,
  });

  /// Show the date picker modal
  void show() {
    final pickerHeight = height ?? 250.h;
    final defaultTextColor = textColor ?? Colors.black.withOpacity(0.6);
    final defaultTextStyle = TextStyle(
      color: defaultTextColor,
      fontSize: 15.sp,
    );

    // Use provided text style or fallback to default
    final textStyle = actionTextStyle ?? defaultTextStyle;

    // Get the appropriate navigation context
    BuildContext navContext = context;
    if (navigationKey != null && navigationKey is GlobalKey<NavigatorState>) {
      final navigatorKey = navigationKey as GlobalKey<NavigatorState>;
      if (navigatorKey.currentContext != null) {
        navContext = navigatorKey.currentContext!;
      }
    }

    // showCupertinoModalPopup is a built-in function of the cupertino library
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: pickerHeight,
        color: backgroundColor,
        child: Material(
          child: ListView(
            padding: const EdgeInsets.only(top: 0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.of(navContext).pop(),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0.w, left: 16.w),
                      child: Text(
                        cancelText,
                        style: textStyle,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (onDone != null) {
                        onDone!();
                      } else {
                        Navigator.of(navContext).pop();
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0.w, right: 16.w),
                      child: Text(
                        doneText,
                        style: textStyle,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(color: defaultTextColor.withOpacity(0.2)),
              Container(
                height: pickerHeight,
                padding: EdgeInsets.only(bottom: 80.h),
                child: CupertinoDatePicker(
                  initialDateTime: initialDateTime ?? DateTime.now(),
                  mode: mode,
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  onDateTimeChanged: onDateTimeChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example usage:
// CustomCupertinoDatePicker(
//   context: context,
//   onDateTimeChanged: (dateTime) {
//     // Handle date change
//   },
// ).show();

// Or more customized:
// CustomCupertinoDatePicker(
//   context: context,
//   initialDateTime: DateTime(2023, 1, 1),
//   minimumDate: DateTime(2022, 1, 1),
//   maximumDate: DateTime(2024, 12, 31),
//   mode: CupertinoDatePickerMode.dateAndTime,
//   backgroundColor: Colors.grey[100],
//   textColor: Colors.blue,
//   height: 300.h,
//   cancelText: "Back",
//   doneText: "Confirm",
//   navigationKey: NavKey.appNavKey,
//   onDateTimeChanged: (dateTime) {
//     // Handle date change
//   },
//   onDone: () {
//     // Custom done action
//     Navigator.of(context).pop();
//   },
// ).show();
