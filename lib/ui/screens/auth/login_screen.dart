import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'olutan@yopmail.com');
  // final _emailController = TextEditingController(text: 'totaa@yopmail.com');
  // final _emailController =
  //     TextEditingController(text: ' bunyanman@yopmail.com');
  final _passwordController = TextEditingController(text: "password1");

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
        body: Container(
          height: Sizer.screenHeight,
          width: Sizer.screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImages.signupBg),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                YBox(10),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Sizer.height(16),
                      horizontal: Sizer.width(16),
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(Sizer.radius(8)),
                    ),
                    child: Column(
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
                        YBox(20),
                        Text(
                          "Log in to Builder’s Konnect",
                          style: textTheme.text20?.medium,
                        ),
                        YBox(30),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _emailController,
                                isRequired: true,
                                labelText: 'Email',
                                hintText: 'Enter your email',
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
                                hintText: 'Enter your password',
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
                            ],
                          ),
                        ),
                        YBox(30),
                        CustomBtn.solid(
                          text: "Log in",
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState?.validate() ?? false) {
                              final res = await ref.read(authVmodel).login(
                                    identifier: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                  );

                              handleApiResponse(
                                response: res,
                                onSuccess: () {
                                  Navigator.pushNamed(
                                      context, RoutePath.selectModuleScreen);
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
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
