import 'package:builders_konnect/core/core.dart';
import 'package:pinput/pinput.dart';

class PinInputTheme {
  static defaultPinTheme({double? borderRadius, Color? bgColor}) {
    return PinTheme(
      width: Sizer.width(48),
      height: Sizer.height(48),
      // margin: EdgeInsets.only(right: 8.w),
      textStyle: TextStyle(
        fontSize: Sizer.text(20),
        color: AppColors.black.withValues(alpha: 0.85),
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: bgColor ?? AppColors.transparent,
        border: Border.all(
          color: AppColors.grayA4,
          width: 0,
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? Sizer.radius(8)),
      ),
    );
  }

  static followPinTheme({double? borderRadius}) {
    return defaultPinTheme().copyDecorationWith(
      border: Border.all(width: Sizer.width(1), color: AppColors.grayA4),
      borderRadius: BorderRadius.circular(borderRadius ?? Sizer.radius(8)),
      // color: AppColors.grayF7,
    );
  }

  static focusFillPinTheme() {
    return defaultPinTheme().copyDecorationWith(
        border: Border.all(width: 0, color: AppColors.neutral5),
        color: AppColors.primaryBlue.withOpacity(0.1));
  }

  // static changePinTheme() {
  //   return defaultPinTheme().copyDecorationWith(
  //     border: Border.all(width: 0, color: AppColors.primaryGreen),
  //     // color: AppColors.primaryOrange,
  //   );
  // }
}
