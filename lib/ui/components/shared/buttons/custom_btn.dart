import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/shared/shared.dart';

class CustomBtn {
  static Widget solid({
    required Function()? onTap,
    bool online = true,
    bool isOutline = false,
    required String text,
    bool isLoading = false,
    BorderRadiusGeometry? borderRadius,
    double? width,
    double? height,
    Color? offlineColor,
    Color? onlineColor,
    Color? outlineColor,
    Color? textColor,
    TextStyle? textStyle,
  }) {
    return IgnorePointer(
      ignoring: !online || isLoading,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width ?? Sizer.screenWidth,
          height: Sizer.height(height ?? 48),
          decoration: (online && !isLoading)
              ? BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(4),
                  color: isOutline
                      ? AppColors.transparent
                      : onlineColor ?? AppColors.primaryBlue,
                  border:
                      Border.all(color: outlineColor ?? AppColors.primaryBlue),
                )
              : BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(4),
                  color: offlineColor ?? AppColors.neutral4,
                ),
          child: Center(
            child: isLoading
                ? const LoaderIcon(
                    size: 30,
                    color: AppColors.grey,
                  )
                : Text(
                    text,
                    style: textStyle ??
                        AppTypography.text14.copyWith(
                          fontWeight: FontWeight.w600,
                          color: online
                              ? textColor ?? AppColors.white
                              : AppColors.grey,
                        ),
                  ),
          ),
        ),
      ),
    );
  }

  static Widget withChild({
    required Function()? onTap,
    bool online = true,
    bool isOutline = false,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    double? width,
    double? height,
    Color? offlineColor,
    Color? onlineColor,
    Color? outlineColor,
    required Widget child,
  }) {
    return IgnorePointer(
      ignoring: !online,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width ?? Sizer.screenWidth,
          height: Sizer.height(height ?? 42),
          decoration: online
              ? BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(4),
                  color: isOutline
                      ? AppColors.transparent
                      : onlineColor ?? AppColors.primaryBlue,
                  border: isOutline
                      ? Border.all(
                          color: outlineColor ?? AppColors.primaryBlue,
                        )
                      : null,
                )
              : BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(4),
                  color: offlineColor ?? AppColors.grey,
                ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class BtnLoadState extends StatelessWidget {
  const BtnLoadState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizer.height(48),
      width: Sizer.screenWidth,
      decoration: const BoxDecoration(
        color: AppColors.neutral4,
      ),
      child: const Center(
        child: LoaderIcon(
          size: 30,
          color: AppColors.grey,
        ),
      ),
    );
  }
}
