import 'package:builders_konnect/core/core.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static String nairaSymbol = "₦";
  static String dollarSymbol = "\$";
  static String maskEmail(String email, {int consoreLevel = 2}) {
    final parts = email.split("@");

    if (parts.length != 2) {
      printty("Invalid email: $email");
      return email;
    }

    final emailcaracter = email.replaceRange(
        consoreLevel, parts[0].length, "*" * (parts[0].length - 2));

    return emailcaracter;
  }

  //e.g 23rd March, 2021
  static String dayWithSuffixMonthAndYear(DateTime date) {
    var suffix = "th";
    //var suffix = "";
    var digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    return DateFormat("d'$suffix' MMM, y").format(date);
  }

  //e.g 23rd March, 2021 4:40PM
  static String d(DateTime date) {
    var suffix = "th";
    var digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    String dd = DateFormat("d'$suffix' MMM, y").format(date);
    String tt = DateFormat.jm().format(date);

    return "$dd $tt";
  }

  // 4:40PM
  static String convertDateTime(DateTime date) {
    // Parse the input date-time string
    String tt = DateFormat.jm().format(date);
    // return DateFormat('yyyy-MM-dd').format(dateTime);
    return tt;
  }

  // returns String of dayWithSuffixMonthAndYear formated value in YYYY-MM-DD format
  static String convertDateString(String dateString) {
    final temp = dateString
        .replaceAll('th', '')
        .replaceAll('st', '')
        .replaceAll('nd', '')
        .replaceAll('rd', '');
    DateTime date = DateFormat('d MMM, yyyy').parse(temp);
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// A utility function to format numbers in different ways
  ///
  /// Parameters:
  /// - [number]: The number to format
  /// - [decimalPlaces]: Number of decimal places to display (defaults to 2)
  /// - [thousandSeparator]: Character to use as thousand separator (defaults to comma)
  /// - [decimalSeparator]: Character to use as decimal separator (defaults to period)
  /// - [prefix]: Optional prefix to add before the number (e.g., '$')
  /// - [suffix]: Optional suffix to add after the number (e.g., '%')
  /// - [compactFormat]: Whether to use compact notation (e.g., 1K, 1M)
  static String formatNumber({
    required num number,
    int decimalPlaces = 0,
    String thousandSeparator = ',',
    String decimalSeparator = '.',
    String prefix = '',
    String suffix = '',
    bool compactFormat = false,
  }) {
    // Create the number formatter with the locale that uses our custom separators
    final formatter = NumberFormat.currency(
      locale: 'en_US', // Start with a base locale
      symbol: '', // No currency symbol
      decimalDigits: decimalPlaces,
    );

    String formattedNumber;

    if (compactFormat) {
      // For compact format, we'll use the built-in compact formatter
      // and then handle the separators in post-processing
      final compactFormatter = NumberFormat.compact();
      formattedNumber = compactFormatter.format(number);
    } else {
      // For regular formatting
      formattedNumber = formatter.format(number);
    }

    // Replace the default separators with our custom ones
    // The en_US locale uses ',' as GROUP_SEP and '.' as DECIMAL_SEP
    formattedNumber = formattedNumber
        .replaceAll(',', '_TEMP_') // Temporary replacement to avoid conflicts
        .replaceAll('.', decimalSeparator)
        .replaceAll('_TEMP_', thousandSeparator);

    // Add prefix and suffix
    return '$prefix$formattedNumber$suffix';
  }

  /// Returns initials based on first and last name with the following rules:
  /// - If both firstname and lastname are provided, returns first letter of each
  /// - If only firstname is provided, returns first two letters of firstname
  /// - If both are null or empty, returns "BK"
  static String getInitials({String? firstName, String? lastName}) {
    // Case 1: Both first name and last name are null or empty
    if ((firstName == null || firstName.isEmpty) &&
        (lastName == null || lastName.isEmpty)) {
      return "BK";
    }

    // Case 2: Last name is null or empty, but first name exists
    if (lastName == null || lastName.isEmpty) {
      if (firstName!.length >= 2) {
        // Get first two letters of first name
        return firstName.substring(0, 2).toUpperCase();
      } else {
        // If first name is only one character, use it and add "BK"
        return "${firstName.toUpperCase()}B";
      }
    }

    // Case 3: Both first name and last name exist
    // Get first letter of first name and first letter of last name
    String firstInitial = firstName != null && firstName.isNotEmpty
        ? firstName[0].toUpperCase()
        : "";
    String lastInitial = lastName[0].toUpperCase();

    return firstInitial + lastInitial;
  }

  launchPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        _showErrorMessage('Unable to open phone dialer');
      }
    } catch (e) {
      printty('Error launching phone: $e');
      _showErrorMessage('Unable to open phone dialer');
    }
  }

  /// Launch email app with pre-filled recipient
  Future<void> launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=${Uri.encodeComponent('Support Request')}',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        _showErrorMessage('Unable to open email app');
      }
    } catch (e) {
      printty('Error launching email: $e');
      _showErrorMessage('Unable to open email app');
    }
  }

  /// Launch WhatsApp with pre-filled number
  Future<void> launchWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse(
      'https://wa.me/$phoneNumber?text=${Uri.encodeComponent('Hello! I need assistance with my order.')}',
    );

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(
          whatsappUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showErrorMessage('WhatsApp is not installed on this device');
      }
    } catch (e) {
      printty('Error launching WhatsApp: $e');
      _showErrorMessage('Unable to open WhatsApp');
    }
  }

  /// Show error message to user
  void _showErrorMessage(String message) {
    FlushBarToast.fLSnackBar(
      snackBarType: SnackBarType.warning,
      message: message,
    );
  }
}
