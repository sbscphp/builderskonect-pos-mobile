import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

class RequestAttributeVarientTab extends ConsumerStatefulWidget {
  const RequestAttributeVarientTab({
    super.key,
    this.onNext,
    this.onPrevious,
  });

  final Function()? onNext;
  final Function()? onPrevious;

  @override
  ConsumerState<RequestAttributeVarientTab> createState() =>
      _RequestAttributeVarientTabState();
}

class _RequestAttributeVarientTabState
    extends ConsumerState<RequestAttributeVarientTab> {
  final sellingUnitC = TextEditingController();
  final stockQtyC = TextEditingController();
  final qtyPerSellUnitC = TextEditingController();
  final minOrderQty = TextEditingController();
  final measurementC = TextEditingController();
  final dimensionC = TextEditingController();
  final weightPerSellUnitC = TextEditingController();
  final weightPerUnitItemC = TextEditingController();
  final reorderLevelC = TextEditingController();
  final skuC = TextEditingController();

  final costPricePerUnitC = TextEditingController();
  final sellingPricePerUnitC = TextEditingController();
  final discountPriceC = TextEditingController();

  // Controllers for common attributes to maintain state
  List<TextEditingController> attributeControllers = [];

  bool isViewInventoryInformation = false;
  bool isViewPricingInformation = false;
  bool isViewVariantInfo = false;
  bool productHasVariant = false;

  // If productHasVariant is set to true
  // int numOfVariants = 1;
  // List<ProductAttributeModel> selectedVariantList = [];
  ConfigureVariantArg? _configureVariantArg;

  // Cover image
  File? _coverImageFile;
  String? _coverImageUrl;

  // Additional product images
  File? _additionalImageFile;
  String? _additionalImageUrl;

  // load state
  bool loadCoverImage = false;
  bool loadAdditionalImages = false;

  // Method to ensure we have the right number of controllers
  void _ensureControllers(int requiredCount) {
    // Add controllers if we need more
    while (attributeControllers.length < requiredCount) {
      attributeControllers.add(TextEditingController());
    }

    // Remove excess controllers if we have too many
    while (attributeControllers.length > requiredCount) {
      final controller = attributeControllers.removeLast();
      controller.dispose();
    }
  }

  @override
  void dispose() {
    sellingUnitC.dispose();
    stockQtyC.dispose();
    qtyPerSellUnitC.dispose();
    minOrderQty.dispose();
    measurementC.dispose();
    dimensionC.dispose();
    weightPerSellUnitC.dispose();
    weightPerUnitItemC.dispose();
    reorderLevelC.dispose();
    skuC.dispose();

    costPricePerUnitC.dispose();
    sellingPricePerUnitC.dispose();
    discountPriceC.dispose();

    // Dispose attribute controllers
    for (var controller in attributeControllers) {
      controller.dispose();
    }
    attributeControllers.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productInventoryVmodel);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterHeader(
                title: "Product Attributes",
                subTitle: "Select attributes you want to add to this product",
              ),
              YBox(40),
              CustomBtn(
                text: "Add attributes",
                isOutline: true,
                textColor: colorScheme.black85,
                onTap: () async {
                  await ModalWrapper.bottomSheet(
                    context: context,
                    widget: AddAttributeModal(),
                  );
                },
              ),
              YBox(16),
              vm.selectedAttributeList.isNotEmpty
                  ? Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: vm.selectedAttributeList
                          .map(
                            (e) => TagWidget(
                              tag: e.attribute ?? '',
                              onClose: () {
                                vm.selectedAttributeList.remove(e);
                                vm.updateUI();
                              },
                              showCloseIcon: true,
                              tagColor: TagColor(
                                bgColor: AppColors.greenED,
                                borderColor: AppColors.green8F,
                                textColor: AppColors.green1A,
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : SizedBox.shrink(),
              if (vm.selectedAttributeList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HDivider(),
                    YBox(8),
                    Text(
                      "Does this product have variants?",
                      style: textTheme.text14?.medium,
                    ),
                    YBox(10),
                    Row(
                      children: [
                        Row(
                          children: [
                            CustomRadioBtn(
                              isSelected: productHasVariant == true,
                              onTap: () {
                                productHasVariant = true;
                                setState(() {});
                              },
                            ),
                            XBox(8),
                            Text(
                              "Yes",
                              style: textTheme.text14?.medium,
                            ),
                          ],
                        ),
                        XBox(40),
                        Row(
                          children: [
                            CustomRadioBtn(
                              isSelected: productHasVariant == false,
                              onTap: () {
                                productHasVariant = false;
                                setState(() {});
                              },
                            ),
                            XBox(8),
                            Text(
                              "No",
                              style: textTheme.text14?.medium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              // CustomBtn.solid(
              //   text: "Next",
              //   onTap: () {},
              // ),
            ],
          ),
        ),
        YBox(16),
        if (vm.selectedAttributeList.isNotEmpty)
          Container(
            padding: EdgeInsets.all(Sizer.radius(16)),
            decoration: BoxDecoration(
              color: colorScheme.white,
              borderRadius: BorderRadius.circular(Sizer.radius(6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${productHasVariant == true ? 'Common' : 'Product'} Attributes",
                  style: textTheme.text16?.medium,
                ),
                HDivider(),
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
                // Common Attributes list
                Builder(
                  builder: (context) {
                    // Ensure we have the right number of controllers
                    _ensureControllers(vm.selectedAttributeList.length);

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) {
                        final attribute = vm.selectedAttributeList[index];

                        return CustomTextField(
                          controller: attributeControllers[index],
                          labelText: attribute.attribute ?? '',
                          hintText: 'Select option',
                          showLabelHeader: true,
                          showSuffixIcon: true,
                          readOnly: true,
                          onTap: () async {
                            final res = await ModalWrapper.bottomSheet(
                              context: context,
                              widget: StoreOptionModal(
                                options: attribute.possibleValues
                                        ?.map((e) => ModalOption(
                                            title: e,
                                            onTap: () {
                                              attributeControllers[index].text =
                                                  e;
                                              Navigator.pop(context);
                                            }))
                                        .toList() ??
                                    [],
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (__, _) => YBox(16),
                      itemCount: vm.selectedAttributeList.length,
                    );
                  },
                ),
                YBox(20),
                //!!OBSCURE VARIENT FLOW!!
                if (productHasVariant == true)
                  CustomBtn.withChild(
                    width: Sizer.screenWidth * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add,
                          color: colorScheme.white,
                        ),
                        XBox(10),
                        Text(
                          "Add Varying Attributes",
                          style: textTheme.text16?.medium.copyWith(
                            color: colorScheme.white,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget:
                            ConfigureVariantModal(arg: _configureVariantArg),
                      );
                      if (res is ConfigureVariantArg) {
                        _configureVariantArg = res;
                        setState(() {});
                      }
                    },
                  ),
              ],
            ),
          ),
        YBox(16),

        // Variant Container
        Container(
          padding: EdgeInsets.all(Sizer.radius(16)),
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Variant
              InkWell(
                onTap: () {
                  isViewVariantInfo = !isViewVariantInfo;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${vm.variationParams?.name ?? "N/A"} variant 1",
                        style: textTheme.text16?.medium,
                      ),
                    ),
                    Icon(isViewVariantInfo
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down)
                  ],
                ),
              ),
              HDivider(),
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: !isViewVariantInfo
                    ? YBox(20)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          // Common Attributes list
                          Builder(
                            builder: (context) {
                              // Ensure we have the right number of controllers
                              _ensureControllers(
                                  vm.selectedAttributeList.length);

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  final attribute =
                                      vm.selectedAttributeList[index];

                                  return CustomTextField(
                                    controller: attributeControllers[index],
                                    labelText: attribute.attribute ?? '',
                                    hintText: 'Select option',
                                    showLabelHeader: true,
                                    showSuffixIcon: true,
                                    readOnly: true,
                                    onTap: () async {
                                      final res =
                                          await ModalWrapper.bottomSheet(
                                        context: context,
                                        widget: StoreOptionModal(
                                          options: attribute.possibleValues
                                                  ?.map((e) => ModalOption(
                                                      title: e,
                                                      onTap: () {
                                                        attributeControllers[
                                                                index]
                                                            .text = e;
                                                        Navigator.pop(context);
                                                      }))
                                                  .toList() ??
                                              [],
                                        ),
                                      );
                                    },
                                  );
                                },
                                separatorBuilder: (__, _) => YBox(16),
                                itemCount: vm.selectedAttributeList.length,
                              );
                            },
                          ),
                        ],
                      ),
              ),

              //Inventory FORM
              InkWell(
                onTap: () {
                  isViewInventoryInformation = !isViewInventoryInformation;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Inventory Information",
                        style: textTheme.text16?.medium,
                      ),
                    ),
                    Icon(isViewInventoryInformation
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down)
                  ],
                ),
              ),
              HDivider(),
              if (isViewInventoryInformation)
                AnimatedSize(
                  duration: Duration(milliseconds: 300),
                  child: !isViewInventoryInformation
                      ? null
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              hintText: 'Select unit type',
                              showLabelHeader: true,
                              // showSuffixIcon: true,
                              // readOnly: true,
                              onTap: () async {
                                // final res = await ModalWrapper.bottomSheet(
                                //   context: context,
                                //   widget: StoreOptionModal(
                                //     options: attribute.possibleValues
                                //             ?.map((e) => ModalOption(
                                //                 title: e,
                                //                 onTap: () {
                                //                   ctrs[index].text = e;
                                //                   Navigator.pop(context);
                                //                 }))
                                //             .toList() ??
                                //         [],
                                //   ),
                                // );
                              },
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: stockQtyC,
                              labelText: 'Stock Quantity',
                              hintText: 'Enter stock quantity',
                              showLabelHeader: true,
                              // showSuffixIcon: true,
                              // readOnly: true,
                              onTap: () async {
                                // final res = await ModalWrapper.bottomSheet(
                                //   context: context,
                                //   widget: StoreOptionModal(
                                //     options: attribute.possibleValues
                                //             ?.map((e) => ModalOption(
                                //                 title: e,
                                //                 onTap: () {
                                //                   ctrs[index].text = e;
                                //                   Navigator.pop(context);
                                //                 }))
                                //             .toList() ??
                                //         [],
                                //   ),
                                // );
                              },
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: qtyPerSellUnitC,
                              labelText: 'Quantity per Selling Unit',
                              hintText: 'e.g 12 tiles per unit',
                              showLabelHeader: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: minOrderQty,
                              labelText: 'Minimum order quantity',
                              hintText: 'Enter minimum quantity',
                              showLabelHeader: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: measurementC,
                              labelText: 'Measurement',
                              hintText: 'Select unit measurement',
                              isRequired: false,
                              showLabelHeader: true,
                              showSuffixIcon: true,
                              readOnly: true,
                              onTap: () async {
                                // final res = await ModalWrapper.bottomSheet(
                                //   context: context,
                                //   widget: StoreOptionModal(
                                //     options: attribute.possibleValues
                                //             ?.map((e) => ModalOption(
                                //                 title: e,
                                //                 onTap: () {
                                //                   ctrs[index].text = e;
                                //                   Navigator.pop(context);
                                //                 }))
                                //             .toList() ??
                                //         [],
                                //   ),
                                // );
                              },
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: dimensionC,
                              labelText: 'Dimension',
                              hintText: 'Enter value',
                              showLabelHeader: true,
                              isRequired: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: weightPerSellUnitC,
                              labelText: 'Weight per Selling Unit',
                              hintText: 'Enter value',
                              showLabelHeader: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: weightPerUnitItemC,
                              labelText: 'Weight per unit item',
                              hintText: 'Enter value',
                              showLabelHeader: true,
                              isRequired: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: reorderLevelC,
                              labelText: 'Re-order Level',
                              hintText: 'Enter value',
                              showLabelHeader: true,
                              isRequired: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: skuC,
                              labelText: 'Store Keeping Unit (SKU)',
                              hintText: 'Enter value',
                              showLabelHeader: true,
                              isRequired: false,
                            ),
                            YBox(16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DottedUpload(
                                  label: "Cover Image",
                                  isUploading: loadCoverImage,
                                  onTap: () {
                                    _pickCoverImage();
                                  },
                                ),
                                YBox(16),
                                if (_coverImageFile != null) ...[
                                  YBox(8),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            _coverImageFile!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -8,
                                        right: -8,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _coverImageFile = null;
                                              _coverImageUrl = null;
                                            });
                                          },
                                          icon: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            YBox(16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DottedUpload(
                                  label: "Other images:",
                                  isUploading: loadAdditionalImages,
                                  isCoverImage: false,
                                  onTap: () {
                                    _pickAdditionalImage();
                                  },
                                ),
                                YBox(16),
                                if (_additionalImageFile != null) ...[
                                  YBox(8),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.file(
                                            _additionalImageFile!,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -8,
                                        right: -8,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _additionalImageFile = null;
                                              _additionalImageUrl = null;
                                            });
                                          },
                                          icon: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            YBox(16),
                          ],
                        ),
                ),
              YBox(16),
              //Pricing FORM
              InkWell(
                onTap: () {
                  setState(() {
                    isViewPricingInformation = !isViewPricingInformation;
                  });
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Pricing Information",
                        style: textTheme.text16?.medium,
                      ),
                    ),
                    Icon(isViewPricingInformation
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down)
                  ],
                ),
              ),
              HDivider(),
              if (isViewPricingInformation)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: !isViewPricingInformation
                      ? SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                              controller: costPricePerUnitC,
                              labelText: 'Cost Price per Unit',
                              hintText: '0.00',
                              showLabelHeader: true,
                              // showSuffixIcon: true,
                              // readOnly: true,
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: sellingPricePerUnitC,
                              labelText: 'Selling Price per Unit',
                              hintText: '0.00',
                              showLabelHeader: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            YBox(16),
                            CustomTextField(
                              controller: discountPriceC,
                              labelText: 'Discount Price',
                              optionalText: "(Optional)",
                              hintText: '0.00',
                              showLabelHeader: true,
                              isRequired: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ],
                        ),
                ),
              YBox(16),
            ],
          ),
        ),
        YBox(24),
        Row(
          children: [
            Expanded(
              child: CustomBtn.solid(
                onTap: () {
                  widget.onPrevious?.call();
                },
                text: "Back",
                textColor: Colors.black,
                onlineColor: Colors.transparent,
                outlineColor: Colors.grey,
              ),
            ),
            SizedBox(
              width: 24,
            ),
            Expanded(
              child: CustomBtn.solid(
                onTap: () {
                  _handleNext();
                },
                text: "Next",
              ),
            )
          ],
        )
      ],
    );
  }

  void _handleNext() {
    try {
      final productInventoryVm = ref.read(productInventoryVmodel);

      // Get current variation params or create new one
      final currentParams = productInventoryVm.variationParams;

      // Create media object
      final media = ProductVarientMedia(
        productSpecification: _coverImageUrl ?? '',
        productAdditionalDocument: _additionalImageUrl ?? '',
      );

      // Create variant metadata with selected attributes
      final attributeMap = <String, List<String>>{};
      final selectedAttributes = productInventoryVm.selectedAttributeList;

      for (int i = 0; i < selectedAttributes.length; i++) {
        final attribute = selectedAttributes[i];
        final value = i < attributeControllers.length
            ? attributeControllers[i].text.trim()
            : '';

        if (value.isNotEmpty) {
          attributeMap[attribute.attribute ?? ''] = [value];
        }
      }

      final variantMetadata = VariantMetadata(attributes: attributeMap);

      // Create variant media
      final variantMedia = VariantMedia(
        coverImageUrl: _coverImageUrl ?? '',
        productImageUrl: _additionalImageUrl ?? '',
      );

      // Parse numeric values with defaults
      final costPrice = int.tryParse(costPricePerUnitC.text.trim()) ?? 0;
      final sellingPrice = int.tryParse(sellingPricePerUnitC.text.trim()) ?? 0;
      final discountPrice =
          int.tryParse(discountPriceC.text.trim()) ?? sellingPrice;
      final stockQuantity = int.tryParse(stockQtyC.text.trim()) ?? 0;
      final qtyPerSellingUnit = int.tryParse(qtyPerSellUnitC.text.trim()) ?? 1;
      final minOrderQuantity = int.tryParse(minOrderQty.text.trim()) ?? 1;
      final reorderLevel = int.tryParse(reorderLevelC.text.trim()) ?? 0;

      // Create unit values with defaults
      final physicalMeasurement = UnitValue(
        unit: 'cm',
        value: int.tryParse(measurementC.text.trim()) ?? 0,
      );

      final physicalDimension = UnitValue(
        unit: 'cm',
        value: int.tryParse(dimensionC.text.trim()) ?? 0,
      );

      final weightPerUnitItem = UnitValue(
        unit: 'kg',
        value: int.tryParse(weightPerUnitItemC.text.trim()) ?? 0,
      );

      final weight = UnitValue(
        unit: 'kg',
        value: int.tryParse(weightPerSellUnitC.text.trim()) ?? 0,
      );

      // Create variant
      final variant = Variant(
        sku: skuC.text.trim().isEmpty
            ? 'SKU-${DateTime.now().millisecondsSinceEpoch}'
            : skuC.text.trim(),
        physicalMeasurementUnit: physicalMeasurement,
        physicalDimension: physicalDimension,
        weightPerUnitItem: weightPerUnitItem,
        media: variantMedia,
        quantityPerSellingUnit: qtyPerSellingUnit,
        weight: weight,
        sellingUnit: sellingUnitC.text.trim().isEmpty
            ? 'piece'
            : sellingUnitC.text.trim(),
        unitRetailPrice: sellingPrice,
        unitCostPrice: costPrice,
        currentPrice: discountPrice,
        reorderValue: reorderLevel,
        minimumOrderQuantity: minOrderQuantity,
        quantity: stockQuantity,
        metadata: variantMetadata,
      );

      // Update variation params
      final updatedParams = currentParams?.copyWith(
            media: media,
            variants: [variant],
          ) ??
          ProductVariationParams(
            media: media,
            variants: [variant],
          );

      // Set the variation params
      productInventoryVm.setVariationParams(updatedParams);

      // Navigate to next tab
      widget.onNext?.call();
    } catch (e) {
      showWarningToast('Error processing form data: ${e.toString()}');
    }
  }

  Future<void> _pickCoverImage() async {
    setState(() {
      loadCoverImage = true;
    });

    try {
      // Reset progress tracking for any previous uploads
      ref.read(fileUploadVm).resetProgress();

      final pickedFile = await ImageAndDocUtils.pickImage(enableCropping: true);

      if (pickedFile != null) {
        _coverImageFile = File(pickedFile.path);
        setState(() {});
      }

      if (_coverImageFile != null) {
        final r =
            await ref.read(fileUploadVm).uploadFile(file: [_coverImageFile!]);
        if (r.success && r.data != null && r.data!.isNotEmpty) {
          printty("upload complete ${r.data!.first.url}");
          _coverImageUrl = r.data!.first.url;
        }
      }
    } catch (e) {
      showWarningToast(e.toString());
    } finally {
      setState(() => loadCoverImage = false);
    }
  }

  Future<void> _pickAdditionalImage() async {
    setState(() {
      loadAdditionalImages = true;
    });

    try {
      // Reset progress tracking for any previous uploads
      ref.read(fileUploadVm).resetProgress();

      final pickedFile = await ImageAndDocUtils.pickImage(enableCropping: true);

      if (pickedFile != null) {
        _additionalImageFile = File(pickedFile.path);
        setState(() {});
      }

      if (_additionalImageFile != null) {
        final r = await ref
            .read(fileUploadVm)
            .uploadFile(file: [_additionalImageFile!]);
        if (r.success && r.data != null && r.data!.isNotEmpty) {
          printty("upload complete ${r.data!.first.url}");
          _additionalImageUrl = r.data!.first.url;
        }
      }
    } catch (e) {
      showWarningToast(e.toString());
    } finally {
      setState(() => loadAdditionalImages = false);
    }
  }
}

class DottedUpload extends StatelessWidget {
  const DottedUpload({
    super.key,
    required this.label,
    this.isUploading = false,
    this.isCoverImage = true,
    this.onTap,
  });
  final String label;
  final bool isUploading;
  final bool isCoverImage;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.text14,
        ),
        YBox(6),
        isUploading
            ? Container(
                height: Sizer.height(104),
                decoration: BoxDecoration(
                  color: AppColors.neutral2,
                  border: Border.all(
                    color: AppColors.neutral5,
                  ),
                  borderRadius: BorderRadius.circular(Sizer.radius(4)),
                ),
                child: Center(
                  child: SpinKitLoader(
                    size: Sizer.height(35),
                    color: AppColors.neutral5,
                  ),
                ),
              )
            : InkWell(
                onTap: onTap,
                child: SvgPicture.asset(
                  isCoverImage ? AppSvgs.dottedCover : AppSvgs.dottedUpload,
                  height: Sizer.height(104),
                ),
              ),
      ],
    );
  }
}
