import 'package:builders_konnect/core/core.dart';

class PlansRowText extends StatelessWidget {
  const PlansRowText({
    super.key,
    required this.keyText,
    required this.valueText,
    this.keyTextStyle,
    this.valueTextStyle,
  });

  final String keyText;
  final String valueText;

  final TextStyle? keyTextStyle;
  final TextStyle? valueTextStyle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Text(
          keyText,
          style: keyTextStyle ??
              textTheme.text14?.copyWith(
                color: colorScheme.black45,
              ),
        ),
        Spacer(),
        Text(
          valueText,
          style: valueTextStyle ??
              textTheme.text14?.medium.copyWith(
                color: colorScheme.black85,
              ),
        ),
      ],
    );
  }
}
