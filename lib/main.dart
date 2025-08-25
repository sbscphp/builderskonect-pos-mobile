import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/screens/screens.dart';
import 'package:flutter/services.dart';
// {name: Daniel Don, email: danny@mailinator.com, phone: 08011111111, company: Lego Blocks, provider: paystack, free_trial: false, callback_url: https://merchant.builderskonnect.sbscuk.co.uk/auth/register-vendor, price_item_id: spi_R6sdw7DCvY2Wxo31M3T3A}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitService().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (context, child) {
        return Consumer(builder: (context, ref, child) {
          final themeVm = ref.watch(themeViewModel);
          final themeMode = themeVm.themeMode;

          return MaterialApp(
            title: 'Builder Konnect',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,

            // System UI overlay style
            builder: (context, child) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: themeMode == ThemeMode.dark
                    ? SystemUiOverlayStyle.light
                    : SystemUiOverlayStyle.dark,
                child: child!,
              );
            },
            navigatorKey: NavKey.appNavKey,
            onGenerateRoute: AppRouter.onGenerateRoute,
            home: const SplashScreen(),
          );
        });
      },
    );
  }
}
