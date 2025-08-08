// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen({super.key});

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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
              padding: EdgeInsets.all(Sizer.radius(16)),
              decoration: BoxDecoration(
                color: colorScheme.white,
                borderRadius: BorderRadius.circular(Sizer.radius(6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterHeader(
                    title: "Add Product Details",
                    subTitle:
                        "Fill the form below to add required product information.",
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Product Name',
                    hintText: 'Enter product name',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Store Keeping Unit (SKU)',
                    hintText: 'Enter SKU',
                    readOnly: true,
                    fillColor: AppColors.neutral3,
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'EAN',
                    hintText: 'Enter reason for return',
                    readOnly: true,
                    fillColor: AppColors.neutral3,
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  Text(
                    "Product Images",
                    style: textTheme.text14,
                  ),
                  YBox(8),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutePath.viewUploadScreen);
                    },
                    child: SizedBox(
                      height: Sizer.height(104),
                      width: Sizer.screenWidth,
                      child: SvgPicture.asset(
                        AppSvgs.uploadImg,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  YBox(4),
                  Text(
                    "Recommended file size is less than 2MB. JEPG, PNG formats only",
                    style: textTheme.text14?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Size',
                    hintText: 'Enter size',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Cost Price',
                    hintText: 'Enter cost price',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Selling Price',
                    hintText: 'Enter selling price',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Stock Level',
                    hintText: 'Enter stock level',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Reorder Level',
                    hintText: 'Enter reorder level',
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Description',
                    hintText: 'Enter description',
                    maxLines: 3,
                    showLabelHeader: true,
                  ),
                  YBox(16),
                  CustomTextField(
                    labelText: 'Product Tags',
                    hintText: 'Enter product tags',
                    showLabelHeader: true,
                  ),
                  Text(
                    "This will help customers find your product in the marketplace.",
                    style: textTheme.text14?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(32),
                  CustomBtn.solid(
                    text: "Finish",
                    onTap: () {
                      Navigator.pushNamed(
                          context, RoutePath.addProductRequestScreen);
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
