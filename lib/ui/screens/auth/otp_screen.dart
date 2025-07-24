import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key, required this.args});

  final ForgotArg args;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpC = TextEditingController();
  final _otpF = FocusNode();

  @override
  void dispose() {
    _otpC.dispose();
    _otpF.dispose();
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
                          "OTP Verification",
                          style: textTheme.text20?.medium,
                        ),
                        YBox(4),
                        Text(
                          "Enter the code sent to your email",
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
                                controller: _otpC,
                                focusNode: _otpF,
                                isRequired: true,
                                labelText: 'OTP Code',
                                hintText: 'Enter code',
                                showLabelHeader: true,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                validator: Validators.passcode(length: 6),
                              ),
                            ],
                          ),
                        ),
                        YBox(24),
                        ResendCode(
                          onResendCode: () async {
                            await ref.read(authVmodel).resetPassword(
                                identifier: widget.args.email ?? '');
                          },
                        ),
                        YBox(32),
                        CustomBtn.solid(
                          text: "Verify",
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              _submitForm();
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
    );
  }

  _submitForm() {
    Navigator.pushNamed(context, RoutePath.newPasswordScreen,
        arguments: widget.args.copyWith(
          code: () => _otpC.text,
        ));
  }
}
