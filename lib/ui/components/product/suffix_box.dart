import 'package:builders_konnect/core/core.dart';

class SuffixBox extends StatelessWidget {
  const SuffixBox({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizer.radius(10)),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.neutral5,
          ),
        ),
      ),
      child: Text(text.isEmpty ? "-" : text),
    );
  }
}
