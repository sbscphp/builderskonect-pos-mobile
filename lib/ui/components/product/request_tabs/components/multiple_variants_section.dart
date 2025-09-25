import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

import 'inventory_information_section.dart';
import 'pricing_information_section.dart';

class MultipleVariantsSection extends ConsumerStatefulWidget {
  const MultipleVariantsSection({
    super.key,
    required this.configureVariantArg,
    required this.variantAttributeControllers,
    required this.variantInventoryControllers,
    required this.variantPricingControllers,
    required this.isViewVariantInfo,
    required this.isViewVariantInventoryInfo,
    required this.isViewVariantPricingInfo,
    required this.variantImages,
    required this.variantImageLoadStates,
    required this.onToggleVariantInfo,
    required this.onToggleVariantInventoryInfo,
    required this.onToggleVariantPricingInfo,
    required this.onEnsureVariantControllers,
    required this.onPickVariantCoverImage,
    required this.onPickVariantAdditionalImage,
    required this.onRemoveVariantCoverImage,
    required this.onRemoveVariantAdditionalImage,
  });

  final ConfigureVariantArg? configureVariantArg;
  final Map<int, List<TextEditingController>> variantAttributeControllers;
  final Map<int, Map<String, TextEditingController>>
      variantInventoryControllers;
  final Map<int, Map<String, TextEditingController>> variantPricingControllers;
  final List<bool> isViewVariantInfo;
  final List<bool> isViewVariantInventoryInfo;
  final List<bool> isViewVariantPricingInfo;
  final Map<int, Map<String, File?>> variantImages;
  final Map<int, Map<String, bool>> variantImageLoadStates;
  final Function(int) onToggleVariantInfo;
  final Function(int) onToggleVariantInventoryInfo;
  final Function(int) onToggleVariantPricingInfo;
  final VoidCallback onEnsureVariantControllers;
  final Function(int) onPickVariantCoverImage;
  final Function(int) onPickVariantAdditionalImage;
  final Function(int) onRemoveVariantCoverImage;
  final Function(int) onRemoveVariantAdditionalImage;

  @override
  ConsumerState<MultipleVariantsSection> createState() =>
      _MultipleVariantsSectionState();
}

