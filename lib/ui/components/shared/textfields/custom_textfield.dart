import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String? labelText, hintText, optionalText;
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
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final bool? enableInteractiveSelection;
  final bool? showCursor;
  final TextInputType? inputType;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;

  // Simplified validation properties
  final String? fieldId; // Unique identifier for the field
  final FieldType? fieldType; // Predefined field type
  final List<ValidationRule>? customValidationRules; // Custom rules if needed
  final CustomFormController? formController; // Form controller
  final bool showIsRequiredIcon; // Simple required flag
  final bool isRequired; // Simple required flag

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
    this.contentPadding,
    this.enableInteractiveSelection,
    this.showCursor,
    this.onTap,
    this.inputType,
    this.inputFormatters,
    // Simplified validation
    this.fieldId,
    this.fieldType,
    this.customValidationRules,
    this.formController,
    this.isRequired = false,
    this.showIsRequiredIcon = false,
  });

  @override
  State<CustomTextField> createState() => CustomTextFieldState();
}

class CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;
  String? errorText;
  bool hasBeenValidated = false;
  late TextEditingController controller;
  List<ValidationRule> validationRules = [];

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();

    _setupValidationRules();

    List<KeyboardType> numsKeyboardType = [
      KeyboardType.decimal,
      KeyboardType.number,
    ];

    if (widget.focusNode != null &&
        numsKeyboardType.contains(widget.keyboardType)) {
      KeyboardOverlay.addRemoveFocusNode(context, widget.focusNode!);
    }

    // Register with form controller if provided
    if (widget.formController != null && widget.fieldId != null) {
      widget.formController!.registerField(widget.fieldId!, this);
    }

    // Listen to text changes for real-time validation
    controller.addListener(_onTextChanged);
  }

  void _setupValidationRules() {
    validationRules.clear();

    // Add required validation if needed
    if (widget.isRequired) {
      validationRules.add(ValidationRules.required());
    }

    // Add predefined validation based on field type
    if (widget.fieldType != null) {
      switch (widget.fieldType!) {
        case FieldType.email:
          validationRules.add(ValidationRules.email());
          break;
        case FieldType.password:
          validationRules.add(ValidationRules.password());
          break;
        case FieldType.phone:
          validationRules.add(ValidationRules.phone());
          break;
        case FieldType.name:
          validationRules.add(ValidationRules.minLength(2));
          break;
        case FieldType.number:
          validationRules.add(ValidationRules.numeric());
          break;
        case FieldType.text:
          // No additional rules for basic text
          break;
      }
    }

    // Add custom validation rules
    if (widget.customValidationRules != null) {
      validationRules.addAll(widget.customValidationRules!);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onTextChanged);

    // Unregister from form controller BEFORE disposing
    if (widget.formController != null && widget.fieldId != null) {
      widget.formController!.unregisterField(widget.fieldId!);
    }

    // Only dispose controller if it was created internally
    // Note: If using enhanced FormController, it will handle disposal
    if (widget.controller == null && widget.formController == null) {
      controller.dispose();
    }

    super.dispose();
  }

  void _onTextChanged() {
    if (hasBeenValidated) {
      _validateField(controller.text);
    }
  }

  String? _validateField(String value) {
    if (validationRules.isEmpty) {
      return null;
    }

    for (final rule in validationRules) {
      final error = rule.validate(value);
      if (error != null) {
        setState(() {
          errorText = error;
        });

        // Update form controller
        if (widget.formController != null && widget.fieldId != null) {
          widget.formController!.updateFieldValidation(widget.fieldId!, false);
        }

        return error;
      }
    }

    setState(() {
      errorText = null;
    });

    // Update form controller
    if (widget.formController != null && widget.fieldId != null) {
      widget.formController!.updateFieldValidation(widget.fieldId!, true);
    }

    return null;
  }

  void validateField() {
    hasBeenValidated = true;
    _validateField(controller.text);
  }

  void clearValidation() {
    setState(() {
      errorText = null;
      hasBeenValidated = false;
    });

    // Update form controller
    if (widget.formController != null && widget.fieldId != null) {
      widget.formController!.updateFieldValidation(widget.fieldId!, false);
    }
  }

  bool get isValid =>
      errorText == null && (validationRules.isEmpty || hasBeenValidated);

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
              RichText(
                text: TextSpan(
                  children: [
                    if (widget.showIsRequiredIcon)
                      TextSpan(
                        text: '* ',
                        style: TextStyle(
                          color: AppColors.red4F,
                          fontSize: widget.labelSize ?? 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    TextSpan(
                      text: widget.labelText ?? '',
                      style: AppTypography.text14,
                    ),
                    WidgetSpan(child: SizedBox(width: 4)),
                    TextSpan(
                      text: widget.optionalText ?? '',
                      style: TextStyle(
                        color: AppColors.black.withValues(alpha: 0.45),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              const YBox(6)
            ],
          ),
        Container(
          width: widget.width ?? Sizer.screenWidth,
          height: widget.maxLines != null ? null : widget.height ?? 52.h,
          alignment: Alignment.center,
          child: Center(
            child: TextFormField(
              enableInteractiveSelection: widget.enableInteractiveSelection,
              showCursor: widget.showCursor,
              maxLines: widget.maxLines ?? 1,
              textAlign: widget.textAlign,
              cursorHeight: 16.sp,
              cursorColor: AppColors.black,
              focusNode: widget.focusNode,
              style: TextStyle(
                color: widget.textfieldColor ?? AppColors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
              controller: controller,
              obscureText: widget.isPassword! && !showPassword,
              keyboardType: widget.inputType ?? inputType(widget.keyboardType),
              onFieldSubmitted: (value) {
                validateField();
                widget.onSubmitted?.call(value);
              },
              inputFormatters:
                  widget.inputFormatters ?? inputFormatter(widget.keyboardType),
              onChanged: (value) {
                widget.onChanged?.call(value);
              },
              onTap: widget.onTap,
              readOnly: widget.isReadOnly!,
              decoration: InputDecoration(
                errorText: null, // We handle errors manually
                contentPadding: widget.contentPadding ??
                    EdgeInsets.only(
                      top: 20.h,
                      bottom: 0.h,
                      left: 14.w,
                      right: 10.w,
                    ),
                hintText: widget.hintText,
                hintStyle: widget.hintStyle ??
                    TextStyle(
                      fontSize: Sizer.text(14),
                      fontWeight: FontWeight.w400,
                      color: AppColors.black.withValues(alpha: 0.45),
                    ),
                suffixIcon: widget.suffixIcon ?? suffixIcon(),
                prefix: widget.prefix,
                prefixIcon: widget.prefixIcon,
                fillColor: widget.fillColor ?? AppColors.white,
                filled: widget.showfillColor ?? true,
                enabledBorder: OutlineInputBorder(
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : BorderSide(
                          width: 1,
                          color: errorText != null
                              ? AppColors.red.withValues(alpha: 0.8)
                              : widget.borderColor ?? AppColors.neutral5,
                        ),
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 8.r),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : BorderSide(
                          width: 1,
                          color: errorText != null
                              ? AppColors.red.withOpacity(0.8)
                              : AppColors.neutral5,
                        ),
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 8.r),
                ),
                border: OutlineInputBorder(
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : BorderSide(
                          width: 1,
                          color: errorText != null
                              ? AppColors.red.withOpacity(0.8)
                              : AppColors.neutral5,
                        ),
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 8.r),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : BorderSide(
                          width: 1,
                          color: AppColors.red.withValues(alpha: 0.8)),
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 8.r),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : BorderSide(
                          width: 1,
                          color: AppColors.red.withValues(alpha: 0.8)),
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 8.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: widget.hideBorder
                      ? BorderSide.none
                      : BorderSide(
                          width: 1,
                          color: errorText != null
                              ? AppColors.red.withValues(alpha: 0.8)
                              : AppColors.primaryBlue.withValues(alpha: 0.4),
                        ),
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 8.r),
                ),
              ),
            ),
          ),
        ),
        errorText == null
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Text(
                  errorText!,
                  style: TextStyle(
                      color: AppColors.red.withOpacity(0.8), fontSize: 12.sp),
                ),
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
      return widget.suffixIcon;
    }
    return null;
  }
}

