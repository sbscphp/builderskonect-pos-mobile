import 'package:builders_konnect/core/core.dart';

class ProductColText extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final Color? textColor;
  final double? valueTextSize;

  const ProductColText({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.textColor,
    this.valueTextSize,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.text12?.copyWith(
            fontWeight: textColor == null ? FontWeight.w500 : FontWeight.w400,
            color: textColor ?? colorScheme.black45,
          ),
        ),
        YBox(4),
        Text(
          value,
          style: textTheme.text20?.medium.copyWith(
            fontSize: valueTextSize,
            color: valueColor ?? colorScheme.primaryColor,
          ),
        ),
      ],
    );
  }
}
