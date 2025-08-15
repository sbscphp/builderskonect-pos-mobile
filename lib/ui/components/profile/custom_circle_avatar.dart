import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    this.avatarUrl,
    this.showBorder = true,
    this.size = 40,
    this.isLoading = false,
    this.onTap,
  });

  final String? avatarUrl;
  final bool? showBorder;
  final double size;
  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: Sizer.height(size),
        width: Sizer.width(size),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizer.radius(40)),
            border: (showBorder == true || isLoading)
                ? Border.all(
                    color: AppColors.primaryBlue,
                    width: 2,
                  )
                : null),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizer.radius(40)),
          child: isLoading
              ? const SpinKitLoader(
                  color: AppColors.neutral5,
                  size: 30,
                )
              : (avatarUrl != null && avatarUrl != "")
                  ? MyCachedNetworkImage(
                      imageUrl: avatarUrl,
                      fit: BoxFit.cover,
                    )
                  : Icon(
                      Iconsax.user,
                      size: Sizer.width(size / 2),
                    ),
        ),
      ),
    );
  }
}
