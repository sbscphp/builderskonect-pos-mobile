import 'package:builders_konnect/core/core.dart';

class CustomCircleAvatar extends StatelessWidget {
  const CustomCircleAvatar({
    super.key,
    this.avatarUrl,
    this.size = 40,
    this.onTap,
  });

  final String? avatarUrl;
  final double size;
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
            border: Border.all(
              color: AppColors.primaryBlue,
              width: 2,
            )),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizer.radius(40)),
          child: (avatarUrl != null && avatarUrl != "")
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
