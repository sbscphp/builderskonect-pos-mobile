import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatefulWidget {
  final String? errorText, labelText, hintText, optionalText;
  final int? maxLines;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final bool? isPassword, isConfirmPassword, showSuffixIcon, showfillColor;
  final Widget? suffixIcon, prefix, prefixIcon;
  final KeyboardType keyboardType;
  final double? width, height, labelSize;
  final double? borderRadius;
  final bool? isReadOnly;
  final FocusNode? focusNode;
  final bool showLabelHeader, hideBorder;
  final Color? labelColor;
  final Color? fillColor;
  final Color? borderColor;
  final Color? textfieldColor;
  final TextAlign textAlign;
  final TextStyle? hintStyle, mainTextStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Function()? onTap;

  const CustomTextField({
    super.key,
    this.maxLines,
    this.labelText,
    this.hintText,
    this.optionalText,
    this.labelColor,
    this.textfieldColor,
    this.fillColor,
    this.borderColor,
    this.labelSize,
    this.controller,
    this.isPassword = false,
    this.isConfirmPassword = false,
    this.showSuffixIcon = false,
    this.hideBorder = false,
    this.showfillColor,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.errorText,
    this.width,
    this.height,
    this.borderRadius,
    this.isReadOnly = false,
    this.keyboardType = KeyboardType.regular,
    this.showLabelHeader = false,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.textAlign = TextAlign.start,
    this.hintStyle,
    this.mainTextStyle,
    this.contentPadding,
    this.onTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;

  @override
  void initState() {
    super.initState();
    List<KeyboardType> numsKeyboardType = [
      KeyboardType.decimal,
      KeyboardType.number,
      KeyboardType.accountNo,
      KeyboardType.bvn
    ];
    // KeyboardOverlay.showOverlay(context);
    if (widget.focusNode != null &&
        numsKeyboardType.contains(widget.keyboardType)) {
      KeyboardOverlay.addRemoveFocusNode(context, widget.focusNode!);
    }
  }

  @override
  void dispose() {
    // Clean up the focus node
    super.dispose();
    // if (widget.focusNode != null && mounted) {
    //   widget.focusNode?.dispose();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showLabelHeader)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(widget.labelText!, style: AppTypography.text14),
                  Text(
                    widget.optionalText ?? '',
                    style: AppTypography.text12,
                  ),
                ],
              ),
              const YBox(4)
            ],
          ),
        Container(
          // color: AppColors.red,
          width: widget.width ?? double.infinity,
          height: widget.maxLines != null ? null : widget.height ?? 40.h,
          alignment: Alignment.center,
          child: Center(
            child: TextField(
              maxLines: widget.maxLines ?? 1,
              textAlign: widget.textAlign,
              // cursorHeight: 14.sp,
              cursorColor: AppColors.black,
              focusNode: widget.focusNode,
              style: TextStyle(
                color: widget.textfieldColor ?? AppColors.black,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
              controller: widget.controller,
              obscureText: widget.isPassword! && !showPassword,
              keyboardType: inputType(widget.keyboardType),
              inputFormatters: inputFormatter(widget.keyboardType),
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
              onTap: widget.onTap,
              readOnly: widget.isReadOnly!,
              decoration: InputDecoration(
                errorText: widget.errorText,
                errorStyle: TextStyle(
                    color: AppColors.red, fontSize: 0.01.sp, height: 0.2),
                contentPadding: widget.contentPadding ??
                    EdgeInsets.only(
                      //left: 16.w,
                      top: Sizer.height(20),
                      bottom: Sizer.height(0),
                      left: Sizer.width(16),
                      right: Sizer.width(10),
                    ),
                // labelText: widget.labelText,
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ??
                    TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black.withValues(alpha: 0.25),
                    ),
                suffixIcon: widget.suffixIcon ?? suffixIcon(),
                prefix: widget.prefix,
                prefixIcon: widget.prefixIcon,
                // suffixIconColor: AppColors.brandOrange,

                fillColor: widget.fillColor ?? AppColors.transparent,
                filled: widget.showfillColor ?? true,
                // isCollapsed: true,
                // isDense: true,
                // labelStyle: TextStyle(color: bluishGrey, fontSize: 14.sp),
                enabledBorder: OutlineInputBorder(
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : BorderSide(
                          width: 1,
                          color: widget.borderColor ?? AppColors.neutral5,
                        ),
                  borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? Sizer.radius(2)),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : const BorderSide(
                          width: 1,
                          color: AppColors.neutral5,
                        ),
                  borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? Sizer.radius(2)),
                ),
                border: OutlineInputBorder(
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : const BorderSide(
                          width: 1,
                          color: AppColors.neutral5,
                        ),
                  borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? Sizer.radius(2)),
                ),
                errorBorder: OutlineInputBorder(
                  //borderSide: BorderSide.none,
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : BorderSide(
                          width: 1,
                          color: AppColors.red.withValues(alpha: 0.8)),
                  borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? Sizer.radius(2)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : BorderSide(
                          width: 1,
                          color: AppColors.red.withValues(alpha: 0.8)),
                  borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? Sizer.radius(2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : BorderSide(
                          width: 1,
                          color: AppColors.black.withValues(alpha: 0.4),
                        ),
                  borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? Sizer.radius(2)),
                ),
              ),
            ),
          ),
        ),
        widget.errorText == null
            ? const SizedBox.shrink()
            : Text(
                widget.errorText ?? "",
                style: TextStyle(
                    color: AppColors.red.withValues(alpha: 0.8),
                    fontSize: 12.sp),
              )
      ],
    );
  }

  Widget? suffixIcon() {
    if (widget.isPassword! || widget.isConfirmPassword!) {
      return GestureDetector(
          onTap: () => setState(() {
                showPassword = !showPassword;
              }),
          child: PasswordSuffixWidget(
            showPassword: showPassword,
          ));
    }
    if (widget.showSuffixIcon! && widget.suffixIcon == null) {
      return const Icon(
        Iconsax.arrow_down,
        size: 18,
        color: AppColors.black,
      );
    }

    if (widget.showSuffixIcon! && widget.suffixIcon != null) {
      //return const Icon(FontAwesomeIcons.circleCheck, size: 16, color: green);
      return widget.suffixIcon;
    }
    return null;
  }
}

class PasswordSuffixWidget extends StatelessWidget {
  final bool showPassword;
  const PasswordSuffixWidget({super.key, required this.showPassword});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizer.height(48),
      height: Sizer.height(26),
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: Sizer.height(11),
        bottom: Sizer.height(11),
      ),
      decoration: BoxDecoration(
        // color: AppColors.black,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: showPassword
          ? const Icon(
              Iconsax.eye_slash,
              size: 16,
              color: AppColors.black,
            )
          : const Icon(
              Iconsax.eye,
              size: 16,
              color: AppColors.black,
            ),
    );
  }
}
