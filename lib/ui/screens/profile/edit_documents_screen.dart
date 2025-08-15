// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class EditDocumentsScreen extends ConsumerStatefulWidget {
  const EditDocumentsScreen({super.key});

  @override
  ConsumerState<EditDocumentsScreen> createState() =>
      _EditDocumentsScreenState();
}

class _EditDocumentsScreenState extends ConsumerState<EditDocumentsScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "Edit Request",
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
                  Text("Document Uploads", style: textTheme.text16?.medium),
                  Text(
                    "Edit information and submit for approval",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    labelText: 'Business Name',
                    hintText: 'Enter business name',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    labelText: 'Business Category',
                    hintText: 'Select business category',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    labelText: 'Business Type',
                    hintText: 'Select business type',
                    showLabelHeader: true,
                  ),
                  YBox(30),
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
