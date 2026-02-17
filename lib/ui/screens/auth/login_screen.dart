import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'olutan@yopmail.com');
  final _passwordController = TextEditingController(text: 'password1');
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();

  late AnimationController _customController;
  late Animation<double> _customAnimation;

  @override
  void initState() {
    super.initState();
    _customController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _customAnimation = CurvedAnimation(
      parent: _customController,
      curve: Curves.easeInOut,
    );

    // Start form animation after a delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _customController.forward();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BusyOverlay(
      show: ref.watch(authVmodel).isBusy,
      child: Scaffold(
        body: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: Sizer.screenHeight,
            width: Sizer.screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.signupBg),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              // mainAxisAlignment: MainAxisAlignment.center,
              child:
                  // Container(
                  //   height: Sizer.height(60),
                  // ),
                  SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizer.width(16),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    // padding: EdgeInsets.zero,
                    children: [
                      YBox(16),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                }
                              },
                              child: SvgPicture.asset(AppSvgs.circleBack),
                            ),
                          ),
                          YBox(24.h),
                          Text(
                            "Log in to Builder’sKonnect",
                            style: textTheme.text20?.medium,
                          ),
                          YBox(4),
                          Text.rich(
                            TextSpan(
                                text: "Don’t have an account? ",
                                style: textTheme.text16?.copyWith(
                                  color: colorScheme.black45,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Become a vendor",
                                    style: textTheme.text16?.copyWith(
                                        color: colorScheme.primaryColor,
                                        fontWeight: FontWeight.w500),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context).pushNamed(
                                          RoutePath.pricingPlansScreen,
                                        );
                                      },
                                  )
                                ]),
                            textAlign: TextAlign.center,
                          ),
                          YBox(30),
                          Form(
                            key: _formKey,
                            child: FadeTransition(
                              opacity: _customAnimation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.2),
                                  end: const Offset(0, 0),
                                ).animate(_customAnimation),
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      controller: _emailController,
                                      isRequired: true,
                                      labelText: 'Email',
                                      hintText: 'Enter email address',
                                      showLabelHeader: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                    ),
                                    YBox(20),
                                    CustomTextField(
                                      controller: _passwordController,
                                      isRequired: true,
                                      labelText: 'Password',
                                      hintText: 'Enter password',
                                      isPassword: true,
                                      showLabelHeader: true,
                                      validator: (p0) {
                                        if (p0 == null || p0.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                    ),
                                    YBox(30),
                                    CustomBtn.solid(
                                      text: "Log in",
                                      onTap: () async {
                                        FocusScope.of(context).unfocus();
                                        if (_formKey.currentState?.validate() ??
                                            false) {
                                          final res =
                                              await ref.read(authVmodel).login(
                                                    identifier: _emailController
                                                        .text
                                                        .trim(),
                                                    password:
                                                        _passwordController.text
                                                            .trim(),
                                                  );

                                          handleApiResponse(
                                            response: res,
                                            useBrandSuccessSnack: false,
                                            onSuccess: () {
                                              Navigator.pushNamed(context,
                                                  RoutePath.bottomNavScreen);
                                              // Navigator.pushNamed(context,
                                              //     RoutePath.selectModuleScreen);
                                            },
                                          );
                                        }
                                      },
                                    ),
                                    YBox(26),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushNamed(
                                          RoutePath.forgotPasswordScreen,
                                        );
                                      },
                                      child: Text(
                                        "Forgot Password?",
                                        style: textTheme.text16?.copyWith(
                                          color: colorScheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                    YBox(26),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              // Container(
              //   height: Sizer.height(60),
              // ),
              // ],
            ),
          ),
        ),
      ),
    );
  }
}
