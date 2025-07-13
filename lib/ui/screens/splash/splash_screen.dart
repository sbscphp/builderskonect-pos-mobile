import 'package:builders_konnect/core/core.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainAnimationController;
  late AnimationController _loadingAnimationController;

  late Animation<double> _logoFadeAnimation;
  late Animation<Offset> _logoDropAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});

    _initializeAnimations();
    _startAnimationSequence();

    Future.delayed(const Duration(seconds: 4), () async {
      // final userLoaded = await authRef.loadUserFromStorage();
      // final hasSeenOnboarding = await StorageService.getBoolItem(
      //       StorageKey.hasSeenOnboarding,
      //     ) ??
      //     false;
      // final nextPage = userLoaded
      //     ? RoutePath.bottomNavScreen
      //     // : hasSeenOnboarding
      //     //     ? RoutePath.bottomNavScreen
      //     : RoutePath.onboardingScreen;

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(RoutePath.bottomNavScreen);
      }
    });
  }

  void _initializeAnimations() {
    // Main animation controller for logo drop and text
    _mainAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    // Loading animation controller
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Logo drop animation - starts from above screen and settles below center
    _logoDropAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5), // Start above screen
      end:
          const Offset(0, 0.4), // End slightly below center for settling effect
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.bounceOut),
    ));

    // Logo fade animation - fades in as it drops
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
    ));
  }

  void _startAnimationSequence() {
    _mainAnimationController.forward();

    // Start loading animation after logo settles
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _loadingAnimationController.repeat();
      }
    });
  }

  @override
  void dispose() {
    _mainAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _logoFadeAnimation,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo with drop-and-bounce animation
                      SlideTransition(
                        position: _logoDropAnimation,
                        child: Image.asset(
                          AppImages.logo,
                          height: Sizer.height(66),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
