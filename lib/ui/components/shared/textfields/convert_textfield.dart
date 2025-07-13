import 'package:builders_konnect/core/core.dart';
import 'package:flutter/services.dart';

class ConvertTextfield extends StatelessWidget {
  const ConvertTextfield({
    super.key,
    this.hintText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.textAlign,
    this.color,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
  });

  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final Color? color;
  final TextAlign? textAlign;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      readOnly: readOnly,
      textAlign: textAlign ?? TextAlign.end,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      controller: controller,
      focusNode: focusNode,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ],
      // inputFormatters: inputFormatters ?? inputFormatter(KeyboardType.decimal),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.text16.copyWith(
          color: AppColors.grey,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(
          bottom: Sizer.width(8),
        ),
      ),
      style: AppTypography.text16.copyWith(
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}
