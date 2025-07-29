// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "Change Password",
        ),
        body: ListView(
          padding: EdgeInsets.only(
            left: Sizer.width(16),
            right: Sizer.width(16),
            bottom: Sizer.height(50),
          ),
          children: [
            YBox(16),
            Container(
              padding: EdgeInsets.all(Sizer.radius(16)),
              decoration: BoxDecoration(
                color: colorScheme.white,
                borderRadius: BorderRadius.circular(Sizer.radius(4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Change Password", style: textTheme.text16?.medium),
                  Text(
                    "Enter your old password to change password.",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    isRequired: false,
                    labelText: 'Old Password',
                    hintText: 'Enter old password',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    isRequired: false,
                    labelText: 'New Password',
                    hintText: 'Enter new password',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    isRequired: false,
                    labelText: 'Confirm Password',
                    hintText: 'Enter confirm password',
                    showLabelHeader: true,
                  ),
                  YBox(20),
                  CustomBtn.solid(
                    text: "Update",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
