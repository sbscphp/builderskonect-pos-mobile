import 'package:builders_konnect/core/core.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String optionalText;
  final double labelSize;
  final FontWeight labelFontWeight;
  final Color? labelColor;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final Function()? onTsp;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final double textSize;
  final Color textColor;
  final bool obscure;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String hintText;
  final String bottomHintText;
  final double hintSize, borderRadius;
  final Color? hintColor;
  final bool enabled;
  final bool readOnly;
  final bool isRequired;
  final bool hideBorder;
  final FocusNode? focusNode;
  final int maxLines;
  final bool isMoneyValue;
  final Color? bgColor;
  final Color? fillColor;
  final bool showLabelHeader;
  final double? height;

  const CustomTextField({
    super.key,
    this.labelText = '',
    this.optionalText = '',
    this.labelSize = 14,
    this.labelFontWeight = FontWeight.w500,
    this.labelColor,
    this.controller,
    this.onChanged,
    this.validator,
    this.onTsp,
    this.inputFormatters,
    this.keyboardType = TextInputType.text,
    this.textSize = 14,
    this.textColor = Colors.black,
    this.obscure = false,
    this.suffixIcon,
    this.hintText = '',
    this.hintSize = 16,
    this.hintColor,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
    this.bottomHintText = '',
    this.isRequired = true,
    this.hideBorder = false,
    this.focusNode,
    this.maxLines = 1,
    this.isMoneyValue = false,
    this.bgColor,
    this.fillColor,
    this.showLabelHeader = true,
    this.borderRadius = 0,
    this.height,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  //final FocusNode _focusNode = FocusNode();
  //bool _isActive = false;

  @override
  void dispose() {
    //_focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabelHeader)
          RichText(
            text: TextSpan(
              children: [
                if (widget.isRequired)
                  TextSpan(
                    text: '* ',
                    style: TextStyle(
                      color: AppColors.red4F,
                      fontSize: widget.labelSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                TextSpan(
                  text: widget.labelText,
                  style: textTheme.text14,
                ),
                WidgetSpan(child: SizedBox(width: 4)),
                TextSpan(
                  text: widget.optionalText,
                  style: TextStyle(
                    color: AppColors.black.withValues(alpha: 0.45),
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        if (widget.showLabelHeader) YBox(4),
        Container(
          height: widget.maxLines > 1 ? null : (widget.height ?? 58.h),
          width: double.infinity,
          decoration: BoxDecoration(
              //color: ColorPath.athensGrey2,
              color: widget.bgColor,
              //border: Border.all(color: ColorPath.mischkaGrey, width: 1.w),
              borderRadius: BorderRadius.all(
                  Radius.circular(Sizer.radius(widget.borderRadius)))
              // borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(8.r),
              //     topRight: Radius.circular(8.r)
              // )
              ),
          child: Center(
            child: TextFormField(
                maxLines: widget.maxLines,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enabled: widget.enabled,
                readOnly: widget.readOnly,
                validator: widget.validator,
                controller: widget.controller,
                focusNode: widget.focusNode,
                obscureText: widget.obscure,
                style: TextStyle(
                  fontSize: widget.textSize.sp,
                  color: widget.textColor,
                ),
                onChanged: widget.onChanged,
                onTap: widget.onTsp,
                keyboardType: widget.keyboardType,
                inputFormatters: widget.inputFormatters,
                decoration: InputDecoration(
                  errorStyle: textTheme.text12?.copyWith(
                    color: AppColors.red4F,
                  ),
                  isDense: false,
                  errorMaxLines: 3,
                  hintText: widget.hintText,
                  hintStyle: textTheme.text14?.copyWith(
                      color: widget.hintColor?.withValues(alpha: 0.3) ??
                          colorScheme.black25,
                      fontSize: widget.labelSize,
                      fontWeight: FontWeight.w500),
                  suffixIcon: widget.suffixIcon,
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 30.w,
                    minHeight: 30.h,
                  ),
                  prefixIcon: widget.prefixIcon,
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 40.w,
                    minHeight: 30.h,
                  ),
                  filled: true,
                  fillColor: widget.fillColor,
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: EdgeInsets.only(
                    top: widget.maxLines > 1 ? 12 : 0,
                    left: 16.w,
                    right: 16.w,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.hideBorder
                            ? Colors.transparent
                            : AppColors.neutral5,
                        width: 1.w),
                    borderRadius: BorderRadius.circular(
                        Sizer.radius(widget.borderRadius)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.hideBorder
                            ? Colors.transparent
                            : AppColors.neutral5,
                        width: 1.w),
                    borderRadius: BorderRadius.circular(
                        Sizer.radius(widget.borderRadius)),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: widget.hideBorder
                            ? Colors.transparent
                            : AppColors.neutral5,
                        width: 1.w),
                    borderRadius: BorderRadius.circular(
                        Sizer.radius(widget.borderRadius)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.hideBorder
                          ? Colors.transparent
                          : AppColors.neutral5,
                      width: 1.w,
                    ),
                    borderRadius: BorderRadius.circular(
                        Sizer.radius(widget.borderRadius)),
                  ),
                )),
          ),
        ),
        if (widget.bottomHintText.isNotEmpty) SizedBox(height: 4.h),
        if (widget.bottomHintText.isNotEmpty)
          Text(
            widget.bottomHintText,
            style: textTheme.bodySmall?.copyWith(
                color: colorScheme.black25, fontWeight: FontWeight.w400),
            textAlign: TextAlign.left,
          ),
      ],
    );
  }
}

// class Two extends StatefulWidget {
//   final String? errorText, labelText, hintText, optionalText;
//   final int? maxLines;
//   final TextEditingController? controller;
//   final Function(String)? onChanged;
//   final Function(String)? onSubmitted;
//   final bool isRequired,
//       isPassword,
//       isConfirmPassword,
//       showSuffixIcon,
//       showfillColor;
//   final Widget? suffixIcon, prefix, prefixIcon;
//   final KeyboardType keyboardType;
//   final double? width, height, labelSize;
//   final double? borderRadius;
//   final bool? isReadOnly;
//   final FocusNode? focusNode;
//   final bool showLabelHeader, hideBorder;
//   final Color? labelColor;
//   final Color? fillColor;
//   final Color? borderColor;
//   final Color? textfieldColor;
//   final TextAlign textAlign;
//   final TextStyle? hintStyle;
//   final EdgeInsetsGeometry? contentPadding;
//   final bool? enableInteractiveSelection;
//   final bool? showCursor;
//   final TextInputType? inputType;
//   final String? Function(String?)? validator;
//   final Function()? onTap;
//   final List<TextInputFormatter>? inputFormatters;

//   const Two(
//       {super.key,
//       this.maxLines,
//       this.labelText,
//       this.hintText,
//       this.optionalText,
//       this.labelColor,
//       this.textfieldColor,
//       this.fillColor,
//       this.borderColor,
//       this.labelSize,
//       this.controller,
//       this.isRequired = false,
//       this.isPassword = false,
//       this.isConfirmPassword = false,
//       this.showSuffixIcon = false,
//       this.hideBorder = false,
//       this.showfillColor = false,
//       this.suffixIcon,
//       this.prefix,
//       this.prefixIcon,
//       this.errorText,
//       this.width,
//       this.height,
//       this.borderRadius,
//       this.isReadOnly = false,
//       this.keyboardType = KeyboardType.regular,
//       this.showLabelHeader = false,
//       this.focusNode,
//       this.onChanged,
//       this.onSubmitted,
//       this.textAlign = TextAlign.start,
//       this.hintStyle,
//       this.contentPadding,
//       this.enableInteractiveSelection,
//       this.showCursor,
//       this.onTap,
//       this.inputType,
//       this.validator,
//       this.inputFormatters});

//   @override
//   State<Two> createState() => _TwoState();
// }

// class _TwoState extends State<Two> {
//   bool showPassword = false;

//   @override
//   void initState() {
//     super.initState();
//     List<KeyboardType> numsKeyboardType = [
//       KeyboardType.decimal,
//       KeyboardType.number,
//     ];
//     // KeyboardOverlay.showOverlay(context);
//     if (widget.focusNode != null &&
//         numsKeyboardType.contains(widget.keyboardType)) {
//       KeyboardOverlay.addRemoveFocusNode(context, widget.focusNode!);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final colorScheme = Theme.of(context).colorScheme;
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (widget.showLabelHeader)
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               RichText(
//                 text: TextSpan(
//                   children: [
//                     if (widget.isRequired)
//                       TextSpan(
//                         text: '* ',
//                         style: TextStyle(
//                           color: AppColors.red4F,
//                           fontSize: widget.labelSize ?? 14.sp,
//                           fontWeight: FontWeight.w400,
//                         ),
//                       ),
//                     TextSpan(
//                       text: widget.labelText ?? '',
//                       style: textTheme.text14,
//                     ),
//                     WidgetSpan(child: SizedBox(width: 4)),
//                     TextSpan(
//                       text: widget.optionalText ?? '',
//                       style: TextStyle(
//                         color: AppColors.black.withValues(alpha: 0.45),
//                         fontSize: 12.sp,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const YBox(4)
//             ],
//           ),
//         Container(
//           // color: AppColors.red.withOpacity(0.1),
//           width: widget.width ?? Sizer.screenWidth,
//           height: widget.maxLines != null ? null : widget.height ?? 52.h,
//           alignment: Alignment.center,
//           child: Center(
//             child: TextFormField(
//               enableInteractiveSelection: widget.enableInteractiveSelection,
//               showCursor: widget.showCursor,
//               maxLines: widget.maxLines ?? 1,
//               textAlign: widget.textAlign,
//               cursorHeight: 16.sp,
//               cursorColor: AppColors.black,
//               focusNode: widget.focusNode,
//               style: TextStyle(
//                 color: widget.textfieldColor ?? AppColors.black,
//                 fontSize: 16.sp,
//                 fontWeight: FontWeight.w400,
//               ),
//               controller: widget.controller,
//               obscureText: widget.isPassword && !showPassword,
//               keyboardType: widget.inputType ?? inputType(widget.keyboardType),
//               validator: widget.validator,
//               onFieldSubmitted: widget.onSubmitted,
//               inputFormatters:
//                   widget.inputFormatters ?? inputFormatter(widget.keyboardType),
//               onChanged: widget.onChanged,
//               onTap: widget.onTap,
//               readOnly: widget.isReadOnly!,
//               decoration: InputDecoration(
//                 errorText: widget.errorText,
//                 errorStyle: TextStyle(
//                     color: AppColors.red, fontSize: 0.01.sp, height: 0.2),
//                 contentPadding: widget.contentPadding ??
//                     EdgeInsets.only(
//                       //left: 16.w,
//                       top: 20.h,
//                       bottom: 0.h,
//                       left: 14.w,
//                       right: 10.w,
//                     ),
//                 // labelText: widget.labelText,
//                 hintText: widget.hintText,
//                 hintStyle: widget.hintStyle ??
//                     TextStyle(
//                       fontSize: Sizer.text(16),
//                       fontWeight: FontWeight.w400,
//                       color: colorScheme.black25,
//                     ),
//                 suffixIcon: widget.suffixIcon ?? suffixIcon(),
//                 prefix: widget.prefix,
//                 prefixIcon: widget.prefixIcon,
//                 // suffixIconColor: AppColors.brandOrange,

//                 fillColor: widget.fillColor ?? AppColors.white,
//                 filled: widget.showfillColor,
//                 // isCollapsed: true,
//                 // isDense: true,
//                 // labelStyle: TextStyle(color: bluishGrey, fontSize: 14.sp),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: widget.hideBorder
//                       ? BorderSide.none
//                       : BorderSide(
//                           width: 1,
//                           color: widget.borderColor ?? AppColors.neutral5,
//                         ),
//                   borderRadius:
//                       BorderRadius.circular(widget.borderRadius ?? 8.r),
//                 ),
//                 disabledBorder: OutlineInputBorder(
//                   borderSide: widget.hideBorder
//                       ? BorderSide.none
//                       : const BorderSide(
//                           width: 1,
//                           color: AppColors.neutral5,
//                         ),
//                   borderRadius:
//                       BorderRadius.circular(widget.borderRadius ?? 8.r),
//                 ),
//                 border: OutlineInputBorder(
//                   borderSide: widget.hideBorder
//                       ? BorderSide.none
//                       : const BorderSide(
//                           width: 1,
//                           color: AppColors.neutral5,
//                         ),
//                   borderRadius:
//                       BorderRadius.circular(widget.borderRadius ?? 8.r),
//                 ),
//                 errorBorder: OutlineInputBorder(
//                   //borderSide: BorderSide.none,
//                   borderSide: widget.hideBorder
//                       ? BorderSide.none
//                       : BorderSide(
//                           width: 1, color: AppColors.red.withOpacity(0.8)),
//                   borderRadius:
//                       BorderRadius.circular(widget.borderRadius ?? 8.r),
//                 ),
//                 focusedErrorBorder: OutlineInputBorder(
//                   borderSide: widget.hideBorder
//                       ? BorderSide.none
//                       : BorderSide(
//                           width: 1, color: AppColors.red.withOpacity(0.8)),
//                   borderRadius:
//                       BorderRadius.circular(widget.borderRadius ?? 8.r),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: widget.hideBorder
//                       ? BorderSide.none
//                       : BorderSide(
//                           width: 1,
//                           color: AppColors.primaryBlue.withValues(alpha: 0.4),
//                         ),
//                   borderRadius:
//                       BorderRadius.circular(widget.borderRadius ?? 8.r),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         widget.errorText == null
//             ? const SizedBox.shrink()
//             : Text(
//                 widget.errorText ?? "",
//                 style: TextStyle(
//                     color: AppColors.red.withOpacity(0.8), fontSize: 12.sp),
//               )
//       ],
//     );
//   }

//   Widget? suffixIcon() {
//     if (widget.isPassword || widget.isConfirmPassword) {
//       return GestureDetector(
//           onTap: () => setState(() {
//                 showPassword = !showPassword;
//               }),
//           child: PasswordSuffixWidget(
//             showPassword: showPassword,
//           ));
//     }
//     if (widget.showSuffixIcon && widget.suffixIcon == null) {
//       return const Icon(
//         Iconsax.arrow_down,
//         size: 18,
//         color: AppColors.black,
//       );
//     }

//     if (widget.showSuffixIcon && widget.suffixIcon != null) {
//       //return const Icon(FontAwesomeIcons.circleCheck, size: 16, color: green);
//       return widget.suffixIcon;
//     }
//     return null;
//   }
// }
