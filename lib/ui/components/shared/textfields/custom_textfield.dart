import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final String optionalText;
  final double labelSize;
  final FontWeight labelFontWeight;
  final Color? labelColor;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Function(String?)? onSubmit;
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
  final bool enabled, isPassword, showSuffixIcon;
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
    this.onSubmit,
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
    this.isPassword = false,
    this.showSuffixIcon = false,
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
    this.borderRadius = 4,
    this.height,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;
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
                obscureText: widget.isPassword && !showPassword,
                style: TextStyle(
                  fontSize: widget.textSize.sp,
                  color: widget.textColor,
                ),
                onChanged: widget.onChanged,
                onFieldSubmitted: widget.onSubmit,
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
                  suffixIcon: widget.suffixIcon ?? suffixIcon(),
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

  Widget? suffixIcon() {
    if (widget.isPassword) {
      return GestureDetector(
          onTap: () => setState(() {
                showPassword = !showPassword;
              }),
          child: PasswordSuffixWidget(
            showPassword: showPassword,
          ));
    }
    if (widget.showSuffixIcon && widget.suffixIcon == null) {
      return const Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 18,
        color: AppColors.black,
      );
    }

    if (widget.showSuffixIcon && widget.suffixIcon != null) {
      //return const Icon(FontAwesomeIcons.circleCheck, size: 16, color: green);
      return widget.suffixIcon;
    }
    return null;
  }
}