class _MultipleVariantsSectionState
    extends ConsumerState<MultipleVariantsSection> {
  @override
  Widget build(BuildContext context) {
    if (widget.configureVariantArg == null) {
      return SizedBox.shrink();
    }
    final textTheme = Theme.of(context).textTheme;
    final numVariants = widget.configureVariantArg!.numOfVariants;
    final selectedVariantList = widget.configureVariantArg!.selectedVariantList;

    // Ensure controllers are set up
    widget.onEnsureVariantControllers();

    return Column(
      children: List.generate(numVariants, (variantIndex) {
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.neutral1,
            borderRadius: BorderRadius.circular(Sizer.radius(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Variant Attributes Section
              _buildVariantAttributesSection(variantIndex, selectedVariantList),
              YBox(16),

              // Inventory Information Section for this variant
              _buildVariantInventorySection(variantIndex),
              YBox(16),

              // Pricing Information Section for this variant
              _buildVariantPricingSection(variantIndex),

              Row(
                children: [
                  Expanded(
                      child: CustomBtn(
                    height: Sizer.height(42),
                    outlineColor: Colors.grey,
                    isOutline: true,
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppSvgs.trash,
                          height: Sizer.height(14),
                        ),
                        XBox(8),
                        Text(
                          "Remove",
                          style: textTheme.text14?.copyWith(
                            color: AppColors.red22,
                          ),
                        )
                      ],
                    ),
                  )),
                  XBox(10),
                  Expanded(
                    child: CustomBtn.solid(
                      height: Sizer.height(42),
                      onTap: () {},
                      text: "Add Variant",
                    ),
                  )
                ],
              )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildVariantAttributesSection(
      int variantIndex, List<ProductAttributeModel> selectedVariantList) {
    final textTheme = Theme.of(context).textTheme;
    final vm = ref.watch(productInventoryVmodel);
    final isExpanded = variantIndex < widget.isViewVariantInfo.length
        ? widget.isViewVariantInfo[variantIndex]
        : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Variant Attributes Header
        InkWell(
          onTap: () => widget.onToggleVariantInfo(variantIndex),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${vm.variationParams?.name ?? "N/A"} variant ${variantIndex + 1}",
                  style: textTheme.text16?.medium,
                ),
              ),
              Icon(isExpanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down)
            ],
          ),
        ),
        HDivider(),
        if (isExpanded)
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YBox(16),
                _buildVariantAttributes(variantIndex, selectedVariantList),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildVariantInventorySection(int variantIndex) {
    final inventoryControllers =
        widget.variantInventoryControllers[variantIndex];
    final images = widget.variantImages[variantIndex];
    final loadStates = widget.variantImageLoadStates[variantIndex];

    if (inventoryControllers == null || images == null || loadStates == null) {
      return SizedBox.shrink();
    }

    final isExpanded = variantIndex < widget.isViewVariantInventoryInfo.length
        ? widget.isViewVariantInventoryInfo[variantIndex]
        : false;

    return InventoryInformationSection(
      sellingUnitC: inventoryControllers['sellingUnit']!,
      stockQtyC: inventoryControllers['stockQty']!,
      qtyPerSellUnitC: inventoryControllers['qtyPerSellUnit']!,
      minOrderQty: inventoryControllers['minOrderQty']!,
      measurementC: inventoryControllers['measurement']!,
      dimensionC: inventoryControllers['dimension']!,
      weightPerSellUnitC: inventoryControllers['weightPerSellUnit']!,
      weightPerUnitItemC: inventoryControllers['weightPerUnitItem']!,
      reorderLevelC: inventoryControllers['reorderLevel']!,
      skuC: inventoryControllers['sku']!,
      isViewInventoryInformation: isExpanded,
      onToggleInventoryInfo: () =>
          widget.onToggleVariantInventoryInfo(variantIndex),
      coverImageFile: images['cover'],
      additionalImageFile: images['additional'],
      loadCoverImage: loadStates['cover'] ?? false,
      loadAdditionalImages: loadStates['additional'] ?? false,
      onPickCoverImage: () => widget.onPickVariantCoverImage(variantIndex),
      onPickAdditionalImage: () =>
          widget.onPickVariantAdditionalImage(variantIndex),
      onRemoveCoverImage: () => widget.onRemoveVariantCoverImage(variantIndex),
      onRemoveAdditionalImage: () =>
          widget.onRemoveVariantAdditionalImage(variantIndex),
    );
  }

  Widget _buildVariantPricingSection(int variantIndex) {
    final pricingControllers = widget.variantPricingControllers[variantIndex];

    if (pricingControllers == null) {
      return SizedBox.shrink();
    }

    final isExpanded = variantIndex < widget.isViewVariantPricingInfo.length
        ? widget.isViewVariantPricingInfo[variantIndex]
        : false;

    return PricingInformationSection(
      costPricePerUnitC: pricingControllers['costPricePerUnit']!,
      sellingPricePerUnitC: pricingControllers['sellingPricePerUnit']!,
      discountPriceC: pricingControllers['discountPrice']!,
      isViewPricingInformation: isExpanded,
      onTogglePricingInfo: () =>
          widget.onToggleVariantPricingInfo(variantIndex),
    );
  }

  Widget _buildVariantAttributes(
      int variantIndex, List<ProductAttributeModel> selectedVariantList) {
    final controllers = widget.variantAttributeControllers[variantIndex] ?? [];

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        final attribute = selectedVariantList[index];
        final controller = index < controllers.length
            ? controllers[index]
            : TextEditingController();

        return CustomTextField(
          controller: controller,
          labelText: attribute.attribute ?? '',
          hintText: 'Select option',
          showLabelHeader: true,
          showSuffixIcon: true,
          readOnly: true,
          onTap: () async {
            await ModalWrapper.bottomSheet(
              context: context,
              widget: StoreOptionModal(
                options: attribute.possibleValues
                        ?.map((e) => ModalOption(
                            title: e,
                            onTap: () {
                              controller.text = e;
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
      itemCount: selectedVariantList.length,
    );
  }
}
