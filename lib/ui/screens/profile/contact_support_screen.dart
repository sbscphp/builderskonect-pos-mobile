// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class ContactSupportScreen extends ConsumerStatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  ConsumerState<ContactSupportScreen> createState() =>
      _ContactSupportScreenState();
}

class _ContactSupportScreenState extends ConsumerState<ContactSupportScreen> {
  final formKey = GlobalKey<FormState>();
  final subjectC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final messageC = TextEditingController();

  File? _docFile;
  String? _docUrl;

  _clearData() {
    subjectC.clear();
    phoneC.clear();
    emailC.clear();
    messageC.clear();
    _docFile = null;
    _docUrl = null;
  }

  @override
  void dispose() {
    subjectC.dispose();
    phoneC.dispose();
    emailC.dispose();
    messageC.dispose();
    formKey.currentState?.dispose();
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
            title: "Contact Support",
          ),
          body: Form(
            key: formKey,
            child: ListView(
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
                      Text("Support Form", style: textTheme.text16?.medium),
                      Text(
                        "Fill the form below to reach out to Buikder’sKonnect support team",
                        style: textTheme.text12?.copyWith(
                          color: colorScheme.black45,
                        ),
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: subjectC,
                        labelText: 'Subject',
                        hintText: 'Enter subject',
                        showLabelHeader: true,
                        validator: Validators.required(),
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: emailC,
                        labelText: 'Email',
                        hintText: 'Enter email',
                        showLabelHeader: true,
                        validator: Validators.email(),
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: phoneC,
                        labelText: 'Phone',
                        hintText: 'Enter phone',
                        showLabelHeader: true,
                        validator: Validators.required(),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                      ),
                      YBox(16),
                      CustomTextField(
                        controller: messageC,
                        labelText: 'Message',
                        hintText: 'Enter message',
                        showLabelHeader: true,
                        maxLines: 4,
                        validator: Validators.required(),
                      ),
                      YBox(16),
                      UploadWidget(
                        documentName: _docFile?.path.split('/').last,
                        labelText: "Supporting Document",
                        uploadText: "Click to upload",
                        buttomTextDesc: "JPEG, PDF, DOC.  Not more than 2MB",
                        onUpload: () async {
                          // Reset progress tracking for any previous uploads
                          ref.read(fileUploadVm).resetProgress();

                          final file = await ImageAndDocUtils.pickDocument();
                          if (file != null) {
                            _docFile = file;
                            final r = await ref
                                .read(fileUploadVm)
                                .uploadFile(file: [file]);
                            _docUrl = r.data?.first.url;
                          }
                        },
                      ),
                      YBox(30),
                      CustomBtn.solid(
                        text: "Submit",
                        onTap: () async {
                          if (formKey.currentState?.validate() ?? false) {
                            final r =
                                await ref.read(profileVmodel).contactSupport(
                                      name: subjectC.text,
                                      email: emailC.text,
                                      phone: phoneC.text,
                                      message: messageC.text,
                                      media: _docUrl,
                                    );
                            handleApiResponse(
                              response: r,
                              onSuccess: () {
                                _clearData();
                                Navigator.pop(context);
                                // ModalWrapper.bottomSheet(
                                //   context: context,
                                //   widget: ConfirmationModal(
                                //     modalConfirmationArg:
                                //         ModalConfirmationArg(
                                //       iconPath: AppSvgs.checkIcon,
                                //       title: "Thank you for your message",
                                //       description: r.data['message'],
                                //       solidBtnText: "Okay",
                                //       onSolidBtnOnTap: () {
                                //         final ctx =
                                //             NavKey.appNavKey.currentContext;
                                //         Navigator.pop(ctx!);
                                //       },
                                //     ),
                                //   ),
                                // );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
