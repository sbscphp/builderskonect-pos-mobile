import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter/services.dart';

import 'image_upload_section.dart';

class InventoryInformationSection extends ConsumerStatefulWidget {
  const InventoryInformationSection({
    super.key,
    required this.sellingUnitC,
    required this.stockQtyC,
    required this.qtyPerSellUnitC,
    required this.minOrderQty,
    required this.measurementC,
    required this.dimensionC,
    required this.weightPerSellUnitC,
    required this.weightPerUnitItemC,
    required this.reorderLevelC,
    required this.skuC,
    required this.isViewInventoryInformation,
    required this.onToggleInventoryInfo,
    required this.coverImageFile,
    required this.additionalImageFiles,
    required this.loadCoverImage,
    required this.loadAdditionalImages,
    required this.onPickCoverImage,
    required this.onPickAdditionalImage,
    required this.onRemoveCoverImage,
    required this.onRemoveAdditionalImage,
    this.productHasVariant = false,
    this.variantIndex,
    this.onApplyToAllVariants,
    this.isApplyToAllEnabled = true,
    this.appliedFromVariant,
    this.onRemoveAdditionalImageAt,
    this.onUnitSelectionChanged,
  });

  final TextEditingController sellingUnitC;
  final TextEditingController stockQtyC;
  final TextEditingController qtyPerSellUnitC;
  final TextEditingController minOrderQty;
  final TextEditingController measurementC;
  final TextEditingController dimensionC;
  final TextEditingController weightPerSellUnitC;
  final TextEditingController weightPerUnitItemC;
  final TextEditingController reorderLevelC;
  final TextEditingController skuC;
  final bool isViewInventoryInformation;
  final VoidCallback onToggleInventoryInfo;
  final File? coverImageFile;
  final List<File> additionalImageFiles;
  final bool loadCoverImage;
  final bool loadAdditionalImages;
  final VoidCallback onPickCoverImage;
  final VoidCallback onPickAdditionalImage;
  final VoidCallback onRemoveCoverImage;
  final VoidCallback onRemoveAdditionalImage;
  final bool productHasVariant;
  final int? variantIndex;
  final Function(int)? onApplyToAllVariants;
  final bool isApplyToAllEnabled;
  final int? appliedFromVariant;
  final Function(int)? onRemoveAdditionalImageAt;
  final Function(String)? onUnitSelectionChanged;

  @override
  ConsumerState<InventoryInformationSection> createState() =>
      _InventoryInformationSectionState();
}

