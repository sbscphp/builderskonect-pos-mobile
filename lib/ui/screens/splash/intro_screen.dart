import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        height: Sizer.screenHeight,
        width: Sizer.screenWidth,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.signupBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: Sizer.width(16),
            right: Sizer.width(16),
            bottom: Sizer.height(40),
          ),
          child: Column(
            children: [
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: Sizer.height(24),
                  horizontal: Sizer.width(24),
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(Sizer.radius(8)),
                ),
                child: Column(
                  children: [
                    Image.asset(
                      AppImages.logo,
                      height: Sizer.height(48),
                    ),
                    YBox(30),
                    Text(
                      "Welcome to Builder’s Konnect",
                      style: textTheme.text20?.medium,
                    ),
                    Text(
                      "Manage your building materials and construction business from anywhere with ease.",
                      textAlign: TextAlign.center,
                      style: textTheme.text12
                          ?.copyWith(color: colorScheme.black45),
                    ),
                    YBox(30),
                    CustomBtn.solid(
                      text: "Get Started",
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          RoutePath.pricingPlansScreen,
                        );
                      },
                    ),
                    YBox(24),
                    CustomBtn.solid(
                      text: "Log in",
                      isOutline: true,
                      outlineColor: AppColors.neutral5,
                      textStyle: textTheme.text16,
                      onTap: () {
                        printty("Login");
                        Navigator.of(context).pushNamed(RoutePath.loginScreen);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
