import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/shared/shared.dart';
import 'package:flutter/cupertino.dart';

class CustomBtn extends StatelessWidget {
  final Function()? onTap;
  final bool online;
  final bool isOutline;
  final String? text;
  final bool isLoading;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final double? width;
  final double? height;
  final Color? offlineColor;
  final Color? onlineColor;
  final Color? outlineColor;
  final Color? textColor;
  final double? textSize;
  final TextStyle? textStyle;
  final Widget? child;

  const CustomBtn({
    super.key,
    required this.onTap,
    this.online = true,
    this.isOutline = false,
    this.text,
    this.isLoading = false,
    this.borderRadius,
    this.padding,
    this.border,
    this.width,
    this.height,
    this.offlineColor,
    this.onlineColor,
    this.outlineColor,
    this.textColor,
    this.textSize,
    this.textStyle,
    this.child,
  }) : assert(text != null || child != null,
            'Either text or child must be provided');

  // Named constructor for solid button with text
  const CustomBtn.solid({
    Key? key,
    required Function()? onTap,
    bool online = true,
    bool isOutline = false,
    required String text,
    bool isLoading = false,
    BorderRadiusGeometry? borderRadius,
    final BoxBorder? border,
    double? width,
    double? height,
    Color? offlineColor,
    Color? onlineColor,
    Color? outlineColor,
    Color? textColor,
    TextStyle? textStyle,
  }) : this(
          key: key,
          onTap: onTap,
          online: online,
          isOutline: isOutline,
          text: text,
          isLoading: isLoading,
          borderRadius: borderRadius,
          border: border,
          width: width,
          height: height,
          offlineColor: offlineColor,
          onlineColor: onlineColor,
          outlineColor: outlineColor,
          textColor: textColor,
          textStyle: textStyle,
        );

  // Named constructor for button with custom child
  const CustomBtn.withChild({
    Key? key,
    required Function()? onTap,
    bool online = true,
    bool isOutline = false,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry? padding,
    BoxBorder? border,
    double? width,
    double? height,
    Color? offlineColor,
    Color? onlineColor,
    Color? outlineColor,
    required Widget child,
  }) : this(
          key: key,
          onTap: onTap,
          online: online,
          isOutline: isOutline,
          borderRadius: borderRadius,
          padding: padding,
          border: border,
          width: width,
          height: height,
          offlineColor: offlineColor,
          onlineColor: onlineColor,
          outlineColor: outlineColor,
          child: child,
        );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IgnorePointer(
      ignoring: !online || (text != null && isLoading),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width ?? Sizer.screenWidth,
          height: Sizer.height(height ?? 52),
          decoration: (online && !(text != null && isLoading))
              ? BoxDecoration(
                  borderRadius: borderRadius ??
                      BorderRadius.circular(Sizer.radius(Sizer.radius(4))),
                  color: isOutline
                      ? AppColors.transparent
                      : onlineColor ?? colorScheme.primaryColor,
                  border: border ??
                      Border.all(
                          color: outlineColor ?? AppColors.neutral5, width: 1))
              : BoxDecoration(
                  borderRadius:
                      borderRadius ?? BorderRadius.circular(Sizer.radius(4)),
                  color: offlineColor ?? AppColors.neutral5,
                  border: Border.all(
                      color: outlineColor ?? AppColors.neutral5, width: 1)),
          child: Center(
            child: _buildChild(context),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (child != null) {
      return child!;
    }

    if (text != null) {
      if (isLoading) {
        return const CupertinoActivityIndicator();
      }

      return Text(
        text!,
        style: textStyle ??
            textTheme.text16?.copyWith(
              fontSize: textSize,
              color: textColor ?? AppColors.white,
            ),
      );
    }

    return const SizedBox.shrink();
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
        child: SpinKitLoader(
          color: AppColors.neutral5,
          size: 30,
        ),
      ),
    );
  }
}
