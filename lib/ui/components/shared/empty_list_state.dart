import 'package:builders_konnect/core/core.dart';

class EmptyListState extends StatelessWidget {
  const EmptyListState({
    super.key,
    required this.text,
    this.height,
  });

  final String text;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: Sizer.height(height ?? 500),
      width: Sizer.screenWidth,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textTheme.text16?.copyWith(
            color: AppColors.black,
          ),
        ),
      ),
    );
  }
}