class _InventoryInformationSectionState
    extends ConsumerState<InventoryInformationSection> {
  String? selectedSellingUnit;
  String? selectedSubUnit;
  SubOption? selectedSubOption;

  @override
  void initState() {
    super.initState();
    // Initialize selected unit from controller if it has a value
    if (widget.sellingUnitC.text.isNotEmpty) {
      selectedSubUnit = widget.sellingUnitC.text;
    }
  }

  // String? selectedMeasuremrntUnit;
  // String? selectedSubMeasurementUnit;
  // SubOption? selectedMeasureSubOption;

  void _showSubUnitModal(BuildContext context, MeasurementCategory unit) {
    ModalWrapper.bottomSheet(
      context: context,
      widget: UnitModal(
        title: unit.name,
        options: unit.subOptions
            .map(
              (subUnit) => UnitModalOption(
                title: subUnit.label,
                desc: subUnit.description,
                showTrailing: false,
                onTap: () {
                  Navigator.pop(context);
                  selectedSubOption = subUnit;
                  selectedSubUnit = subUnit.id;
                  widget.sellingUnitC.text = subUnit.label;

                  // Notify parent about unit selection change
                  if (widget.onUnitSelectionChanged != null) {
                    widget.onUnitSelectionChanged!(subUnit.label);
                  }

                  setState(() {});
                },
              ),
            )
            .toList(),
      ),
    );
  }

  // void _showMeasuresntSubUnitModal(
  //     BuildContext context, MeasurementCategory unit) {
  //   ModalWrapper.bottomSheet(
  //     context: context,
  //     widget: UnitModal(
  //       title: unit.name,
  //       options: unit.subOptions
  //           .map(
  //             (subUnit) => UnitModalOption(
  //               title: subUnit.label,
  //               desc: subUnit.description,
  //               showTrailing: false,
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 selectedMeasureSubOption = subUnit;
  //                 selectedSubMeasurementUnit = subUnit.id;
  //                 // measurementC.text = subUnit.label;
  //                 setState(() {});
  //               },
  //             ),
  //           )
  //           .toList(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Inventory FORM
        InkWell(
          onTap: widget.onToggleInventoryInfo,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "Inventory Information",
                  style: textTheme.text16?.medium,
                ),
              ),
              Icon(widget.isViewInventoryInformation
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down)
            ],
          ),
        ),
        HDivider(),
        if (widget.isViewInventoryInformation)
          AnimatedSize(
            duration: Duration(milliseconds: 300),
            child: !widget.isViewInventoryInformation
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
                      _buildInventoryFields(),
                      YBox(16),
                      _buildImageUploadSection(),
                      YBox(16),
                      // Show bulk apply checkbox only for variants
                      if (widget.productHasVariant &&
                          widget.variantIndex != null)
                        InkWell(
                          onTap: widget.isApplyToAllEnabled &&
                                  widget.onApplyToAllVariants != null
                              ? () {
                                  widget.onApplyToAllVariants!(
                                      widget.variantIndex!);
                                }
                              : null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomCheckbox(
                                isSelected: widget.appliedFromVariant ==
                                    widget.variantIndex,
                              ),
                              XBox(8),
                              Expanded(
                                child: Text(
                                  widget.appliedFromVariant ==
                                          widget.variantIndex
                                      ? "Inventory details applied to all variants"
                                      : "Apply inventory details to all variants",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.text14?.copyWith(
                                    color: widget.isApplyToAllEnabled
                                        ? null
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      YBox(16),
                    ],
                  ),
          ),
        YBox(16),
      ],
    );
  }

  Widget _buildInventoryFields() {
    return Column(
      children: [
        CustomTextField(
          controller: widget.sellingUnitC,
          labelText: 'Selling Units',
          hintText: 'Select unit type',
          showLabelHeader: true,
          readOnly: true,
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
                            selectedSubUnit = null;
                          });

                          // Show sub-unit modal if the selected unit has sub-units
                          if (unit.hasSubOptions) {
                            _showSubUnitModal(context, unit);
                          } else {
                            // If no sub-options, set the main unit as the selling unit
                            widget.sellingUnitC.text = unit.name;

                            // Notify parent about unit selection change
                            if (widget.onUnitSelectionChanged != null) {
                              widget.onUnitSelectionChanged!(unit.name);
                            }
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
          controller: widget.stockQtyC,
          labelText: 'Stock Quantity',
          hintText: 'Enter stock quantity',
          showLabelHeader: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          suffixIcon: SuffixBox(
            text: selectedSubUnit ?? "",
          ),
        ),
        YBox(16),
        CustomTextField(
          controller: widget.qtyPerSellUnitC,
          labelText: 'Quantity per Selling Unit',
          hintText: 'e.g 12 tiles per unit',
          showLabelHeader: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          suffixIcon: SuffixBox(
            text: selectedSubUnit ?? "",
          ),
        ),
        YBox(16),
        CustomTextField(
          controller: widget.minOrderQty,
          labelText: 'Minimum order quantity',
          hintText: 'Enter minimum quantity',
          showLabelHeader: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          suffixIcon: SuffixBox(
            text: selectedSubUnit ?? "",
          ),
        ),
        YBox(16),
        // CustomTextField(
        //   controller: widget.measurementC,
        //   labelText: 'Measurement',
        //   hintText: 'Select unit measurement',
        //   isRequired: false,
        //   showLabelHeader: true,
        //   showSuffixIcon: true,
        //   readOnly: true,
        //   onTap: () {
        //     ModalWrapper.bottomSheet(
        //       context: context,
        //       widget: UnitModal(
        //         title: "Measurement Units",
        //         options: measuringUnits
        //             .map(
        //               (unit) => UnitModalOption(
        //                 title: unit.name,
        //                 example: unit.example,
        //                 onTap: () {
        //                   Navigator.pop(context);
        //                   setState(() {
        //                     selectedMeasuremrntUnit = unit.name;
        //                     selectedSubMeasurementUnit = null;
        //                   });

        //                   // Show sub-unit modal if the selected unit has sub-units
        //                   if (unit.hasSubOptions) {
        //                     _showMeasuresntSubUnitModal(context, unit);
        //                   }
        //                 },
        //               ),
        //             )
        //             .toList(),
        //       ),
        //     );
        //   },
        // ),
        YBox(16),
        CustomTextField(
          controller: widget.dimensionC,
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
          controller: widget.weightPerSellUnitC,
          labelText: 'Weight per Selling Unit',
          hintText: 'Enter value',
          showLabelHeader: true,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          suffixIcon: SuffixBox(
            text: "kg",
          ),
        ),
        YBox(16),
        CustomTextField(
          controller: widget.weightPerUnitItemC,
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
          controller: widget.reorderLevelC,
          labelText: 'Re-order Level',
          hintText: 'Enter value',
          showLabelHeader: true,
          isRequired: false,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          suffixIcon: SuffixBox(
            text: selectedSubUnit ?? "",
          ),
        ),
        YBox(16),
        CustomTextField(
          controller: widget.skuC,
          labelText: 'Store Keeping Unit (SKU)',
          hintText: 'Enter value',
          showLabelHeader: true,
          isRequired: false,
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DottedUpload(
          label: "Cover Image",
          isUploading: widget.loadCoverImage,
          onTap: widget.onPickCoverImage,
        ),
        YBox(16),
        if (widget.coverImageFile != null) ...[
          YBox(8),
          _buildImagePreview(
            widget.coverImageFile!,
            widget.onRemoveCoverImage,
          ),
        ],
        YBox(16),
        DottedUpload(
          label: "Other images:",
          isUploading: widget.loadAdditionalImages,
          isCoverImage: false,
          onTap: widget.onPickAdditionalImage,
        ),
        YBox(16),
        if (widget.additionalImageFiles.isNotEmpty) ...[
          YBox(8),
          _buildMultipleImagePreviews(),
        ],
      ],
    );
  }

  Widget _buildImagePreview(File imageFile, VoidCallback onRemove) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: IconButton(
            onPressed: onRemove,
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
    );
  }

  Widget _buildMultipleImagePreviews() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.additionalImageFiles.asMap().entries.map((entry) {
        final index = entry.key;
        final imageFile = entry.value;
        return Stack(
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: -8,
              right: -8,
              child: IconButton(
                onPressed: () {
                  if (widget.onRemoveAdditionalImageAt != null) {
                    widget.onRemoveAdditionalImageAt!(index);
                  } else {
                    // Fallback to remove all if specific index removal not available
                    widget.onRemoveAdditionalImage();
                  }
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
        );
      }).toList(),
    );
  }
}
