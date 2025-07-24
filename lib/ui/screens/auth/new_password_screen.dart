import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class NewPasswordScreen extends ConsumerStatefulWidget {
  const NewPasswordScreen({super.key, required this.args});

  final ForgotArg args;

  @override
  ConsumerState<NewPasswordScreen> createState() =>
      _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends ConsumerState<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordC = TextEditingController();
  final _confirmPasswordC = TextEditingController();

  @override
  void dispose() {
    _confirmPasswordC.dispose();
    _passwordC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
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
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(AppSvgs.circleBack),
                          ),
                        ),
                        YBox(20),
                        Text(
                          "Create Password",
                          style: textTheme.text20?.medium,
                        ),
                        YBox(30),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: _passwordC,
                                isRequired: true,
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                bottomHintText:
                                    "Must be at least 8 characters.",
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
                              YBox(20),
                              CustomTextField(
                                controller: _confirmPasswordC,
                                isRequired: true,
                                labelText: 'Confirm Password',
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
                          text: "Create Password",
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState?.validate() ?? false) {
                              _submit();
                            }
                          },
                        ),
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

  _submit() async {
    final r = await ref.read(authVmodel).recoverPassword(
            forgotArg: ForgotArg(
          token: widget.args.token,
          password: _passwordC.text.trim(),
          confirmPassword: _confirmPasswordC.text.trim(),
          code: widget.args.code,
          entity: widget.args.entity,
        ));

    handleApiResponse(
      response: r,
      onSuccess: () {
        ModalWrapper.bottomSheet(
          context: context,
          canDismiss: false,
          widget: ConfirmationModal(
            modalConfirmationArg: ModalConfirmationArg(
              iconPath: AppSvgs.checkIcon,
              title: "Password Successfully Changed",
              description: r.data['message'],
              solidBtnText: "Log in",
              onSolidBtnOnTap: () {
                final ctx = NavKey.appNavKey.currentContext!;
                Navigator.pop(ctx);
                Navigator.pushNamedAndRemoveUntil(
                  ctx,
                  RoutePath.loginScreen,
                  (r) => false,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
