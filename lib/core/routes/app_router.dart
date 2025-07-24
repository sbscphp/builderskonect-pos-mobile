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

      case RoutePath.forgotPasswordScreen:
        return TransitionUtils.buildTransition(
          const ForgotPasswordScreen(),
          settings,
        );

      case RoutePath.otpScreen:
        return TransitionUtils.buildTransition(
          const OtpScreen(),
          settings,
        );

      case RoutePath.vendorRegistrationScreen:
        if (args is String) {
          return TransitionUtils.buildTransition(
            VendorRegistrationScreen(reference: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.createPasswordScreen:
        return TransitionUtils.buildTransition(
          const CreatePasswordScreen(),
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
        if (args is PlanFeatureArg) {
          return TransitionUtils.buildTransition(
            GetStartedScreen(arg: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.planLearnMoreScreen:
        if (args is PlanFeatureArg) {
          return TransitionUtils.buildTransition(
            PlanLearnMoreScreen(arg: args),
            settings,
          );
        }
        return errorScreen(settings);

      case RoutePath.subscriptionSuccessScreen:
        if (args is SubscriptionSuccessArg) {
          return TransitionUtils.buildTransition(
            SubscriptionSuccessScreen(arg: args),
            settings,
          );
        }
        return errorScreen(settings);

      // POS
      case RoutePath.moreScreen:
        return TransitionUtils.buildTransition(
          const MoreScreen(),
          settings,
        );

      // Webview
      case RoutePath.customWebviewScreen:
        if (args is WebViewArg) {
          return TransitionUtils.buildTransition(
            CustomWebviewScreen(arg: args),
            settings,
          );
        }
        return errorScreen(settings);

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
