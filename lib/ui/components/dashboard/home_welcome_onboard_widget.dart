import 'package:builders_konnect/core/core.dart';

class HomeWelcomeOnboardWidget extends StatelessWidget {
  const HomeWelcomeOnboardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
        vertical: Sizer.height(14),
      ),
      width: Sizer.screenWidth,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImages.banner),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Onboard!",
            style: textTheme.text16?.medium.copyWith(
              color: colorScheme.white,
            ),
          ),
          YBox(4),
          Text(
            "Complete your business profile by uploading your business logo",
            style: textTheme.text12?.copyWith(
              color: colorScheme.white,
            ),
          ),
          YBox(10),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutePath.bottomNavScreen,
                  arguments: DashArg(index: 3));
            },
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizer.width(8),
                    vertical: Sizer.height(4),
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.white,
                    borderRadius: BorderRadius.circular(Sizer.radius(4)),
                  ),
                  child: Text(
                    "Upload Logo",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