// Example usage - Much simpler now!

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final CustomFormController _formController = CustomFormController();

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formController.validateAllFields()) {
      // Get all field values
      final values = _formController.getFieldValues();
      printty('Email: ${values['email']}');
      printty('Password: ${values['password']}');

      // Proceed with login
      _performLogin();
    }
  }

  void _performLogin() {
    // Your login logic here
    printty('Logging in...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const YBox(100),
          // Email field - automatically validates email format
          CustomTextField(
            fieldId: 'email',
            fieldType: FieldType.email,
            isRequired: true,
            formController: _formController,
            labelText: 'Email',
            hintText: 'Enter your email',
            showLabelHeader: true,
          ),

          const SizedBox(height: 16),

          // Password field - automatically validates password strength
          CustomTextField(
            fieldId: 'password',
            fieldType: FieldType.password,
            isRequired: true,
            formController: _formController,
            labelText: 'Password',
            hintText: 'Enter your password',
            isPassword: true,
            showLabelHeader: true,
          ),

          const SizedBox(height: 24),
          // For custom validation, it's still simple:
          CustomTextField(
            fieldId: 'username',
            fieldType: FieldType.text,
            isRequired: true,
            formController: _formController,
            customValidationRules: [
              ValidationRules.minLength(3, message: "Shey dem de worry u ni"),
              ValidationRules.custom(
                condition: (value) => !value.contains(' '),
                message: 'Username cannot contain spaces',
              ),
            ],
            labelText: 'Username',
            hintText: 'Enter username',
            showLabelHeader: true,
          ),
          const SizedBox(height: 24),

          // Single button press validates everything
          ElevatedButton(
            onPressed: _onLoginPressed,
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
