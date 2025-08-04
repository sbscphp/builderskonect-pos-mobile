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
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordC = TextEditingController();
  final _newPasswordC = TextEditingController();
  final _confirmPasswordC = TextEditingController();

  @override
  void dispose() {
    _oldPasswordC.dispose();
    _newPasswordC.dispose();
    _confirmPasswordC.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final profileVm = ref.watch(profileVmodel);
    return BusyOverlay(
      show: profileVm.isBusy,
      child: Scaffold(
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
                child: Form(
                  key: _formKey,
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
                        controller: _oldPasswordC,
                        isRequired: false,
                        labelText: 'Old Password',
                        hintText: 'Enter old password',
                        showLabelHeader: true,
                        isPassword: true,
                        validator: Validators.required(),
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: _newPasswordC,
                        isRequired: false,
                        labelText: 'New Password',
                        hintText: 'Enter new password',
                        showLabelHeader: true,
                        isPassword: true,
                        validator: Validators.required(),
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: _confirmPasswordC,
                        isRequired: false,
                        labelText: 'Confirm Password',
                        hintText: 'Enter confirm password',
                        showLabelHeader: true,
                        isPassword: true,
                        validator: Validators.passwordConfirmation(
                          getPasswordValue: () => _newPasswordC.text,
                        ),
                      ),
                      YBox(20),
                      CustomBtn.solid(
                        text: "Update",
                        onTap: () async {
                          FocusScope.of(context).unfocus();
                          if (_formKey.currentState!.validate()) {
                            final res = await profileVm.updateProfile(
                              currentPassword: _oldPasswordC.text,
                              password: _newPasswordC.text,
                              passwordConfirm: _confirmPasswordC.text,
                            );

                            handleApiResponse(
                              response: res,
                              showSuccessToast: false,
                              onSuccess: () {
                                Navigator.pop(context);
                                ModalWrapper.bottomSheet(
                                  context: context,
                                  // canDismiss: false,
                                  widget: ConfirmationModal(
                                    modalConfirmationArg: ModalConfirmationArg(
                                      iconPath: AppSvgs.checkIcon,
                                      title: "Password Changed Successfully",
                                      description:
                                          "Your password has been changed successfully.",
                                      solidBtnText: "Back to Settings",
                                      onSolidBtnOnTap: () {
                                        final ctx =
                                            NavKey.appNavKey.currentContext!;

                                        Navigator.pop(ctx);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
