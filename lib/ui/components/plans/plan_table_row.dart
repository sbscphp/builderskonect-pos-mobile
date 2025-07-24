import 'package:builders_konnect/core/core.dart';

class PlanTableRow extends StatelessWidget {
  const PlanTableRow({
    super.key,
    required this.keyText,
    this.value,
  });

  final String keyText;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: Sizer.height(25),
              horizontal: Sizer.height(16),
            ),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                    color: AppColors.black.withValues(alpha: 0.06), width: 2),
              ),
            ),
            child: Text(
              keyText,
              style: textTheme.text14,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Center(
            child: 1 + 1 == 2
                ? Icon(
                    Icons.check_box,
                    color: AppColors.green7,
                  )
                : Text(
                    "Unlimited",
                    style: textTheme.text14?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
          ),
        )
      ],
    );
  }
}
