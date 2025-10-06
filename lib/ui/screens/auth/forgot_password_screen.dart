import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
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
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(Sizer.radius(4)),
                          topRight: Radius.circular(Sizer.radius(4)),
                        ),
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(AppSvgs.circleBack),
                            ),
                          ),
                          YBox(20),
                          Text(
                            "Forgot Password",
                            style: textTheme.text20?.medium,
                          ),
                          YBox(4),
                          Text(
                            "Enter your email/phone number to reset password",
                            style: textTheme.text14?.copyWith(
                              color: AppColors.neutral8,
                            ),
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
                              ],
                            ),
                          ),
                          YBox(30),
                          CustomBtn.solid(
                            text: "Reset Password",
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                _submit();
                              }
                            },
                          ),
                          YBox(26),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _submit() async {
    final r = await ref
        .read(authVmodel)
        .resetPassword(identifier: _emailController.text.trim());

    handleApiResponse(
      response: r,
      onSuccess: () {
        Navigator.pushNamed(
          context,
          RoutePath.otpScreen,
          arguments: ForgotArg(
            token: r.data,
            entity: "merchant",
            email: _emailController.text.trim(),
          ),
        );
      },
    );
  }
}
