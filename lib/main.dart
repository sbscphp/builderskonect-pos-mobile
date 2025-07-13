import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/screens/screens.dart';

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

          // Update the status bar dynamically
          AppTheme.updateStatusBarBrightness(themeMode: themeMode);
          return MaterialApp(
            title: 'Builder Konnect',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            navigatorKey: NavKey.appNavKey,
            onGenerateRoute: AppRouter.onGenerateRoute,
            home: const SplashScreen(),
          );
        });
      },
    );
  }
}
