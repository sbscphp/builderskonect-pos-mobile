import 'package:builders_konnect/core/core.dart';

class PasswordSuffixWidget extends StatelessWidget {
  final bool showPassword;
  const PasswordSuffixWidget({super.key, required this.showPassword});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Sizer.height(48),
      height: Sizer.height(26),
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: Sizer.height(11),
        bottom: Sizer.height(11),
      ),
      decoration: BoxDecoration(
        // color: AppColors.black,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: showPassword
          ? const Icon(
              Iconsax.eye_slash,
              size: 16,
              color: AppColors.black,
            )
          : const Icon(
              Iconsax.eye,
              size: 16,
              color: AppColors.black,
            ),
    );
  }
}
