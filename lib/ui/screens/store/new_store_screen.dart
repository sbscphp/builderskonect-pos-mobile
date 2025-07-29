// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class NewStoreScreen extends ConsumerStatefulWidget {
  const NewStoreScreen({super.key});

  @override
  ConsumerState<NewStoreScreen> createState() => _NewStoreScreenState();
}

class _NewStoreScreenState extends ConsumerState<NewStoreScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "New Store",
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
                  Text("Add New Store", style: textTheme.text16?.medium),
                  Text(
                    "Fill the form below to add a new store",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    isRequired: false,
                    labelText: 'Store Name',
                    hintText: 'Enter store name',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    isRequired: false,
                    labelText: 'Store Address',
                    optionalText: "(optional)",
                    hintText: 'Enter store address',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    isRequired: false,
                    labelText: 'State',
                    optionalText: "(optional)",
                    hintText: 'Select state',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    isRequired: false,
                    labelText: 'City/Region',
                    optionalText: "(optional)",
                    hintText: 'Enter city/region',
                    showLabelHeader: true,
                  ),
                  YBox(20),
                  CustomBtn.solid(
                    text: "Save",
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
