// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class AddProductScreen extends ConsumerStatefulWidget {
  const AddProductScreen(
      {super.key,
      required this.productWithStatus,
      required this.onProductUpdated});

  final ProductCatalogueWithStatus productWithStatus;
  final Function(ProductCatalogueWithStatus) onProductUpdated;

  @override
  ConsumerState<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends ConsumerState<AddProductScreen> {
  final formKey = GlobalKey<FormState>();
  final sellingUnitC = TextEditingController();
  final stockQuantityC = TextEditingController();
  final quantityPerSellingUnitC = TextEditingController();
  final minimumOrderQuantityC = TextEditingController();
  final weightPerSellingUnitC = TextEditingController();
  final reorderLevelC = TextEditingController();
  final costPriceC = TextEditingController();
  final sellingPriceC = TextEditingController();
  final discountPriceC = TextEditingController();
  final productTagsC = TextEditingController();
  final storeKeepingUnitC = TextEditingController();
  final skuC = TextEditingController();
  final productDescriptionC = TextEditingController();

  String? selectedSellingUnit;
  String? selectedSubUnit;
  SubOption? selectedSubOption;

  late ProductCatalogueWithStatus currentProductStatus;

  @override
  void initState() {
    super.initState();
    currentProductStatus = widget.productWithStatus;
    _initializeFormData();
  }

  void _initializeFormData() {
    final formData = currentProductStatus.formData;
    if (formData != null) {
      selectedSellingUnit = formData.sellingUnit;
      selectedSubUnit = formData.subUnit;
      stockQuantityC.text = formData.stockQuantity?.toString() ?? '';
      quantityPerSellingUnitC.text =
          formData.quantityPerSellingUnit?.toString() ?? '';
      minimumOrderQuantityC.text =
          formData.minimumOrderQuantity?.toString() ?? '';
      weightPerSellingUnitC.text =
          formData.weightPerSellingUnit?.toString() ?? '';
      reorderLevelC.text = formData.reorderLevel?.toString() ?? '';
      costPriceC.text = formData.costPrice?.toString() ?? '';
      sellingPriceC.text = formData.sellingPrice?.toString() ?? '';
      discountPriceC.text = formData.discountPrice?.toString() ?? '';
      productTagsC.text = formData.tags ?? '';
      skuC.text = formData.sku ?? '';
      productDescriptionC.text = formData.description ?? '';
    }
  }

  Future<void> _saveProductData() async {
    final formData = ProductFormData(
      sellingUnit: selectedSellingUnit,
      subUnit: selectedSubUnit,
      stockQuantity: stockQuantityC.text.trim(),
      quantityPerSellingUnit: quantityPerSellingUnitC.text.trim(),
      minimumOrderQuantity: minimumOrderQuantityC.text.trim(),
      weightPerSellingUnit: weightPerSellingUnitC.text.trim(),
      reorderLevel: reorderLevelC.text.trim(),
      costPrice: costPriceC.text.trim(),
      sellingPrice: sellingPriceC.text.trim(),
      discountPrice: discountPriceC.text.trim(),
      tags: productTagsC.text.isNotEmpty ? productTagsC.text : null,
      sku: skuC.text.isNotEmpty ? skuC.text : null,
      description:
          productDescriptionC.text.isNotEmpty ? productDescriptionC.text : null,
    );

    final updatedProductStatus = currentProductStatus.copyWith(
      formData: formData,
      isComplete: formData.isComplete,
    );

    setState(() {
      currentProductStatus = updatedProductStatus;
    });

    widget.onProductUpdated(updatedProductStatus);

    // Add a small delay to prevent route lifecycle conflicts with toast
    await Future.delayed(Duration(milliseconds: 100));
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _removeProduct() {
    Navigator.pop(context, 'remove');
  }

  @override
  void dispose() {
    sellingUnitC.dispose();
    stockQuantityC.dispose();
    quantityPerSellingUnitC.dispose();
    minimumOrderQuantityC.dispose();
    weightPerSellingUnitC.dispose();
    reorderLevelC.dispose();
    costPriceC.dispose();
    sellingPriceC.dispose();
    discountPriceC.dispose();
    productTagsC.dispose();
    storeKeepingUnitC.dispose();
    skuC.dispose();
    productDescriptionC.dispose();

    super.dispose();
  }

  void _showSubUnitModal(BuildContext context, MeasurementCategory unit) {
    ModalWrapper.bottomSheet(
      context: context,
      widget: UnitModal(
        title: unit.name,
        options: unit.subOptions
            .map(
              (subUnit) => UnitModalOption(
                title: subUnit.label,
                showTrailing: false,
                onTap: () {
                  Navigator.pop(context);
                  selectedSubOption = subUnit;
                  selectedSubUnit = subUnit.label;
                  sellingUnitC.text = subUnit.label;
                  setState(() {});
                },
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppbar(
        title: "Add Product Information",
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
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: Sizer.height(8),
                      horizontal: Sizer.width(16),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.neutral3,
                      borderRadius: BorderRadius.circular(Sizer.radius(4)),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: Sizer.width(44),
                          height: Sizer.height(44),
                          child: MyCachedNetworkImage(
                            imageUrl: currentProductStatus
                                    .catalogueModel.primaryMediaUrl ??
                                "",
                            fit: BoxFit.cover,
                          ),
                        ),
                        XBox(8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentProductStatus.catalogueModel.name ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.text16?.medium,
                              ),
                              Text(
                                currentProductStatus
                                        .catalogueModel.productType?.name ??
                                    "",
                                style: textTheme.text14?.copyWith(
                                  color: colorScheme.black45,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  YBox(16),
                  RichText(
                    text: TextSpan(
                      style: textTheme.text14,
                      children: [
                        TextSpan(
                          text: "All asterisk (",
                        ),
                        TextSpan(
                          text: "*",
                          style: textTheme.text14?.medium.copyWith(
                            color: Colors.red,
                          ),
                        ),
                        TextSpan(
                          text: ") are required fields",
                        ),
                      ],
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: sellingUnitC,
                    labelText: 'Selling Units',
                    hintText: "Select unit type",
                    showLabelHeader: true,
                    readOnly: true,
                    showSuffixIcon: true,
                    validator: Validators.required(),
                    onTap: () {
                      ModalWrapper.bottomSheet(
                        context: context,
                        widget: UnitModal(
                          title: "Selling Units",
                          options: sellingUnits
                              .map(
                                (unit) => UnitModalOption(
                                  title: unit.name,
                                  onTap: () {
                                    Navigator.pop(context);
                                    setState(() {
                                      selectedSellingUnit = unit.name;
                                      selectedSubUnit =
                                          null; // Reset sub-unit when main unit changes
                                    });

                                    // Show sub-unit modal if the selected unit has sub-units
                                    if (unit.hasSubOptions) {
                                      _showSubUnitModal(context, unit);
                                    }
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      );
                    },
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: stockQuantityC,
                    labelText: 'Stock Quantity',
                    hintText: 'Enter stock quantity',
                    showLabelHeader: true,
                    validator: Validators.required(),
                    keyboardType: TextInputType.number,
                    suffixIcon: selectedSubOption != null
                        ? SuffixBox(text: selectedSubOption?.id ?? "")
                        : null,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onTap: () {
                      if (selectedSubOption == null) {
                        showWarningToast("Please select a sub-unit");
                      }
                      return;
                    },
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: quantityPerSellingUnitC,
                    labelText: 'Quantity per Selling Unit',
                    hintText: 'Enter quantity per selling unit',
                    showLabelHeader: true,
                    keyboardType: TextInputType.number,
                    suffixIcon: selectedSubOption != null
                        ? SuffixBox(text: selectedSubOption?.id ?? "")
                        : null,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: Validators.required(),
                    onTap: () {},
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: minimumOrderQuantityC,
                    labelText: 'Minimum Order Quantity',
                    hintText: 'Enter minimum order quantity',
                    showLabelHeader: true,
                    keyboardType: TextInputType.number,
                    suffixIcon: selectedSubOption != null
                        ? SuffixBox(text: selectedSubOption?.id ?? "")
                        : null,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: weightPerSellingUnitC,
                    labelText: 'Weight per Selling Unit',
                    hintText: 'Enter weight per selling unit',
                    showLabelHeader: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    suffixIcon: SuffixBox(text: "kg"),
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: reorderLevelC,
                    labelText: 'Reorder Level',
                    hintText: 'Enter reorder level',
                    showLabelHeader: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: costPriceC,
                    labelText: 'Cost Price *',
                    hintText: '00.00',
                    showLabelHeader: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(Sizer.radius(10)),
                      child: SvgPicture.asset(
                        AppSvgs.naira,
                        fit: BoxFit.cover,
                      ),
                    ),
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: sellingPriceC,
                    labelText: 'Selling Price *',
                    hintText: '00.00',
                    showLabelHeader: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(Sizer.radius(10)),
                      child: SvgPicture.asset(
                        AppSvgs.naira,
                        fit: BoxFit.cover,
                      ),
                    ),
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: discountPriceC,
                    labelText: 'Discount Price',
                    optionalText: "(optional)",
                    hintText: '00.00',
                    showLabelHeader: true,
                    isRequired: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(Sizer.radius(10)),
                      child: SvgPicture.asset(
                        AppSvgs.naira,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: productTagsC,
                    labelText: 'Product Tags',
                    hintText: 'Enter product tags',
                    showLabelHeader: true,
                    isRequired: false,
                  ),
                  Text(
                    "This will help customers find your product in the marketplace.",
                    style: textTheme.text14?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: skuC,
                    labelText: 'Store Keeping Unit (SKU) *',
                    hintText: 'TL-12346-IB',
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: productDescriptionC,
                    labelText: 'Description',
                    hintText: 'Enter product description',
                    showLabelHeader: true,
                    isRequired: false,
                    maxLines: 3,
                  ),
                  YBox(16),
                  RichText(
                    text: TextSpan(
                      style: textTheme.text14,
                      children: [
                        TextSpan(
                          text: "Product Images ",
                        ),
                        TextSpan(
                          text: " (max. 3 images)",
                          style: textTheme.text14?.copyWith(
                            color: colorScheme.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  YBox(4),
                  Container(
                    width: Sizer.width(104),
                    height: Sizer.height(104),
                    padding: EdgeInsets.all(Sizer.radius(9)),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.neutral5,
                      ),
                    ),
                    child: MyCachedNetworkImage(
                      imageUrl: AppUtils.dummyImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  YBox(8),
                  InkWell(
                    onTap: () {},
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
                  YBox(32),
                  Row(
                    children: [
                      Expanded(
                        child: CustomBtn.withChild(
                          isOutline: true,
                          onTap: _removeProduct,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                AppSvgs.trash,
                                height: Sizer.height(16),
                              ),
                              XBox(10),
                              Text(
                                "Remove",
                                style: textTheme.text16?.copyWith(
                                  color: AppColors.red2D,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      XBox(16),
                      Expanded(
                        child: CustomBtn.solid(
                            text: "Save",
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                await _saveProductData();
                              }
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuffixBox extends StatelessWidget {
  const SuffixBox({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Sizer.radius(10)),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppColors.neutral5,
          ),
        ),
      ),
      child: Text(text),
    );
  }
}
