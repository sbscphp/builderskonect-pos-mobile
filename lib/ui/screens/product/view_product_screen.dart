// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ViewProductScreen extends ConsumerStatefulWidget {
  const ViewProductScreen({super.key});

  @override
  ConsumerState<ViewProductScreen> createState() => _ViewProductScreenState();
}

class _ViewProductScreenState extends ConsumerState<ViewProductScreen> {
  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "Add Product",
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
              height: Sizer.screenHeight * 0.8,
              padding: EdgeInsets.all(Sizer.radius(16)),
              decoration: BoxDecoration(
                color: colorScheme.white,
                borderRadius: BorderRadius.circular(Sizer.radius(4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    // controller: tinC,
                    // focusNode: tinF,
                    isRequired: false,
                    labelText: 'Search here to add product',
                    hintText: 'Enter product name',
                    showLabelHeader: true,
                    onTsp: () {
                      Navigator.pushNamed(context, RoutePath.addProductScreen);
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
