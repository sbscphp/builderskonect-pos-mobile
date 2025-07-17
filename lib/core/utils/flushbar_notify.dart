import 'package:another_flushbar/flushbar.dart';
import 'package:builders_konnect/core/core.dart';

class FlushBarToast {
  static fLSnackBar({
    required String message,
    Color? textColor,
    int? duration,
    FlushbarPosition? position,
    SnackBarType snackBarType = SnackBarType.warning,
  }) {
    return Flushbar<dynamic>(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(10),
        vertical: Sizer.width(10),
      ),
      messageText: Row(
        children: [
          Icon(
            snackBarType.icon,
            size: 30,
            color: snackBarType.iconColor,
          ),
          const XBox(10),
          Expanded(
            child: Text(message,

                // overflow: TextOverflow.ellipsis,
                // maxLines: 2,
                style: Theme.of(NavKey.appNavKey.currentContext!)
                    .textTheme
                    .text14
                    ?.copyWith(
                      color: textColor ??
                          Theme.of(NavKey.appNavKey.currentContext!)
                              .colorScheme
                              .black85,
                    )),
          ),
        ],
      ),
      backgroundColor: snackBarType.bgColor ?? AppColors.white,
      borderRadius: BorderRadius.circular(Sizer.radius(10)),
      borderColor: snackBarType.borderColor,
      flushbarPosition: position ?? FlushbarPosition.TOP,
      margin: EdgeInsets.only(
        left: Sizer.width(12),
        right: Sizer.width(12),
        bottom: Sizer.height(20),
      ),
      duration: Duration(seconds: duration ?? 5),
    ).show(NavKey.appNavKey.currentContext!);
  }
}

class SnackBarType {
  const SnackBarType({
    this.bgColor,
    this.borderColor,
    required this.iconColor,
    required this.icon,
  });
  final Color? bgColor;
  final Color? borderColor;
  final Color iconColor;
  final IconData icon;

  static const SnackBarType warning = SnackBarType(
    bgColor: AppColors.opacityRed100,
    iconColor: AppColors.red,
    icon: Iconsax.information5,
  );

  static const SnackBarType success = SnackBarType(
    bgColor: AppColors.white,
    borderColor: AppColors.primaryBlue,
    iconColor: AppColors.primaryBlue,
    icon: Icons.check_circle,
  );
}
