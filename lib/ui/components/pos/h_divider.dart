import 'package:builders_konnect/core/core.dart';

class HDivider extends StatelessWidget {
  const HDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Sizer.height(16)),
      child: Divider(color: AppColors.neutral4, height: 1),
    );
  }
}
