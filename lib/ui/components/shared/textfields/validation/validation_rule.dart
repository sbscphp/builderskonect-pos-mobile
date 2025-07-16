// Custom validation rule class
class ValidationRule {
  final String Function(String value) validator;
  final String errorMessage;

  ValidationRule({
    required this.validator,
    required this.errorMessage,
  });

  String? validate(String value) {
    try {
      validator(value);
      return null; // No error
    } catch (e) {
      return errorMessage;
    }
  }
}

// Pre-built validation rules
class ValidationRules {
  static ValidationRule required({String? message}) {
    return ValidationRule(
      validator: (value) {
        if (value.trim().isEmpty) {
          throw 'Required';
        }
        return value;
      },
      errorMessage: message ?? 'This field is required',
    );
  }

  static ValidationRule minLength(int length, {String? message}) {
    return ValidationRule(
      validator: (value) {
        if (value.length < length) {
          throw 'MinLength';
        }
        return value;
      },
      errorMessage: message ?? 'Must be at least $length characters',
    );
  }

  static ValidationRule maxLength(int length, {String? message}) {
    return ValidationRule(
      validator: (value) {
        if (value.length > length) {
          throw 'MaxLength';
        }
        return value;
      },
      errorMessage: message ?? 'Must be no more than $length characters',
    );
  }

  static ValidationRule email({String? message}) {
    return ValidationRule(
      validator: (value) {
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!emailRegex.hasMatch(value)) {
          throw 'Email';
        }
        return value;
      },
      errorMessage: message ?? 'Please enter a valid email address',
    );
  }

  static ValidationRule password({String? message}) {
    return ValidationRule(
      validator: (value) {
        // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
        final passwordRegex =
            RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$');
        if (!passwordRegex.hasMatch(value)) {
          throw 'Password';
        }
        return value;
      },
      errorMessage: message ??
          'Password must be at least 8 characters with uppercase, lowercase, and number',
    );
  }

  static ValidationRule phone({String? message}) {
    return ValidationRule(
      validator: (value) {
        final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
        if (!phoneRegex.hasMatch(value)) {
          throw 'Phone';
        }
        return value;
      },
      errorMessage: message ?? 'Please enter a valid phone number',
    );
  }

  static ValidationRule numeric({String? message}) {
    return ValidationRule(
      validator: (value) {
        if (double.tryParse(value) == null) {
          throw 'Numeric';
        }
        return value;
      },
      errorMessage: message ?? 'Please enter a valid number',
    );
  }

  static ValidationRule custom({
    required bool Function(String) condition,
    required String message,
  }) {
    return ValidationRule(
      validator: (value) {
        if (!condition(value)) {
          throw 'Custom';
        }
        return value;
      },
      errorMessage: message,
    );
  }
}
