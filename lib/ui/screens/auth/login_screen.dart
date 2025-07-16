import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final CustomFormController _formController = CustomFormController();

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formController.validateAllFields()) {
      // Get all field values
      final values = _formController.getFieldValues();
      printty('Email: ${values['email']}');
      printty('Password: ${values['password']}');

      // Proceed with login
      _performLogin();
    }
  }

  void _performLogin() {
    // Your login logic here
    printty('Logging in...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        "Log in to Builder’sKonnect",
                        style: AppTypography.text20.medium,
                      ),
                      YBox(30),
                      CustomTextField(
                        fieldId: 'email',
                        fieldType: FieldType.email,
                        isRequired: true,
                        formController: _formController,
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        showLabelHeader: true,
                      ),
                      YBox(20),
                      CustomTextField(
                        fieldId: 'password',
                        fieldType: FieldType.password,
                        isRequired: true,
                        formController: _formController,
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        isPassword: true,
                        showLabelHeader: true,
                      ),
                      YBox(30),
                      CustomBtn.solid(
                        text: "Log in",
                        onTap: () {
                          // _onLoginPressed();
                          Navigator.pushNamed(
                              context, RoutePath.vendorRegistrationScreen);
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
    );
  }
}
