import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
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
      show: ref.watch(authVModel).isBusy,
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
                          text: "Verify",
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            // Navigator.pushNamed(context, RoutePath.newPasswordScreen);
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
}
