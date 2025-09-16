import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProfileTopWidget extends StatelessWidget {
  const ProfileTopWidget({
    super.key,
    required this.avatarUrl,
    required this.storeName,
    required this.email,
    required this.phone,
  });

  final String avatarUrl;
  final String storeName;
  final String email;
  final String phone;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
        vertical: Sizer.height(16),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizer.radius(4)),
        color: colorScheme.white,
      ),
      child: Row(
        children: [
          CustomCircleAvatar(
            size: 60,
            avatarUrl: avatarUrl,
          ),
          XBox(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName,
                  style: textTheme.text16?.medium,
                ),
                YBox(2),
                Row(
                  children: [
                    SvgPicture.asset(AppSvgs.mail),
                    XBox(8),
                    Expanded(
                      child: Text(
                        email,
                        maxLines: 1,
                        style: textTheme.text16?.copyWith(
                          color: AppColors.neutral9,
                        ),
                      ),
                    ),
                  ],
                ),
                YBox(2),
                Row(
                  children: [
                    SvgPicture.asset(AppSvgs.phone),
                    XBox(8),
                    Text(
                      phone,
                      style: textTheme.text16?.copyWith(
                        color: AppColors.neutral9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
