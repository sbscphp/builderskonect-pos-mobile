// Base validation rule class

const String emptyTextField = 'This field is required';
const String emptyEmailField = 'Email address is required';
const String emptyPasswordField = 'Password is required';
const String emptyUsernameField = 'Username is required';
const String invalidEmailField = 'Please enter a valid email address';
const String invalidPhoneNumberField = 'Please enter a valid phone number';
const String passwordLengthError =
    'Password must be at least 6 characters long';
const String usernameLengthError =
    'Username must be at least 6 characters long';
const String incorrectPasscodeLength = 'Passcode must be exactly 6 digits';

abstract class ValidationRule {
  String? validate(String? value);
}

// Composable validation rule that can combine multiple rules
class CompositeValidationRule extends ValidationRule {
  final List<ValidationRule> rules;

  CompositeValidationRule(this.rules);

  @override
  String? validate(String? value) {
    for (final rule in rules) {
      final result = rule.validate(value);
      if (result != null) return result;
    }
    return null;
  }
}

// Individual validation rules
class RequiredRule extends ValidationRule {
  final String errorMessage;
  final bool isRequired;

  RequiredRule({
    this.errorMessage = 'This field is required',
    this.isRequired = true,
  });

  @override
  String? validate(String? value) {
    if (!isRequired) return null;

    if (value == null || value.trim().isEmpty) {
      return errorMessage;
    }
    return null;
  }
}

class EmailRule extends ValidationRule {
  final String errorMessage;
  static const String _emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  EmailRule({this.errorMessage = 'Please enter a valid email address'});

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;

    final regExp = RegExp(_emailRegex);
    if (!regExp.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }
}

class PhoneRule extends ValidationRule {
  final String errorMessage;
  final String phoneRegex;

  PhoneRule({
    this.errorMessage = 'Please enter a valid phone number',
    this.phoneRegex = r'^\+?[\d\s\-\(\)]{7,15}$', // Default phone regex
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;

    final regExp = RegExp(phoneRegex);
    if (!regExp.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }
}

class MinLengthRule extends ValidationRule {
  final int minLength;
  final String errorMessage;

  MinLengthRule(
    this.minLength, {
    String? errorMessage,
  }) : errorMessage = errorMessage ?? 'Minimum length is $minLength characters';

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.length < minLength) {
      return errorMessage;
    }
    return null;
  }
}

class MaxLengthRule extends ValidationRule {
  final int maxLength;
  final String errorMessage;

  MaxLengthRule(
    this.maxLength, {
    String? errorMessage,
  }) : errorMessage = errorMessage ?? 'Maximum length is $maxLength characters';

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.length > maxLength) {
      return errorMessage;
    }
    return null;
  }
}

class ExactLengthRule extends ValidationRule {
  final int exactLength;
  final String errorMessage;

  ExactLengthRule(
    this.exactLength, {
    String? errorMessage,
  }) : errorMessage = errorMessage ?? 'Must be exactly $exactLength characters';

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;

    if (value.length != exactLength) {
      return errorMessage;
    }
    return null;
  }
}

class RegexRule extends ValidationRule {
  final String pattern;
  final String errorMessage;

  RegexRule(
    this.pattern, {
    required this.errorMessage,
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;

    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }
}

class CustomRule extends ValidationRule {
  final String? Function(String?) customValidator;

  CustomRule(this.customValidator);

  @override
  String? validate(String? value) {
    return customValidator(value);
  }
}

class Validators {
  // Email validators
  static String? Function(String?) email(
      {bool isRequired = true, String? errorMessage}) {
    final rules = <ValidationRule>[];

    if (isRequired) {
      rules.add(RequiredRule(errorMessage: errorMessage ?? emptyEmailField));
    }
    rules.add(EmailRule(errorMessage: invalidEmailField));

    final validator = CompositeValidationRule(rules);
    return validator.validate;
  }

  // Phone number validators
  static String? Function(String?) phoneNumber({
    bool isRequired = true,
    String? phoneRegex,
    String? errorMessage,
  }) {
    final rules = <ValidationRule>[];

    if (isRequired) {
      rules.add(RequiredRule(errorMessage: emptyTextField));
    }
    rules.add(PhoneRule(
      errorMessage: errorMessage ?? invalidPhoneNumberField,
      phoneRegex: phoneRegex ?? r'^\+?[\d\s\-\(\)]{7,15}$',
    ));

    final validator = CompositeValidationRule(rules);
    return validator.validate;
  }

  // Password validators
  static String? Function(String?) password({
    int minLength = 6,
    bool isRequired = true,
    String? errorMessage,
  }) {
    final rules = <ValidationRule>[];

    if (isRequired) {
      rules.add(RequiredRule(errorMessage: emptyPasswordField));
    }
    rules.add(MinLengthRule(minLength,
        errorMessage: errorMessage ?? passwordLengthError));

    final validator = CompositeValidationRule(rules);
    return validator.validate;
  }

  // Username validators
  static String? Function(String?) username({
    int minLength = 6,
    bool isRequired = true,
    String? errorMessage,
  }) {
    final rules = <ValidationRule>[];

    if (isRequired) {
      rules.add(RequiredRule(errorMessage: emptyUsernameField));
    }
    rules.add(MinLengthRule(minLength,
        errorMessage: errorMessage ?? usernameLengthError));

    final validator = CompositeValidationRule(rules);
    return validator.validate;
  }

