import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class RequestBasicInfo extends ConsumerStatefulWidget {
  const RequestBasicInfo({
    super.key,
    this.onNext,
  });

  final Function()? onNext;

  @override
  ConsumerState<RequestBasicInfo> createState() => _RequestBasicInfoState();
}

class _RequestBasicInfoState extends ConsumerState<RequestBasicInfo> {
  final _formKey = GlobalKey<FormState>();
  final productNameC = TextEditingController();
  final brandC = TextEditingController();
  final categoryC = TextEditingController();
  final subCategoryC = TextEditingController();
  final typeC = TextEditingController();
  final tagsC = TextEditingController();
  final descriptionC = TextEditingController();

  BrandModel? selectedBrand;
  CategoryModel? selectedCategory;
  CategoryModel? selectedSubCategory;
  CategoryModel? selectedCategoryType;

  @override
  void dispose() {
    productNameC.dispose();
    brandC.dispose();
    categoryC.dispose();
    subCategoryC.dispose();
    typeC.dispose();
    descriptionC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterHeader(
                  title: "Product Details",
                  subTitle:
                      "Fill the form below to add required product information.",
                ),
                YBox(16),
                CustomTextField(
                  controller: productNameC,
                  labelText: 'Product Name',
                  hintText: 'Enter product name',
                  showLabelHeader: true,
                ),
                YBox(16),
                CustomTextField(
                  controller: brandC,
                  labelText: 'Brand',
                  hintText: 'Select brand',
                  showLabelHeader: true,
                  showSuffixIcon: true,
                  readOnly: true,
                  onTap: () async {
                    final res = await ModalWrapper.bottomSheet(
                      context: context,
                      widget: ProductBrandModal(),
                    );
                    if (res is BrandModel) {
                      brandC.text = res.name ?? '';
                    }
                  },
                ),
                YBox(16),
                CustomTextField(
                  controller: categoryC,
                  labelText: 'Product Category',
                  hintText: 'Select product category',
                  showLabelHeader: true,
                  showSuffixIcon: true,
                  readOnly: true,
                  onTap: () async {
                    final res = await ModalWrapper.bottomSheet(
                      context: context,
                      widget: ProductCategoryModal(),
                    );

                    if (res is CategoryModel) {
                      selectedCategory = res;
                      categoryC.text = res.name ?? '';
                    }
                  },
                ),
                YBox(16),
                CustomTextField(
                  controller: subCategoryC,
                  labelText: 'Sub Product Category',
                  hintText: 'Select sub product category',
                  showLabelHeader: true,
                  showSuffixIcon: true,
                  readOnly: true,
                  onTap: () async {
                    if (selectedCategory == null) {
                      showWarningToast("Please select category first");
                      return;
                    }
                    final res = await ModalWrapper.bottomSheet(
                      context: context,
                      widget: ProductSubCategoryModal(
                        catId: selectedCategory?.id ?? "",
                      ),
                    );

                    if (res is CategoryModel) {
                      selectedSubCategory = res;
                      subCategoryC.text = res.name ?? '';
                    }
                  },
                ),
                YBox(16),
                CustomTextField(
                  controller: typeC,
                  labelText: 'Product Type',
                  hintText: 'Select product type',
                  showLabelHeader: true,
                  showSuffixIcon: true,
                  readOnly: true,
                  onTap: () async {
                    if (selectedSubCategory == null) {
                      showWarningToast("Please select sub category first");
                      return;
                    }
                    final res = await ModalWrapper.bottomSheet(
                      context: context,
                      widget: ProductType(
                        catId: selectedSubCategory?.id ?? "",
                      ),
                    );

                    if (res is CategoryModel) {
                      selectedCategoryType = res;
                      typeC.text = res.name ?? '';
                    }
                  },
                ),
                // YBox(16),
                // Text(
                //   "Product Images",
                //   style: textTheme.text14,
                // ),
                // YBox(8),
                // Row(
                //   children: [
                //     Container(
                //       height: Sizer.height(104),
                //       width: Sizer.width(104),
                //       padding: EdgeInsets.all(Sizer.radius(9)),
                //       decoration: BoxDecoration(
                //         border: Border.all(
                //           color: AppColors.neutral5,
                //         ),
                //         borderRadius: BorderRadius.circular(Sizer.radius(2)),
                //       ),
                //       child: Image.asset(AppImages.cement),
                //     ),
                //     XBox(8),
                //     SizedBox(
                //       height: Sizer.height(104),
                //       child: SvgPicture.asset(
                //         AppSvgs.uploadImgSquare,
                //         fit: BoxFit.cover,
                //       ),
                //     ),
                //   ],
                // ),
                // YBox(4),
                // Text(
                //   "Recommended file size is less than 2MB. JEPG, PNG formats only",
                //   style: textTheme.text14?.copyWith(
                //     color: colorScheme.black45,
                //   ),
                // ),
                YBox(16),
                CustomTextField(
                  controller: tagsC,
                  labelText: 'Tags',
                  hintText: 'Enter tags',
                  showLabelHeader: true,
                ),

                Text(
                  "This will help customers find your product in the marketplace.",
                  style: textTheme.text14?.copyWith(
                    color: colorScheme.black45,
                  ),
                ),
                YBox(16),

                CustomTextField(
                  labelText: 'Description',
                  hintText: 'Enter description',
                  maxLines: 3,
                  showLabelHeader: true,
                ),

                YBox(32),
                CustomBtn.solid(
                  text: "Next",
                  onTap: () {
                    widget.onNext?.call();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
