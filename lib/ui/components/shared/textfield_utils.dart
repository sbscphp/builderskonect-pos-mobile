import 'package:builders_konnect/core/core.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/services.dart';

TextInputType inputType(KeyboardType textInputType) {
  if (textInputType == KeyboardType.email) {
    return TextInputType.emailAddress;
  }
  if (textInputType == KeyboardType.decimal) {
    return const TextInputType.numberWithOptions(decimal: true);
  }
  if (textInputType == KeyboardType.number ||
      textInputType == KeyboardType.phone ||
      textInputType == KeyboardType.bvn ||
      textInputType == KeyboardType.accountNo ||
      textInputType == KeyboardType.passcode ||
      textInputType == KeyboardType.decimal) {
    return TextInputType.number;
  }
  return TextInputType.visiblePassword;
}

List<TextInputFormatter> inputFormatter(KeyboardType textInputType,
    {int? fieldLength}) {
  if (fieldLength != null) {
    return <TextInputFormatter>[
      LengthLimitingTextInputFormatter(fieldLength),
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ];
  }
  if (textInputType == KeyboardType.decimal) {
    return [
      CurrencyTextInputFormatter.currency(
        locale: 'en_US',
        decimalDigits: 0,
        symbol: ' ',
      ),
      FilteringTextInputFormatter.allow(
          RegExp(r"^(?!0+\.0+$)\d{1,3}(?:,\d{3}|\d)*(?:\.\d{2})?$"))
    ];
  }
  if (textInputType == KeyboardType.number) {
    return <TextInputFormatter>[
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ];
  }
  if (textInputType == KeyboardType.accountNo) {
    return <TextInputFormatter>[
      LengthLimitingTextInputFormatter(10),
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ];
  }
  if (textInputType == KeyboardType.phone ||
      textInputType == KeyboardType.bvn) {
    return <TextInputFormatter>[
      LengthLimitingTextInputFormatter(11),
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ];
  }

  if (textInputType == KeyboardType.otp) {
    return <TextInputFormatter>[
      LengthLimitingTextInputFormatter(6),
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ];
  }
  if (textInputType == KeyboardType.passcode) {
    return <TextInputFormatter>[
      LengthLimitingTextInputFormatter(4),
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    ];
  }
  return <TextInputFormatter>[];
}

KeyboardType getKeyBoardType(String type) {
  if (type.toLowerCase() == "decimal") {
    return KeyboardType.decimal;
  }
  if (type.toLowerCase() == "number") {
    return KeyboardType.number;
  }
  if (type.toLowerCase() == "string") {
    return KeyboardType.regular;
  }

  return KeyboardType.regular;
}
