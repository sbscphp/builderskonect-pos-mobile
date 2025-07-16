import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/screens/screens.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case RoutePath.splashScreen:
        return TransitionUtils.buildTransition(
          const SplashScreen(),
          settings,
        );

      case RoutePath.introScreen:
        return TransitionUtils.buildTransition(
          const IntroScreen(),
          settings,
        );

      case RoutePath.bottomNavScreen:
        final dashArgs = args as DashArg?;
        return TransitionUtils.buildTransition(
          BottomNavScreen(args: dashArgs),
          settings,
        );

      // Auth
      case RoutePath.loginScreen:
        return TransitionUtils.buildTransition(
          const LoginScreen(),
          settings,
        );

      case RoutePath.vendorRegistrationScreen:
        return TransitionUtils.buildTransition(
          const VendorRegistrationScreen(),
          settings,
        );

      // Notification
      case RoutePath.notificationScreen:
        return TransitionUtils.buildTransition(
          const NotificationScreen(),
          settings,
        );

      // Plans
      case RoutePath.pricingPlansScreen:
        return TransitionUtils.buildTransition(
          const PricingPlansScreen(),
          settings,
        );

      case RoutePath.getStartedScreen:
        return TransitionUtils.buildTransition(
          const GetStartedScreen(),
          settings,
        );

      default:
        return errorScreen(settings);
    }
  }

  static errorScreen(RouteSettings settings) {
    return TransitionUtils.buildTransition(
      ScreenNotFound(routeName: settings.name),
      settings,
    );
  }
}
