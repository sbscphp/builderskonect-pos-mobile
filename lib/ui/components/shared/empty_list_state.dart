import 'package:builders_konnect/core/core.dart';

class EmptyListState extends StatelessWidget {
  const EmptyListState({
    super.key,
    required this.text,
    this.imageHeight,
    this.fontSize,
  });

  final String text;
  final double? fontSize;
  final double? imageHeight;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImages.empty,
            height: Sizer.height(imageHeight ?? 130),
          ),
          YBox(10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: textTheme.text16?.copyWith(
              fontSize: fontSize,
              color: colorScheme.black85,
            ),
          ),
        ],
      ),
    );
  }
}
