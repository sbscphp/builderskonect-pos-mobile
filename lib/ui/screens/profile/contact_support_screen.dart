// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ContactSupportScreen extends ConsumerStatefulWidget {
  const ContactSupportScreen({super.key});

  @override
  ConsumerState<ContactSupportScreen> createState() =>
      _ContactSupportScreenState();
}

class _ContactSupportScreenState extends ConsumerState<ContactSupportScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "Contact Support",
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
                  Text("Support Form", style: textTheme.text16?.medium),
                  Text(
                    "Fill the form below to reach out to Buikder’sKonnect support team",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,

                    labelText: 'Subject',
                    hintText: 'Enter subject',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,

                    labelText: 'Issue type',
                    hintText: 'Enter issue type',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,

                    labelText: 'Message',
                    hintText: 'Enter message',
                    showLabelHeader: true,
                    maxLines: 4,
                  ),
                  YBox(16),
                  UploadWidget(
                    // documentName: _cacFile?.path.split('/').last,
                    labelText: "Supporting Document",
                    uploadText: "Click to upload",
                    buttomTextDesc: "JPEG, PDF, DOC.  Not more than 2MB",
                    onUpload: () async {},
                  ),
                  YBox(20),
                  CustomBtn.solid(
                    text: "Submit",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