  // General field validators
  static String? Function(String?) required({String? errorMessage}) {
    final validator =
        RequiredRule(errorMessage: errorMessage ?? emptyTextField);
    return validator.validate;
  }

  static String? Function(String?) optional() {
    final validator = RequiredRule(isRequired: false);
    return validator.validate;
  }

  // Passcode validators
  static String? Function(String?) passcode({
    int length = 6,
    bool isRequired = true,
  }) {
    final rules = <ValidationRule>[];

    if (isRequired) {
      rules.add(RequiredRule(errorMessage: emptyTextField));
    }
    rules.add(ExactLengthRule(length,
        errorMessage: 'OTP must be exactly $length digits'));

    final validator = CompositeValidationRule(rules);
    return validator.validate;
  }

  // Advanced password with multiple requirements
  static String? Function(String?) strongPassword({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireNumbers = true,
    bool requireSpecialChars = true,
  }) {
    final rules = <ValidationRule>[
      RequiredRule(errorMessage: emptyPasswordField),
      MinLengthRule(minLength),
    ];

    if (requireUppercase) {
      rules.add(RegexRule(
        r'[A-Z]',
        errorMessage: 'Password must contain at least one uppercase letter',
      ));
    }

    if (requireLowercase) {
      rules.add(RegexRule(
        r'[a-z]',
        errorMessage: 'Password must contain at least one lowercase letter',
      ));
    }

    if (requireNumbers) {
      rules.add(RegexRule(
        r'[0-9]',
        errorMessage: 'Password must contain at least one number',
      ));
    }

    if (requireSpecialChars) {
      rules.add(RegexRule(
        r'[!@#$%^&*(),.?":{}|<>]',
        errorMessage: 'Password must contain at least one special character',
      ));
    }

    final validator = CompositeValidationRule(rules);
    return validator.validate;
  }
}

// Extension to make usage more convenient
extension ValidationRuleExtension on ValidationRule {
  String? call(String? value) => validate(value);
}

// Helper function to combine multiple validation rules
ValidationRule combine(List<ValidationRule> rules) {
  return CompositeValidationRule(rules);
}



// Simple email validation (required by default)
  // CustomTextField(
  //   controller: emailController,
  //   validator: Validators.email(),
  //   label: 'Email Address',
  //   hintText: "Enter email address",
  //   onChanged: (value) {
  //     setState(() {});
  //   },
  // ),
  
  // SizedBox(height: 24.h),
  
  // // Optional email validation
  // CustomTextField(
  //   controller: emailController,
  //   validator: Validators.email(isRequired: false),
  //   label: 'Optional Email',
  //   hintText: "Enter email address (optional)",
  //   onChanged: (value) {
  //     setState(() {});
  //   },
  // ),
  
  // SizedBox(height: 24.h),
  
  // // Phone number validation
  // CustomTextField(
  //   controller: phoneController,
  //   validator: Validators.phoneNumber(),
  //   label: 'Phone Number',
  //   hintText: "Enter phone number",
  // ),
  
  // SizedBox(height: 24.h),
  
  // // Strong password validation
  // CustomTextField(
  //   controller: passwordController,
  //   validator: Validators.strongPassword(),
  //   label: 'Password',
  //   hintText: "Enter strong password",
  //   obscureText: true,
  // ),
  
  // SizedBox(height: 24.h),
  
  // // Simple password (just length requirement)
  // CustomTextField(
  //   controller: passwordController,
  //   validator: Validators.password(minLength: 8),
  //   label: 'Simple Password',
  //   hintText: "Enter password",
  //   obscureText: true,
  // ),
  
  // SizedBox(height: 24.h),
  
  // // Custom validation using combine function
  // CustomTextField(
  //   validator: combine([
  //     RequiredRule(errorMessage: 'Name is required'),
  //     MinLengthRule(2, errorMessage: 'Name must be at least 2 characters'),
  //     MaxLengthRule(50, errorMessage: 'Name cannot exceed 50 characters'),
  //   ]),
  //   label: 'Full Name',
  //   hintText: "Enter your full name",
  // ),
  
  // SizedBox(height: 24.h),
  
  // // Custom regex validation
  // CustomTextField(
  //   validator: combine([
  //     RequiredRule(),
  //     RegexRule(
  //       r'^[A-Z]{2,3}\d{4,6}$',
  //       errorMessage: 'Invalid format. Use ABC1234',
  //     ),
  //   ]),
  //   label: 'Code',
  //   hintText: "Enter code (e.g., ABC1234)",
  // ),
  
  // SizedBox(height: 24.h),
  
  // // 6-digit passcode
  // CustomTextField(
  //   validator: Validators.passcode(),
  //   label: 'Verification Code',
  //   hintText: "Enter 6-digit code",
  //   keyboardType: TextInputType.number,
  // ),
  
  // SizedBox(height: 24.h),
  
  // // Custom validation logic
  // CustomTextField(
  //   validator: CustomRule((value) {
  //     if (value == null || value.isEmpty) {
  //       return 'This field is required';
  //     }
  //     if (!value.contains('@company.com')) {
  //       return 'Must be a company email';
  //     }
  //     return null;
  //   }),
  //   label: 'Company Email',
  //   hintText: "Enter company email",
  // ),