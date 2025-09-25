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
    required this.additionalImageFile,
    required this.loadCoverImage,
    required this.loadAdditionalImages,
    required this.onPickCoverImage,
    required this.onPickAdditionalImage,
    required this.onRemoveCoverImage,
    required this.onRemoveAdditionalImage,
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
  final File? additionalImageFile;
  final bool loadCoverImage;
  final bool loadAdditionalImages;
  final VoidCallback onPickCoverImage;
  final VoidCallback onPickAdditionalImage;
  final VoidCallback onRemoveCoverImage;
  final VoidCallback onRemoveAdditionalImage;

  @override
  ConsumerState<InventoryInformationSection> createState() =>
      _InventoryInformationSectionState();
}

class _InventoryInformationSectionState
    extends ConsumerState<InventoryInformationSection> {
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
        ),
        YBox(16),
        CustomTextField(
          controller: widget.measurementC,
          labelText: 'Measurement',
          hintText: 'Select unit measurement',
          isRequired: false,
          showLabelHeader: true,
          showSuffixIcon: true,
          readOnly: true,
        ),
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
        if (widget.additionalImageFile != null) ...[
          YBox(8),
          _buildImagePreview(
            widget.additionalImageFile!,
            widget.onRemoveAdditionalImage,
          ),
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
}
