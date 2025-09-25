import 'dart:io';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

// Import the new component files
import 'components/common_attributes_section.dart';
import 'components/inventory_information_section.dart';
import 'components/multiple_variants_section.dart';
import 'components/pricing_information_section.dart';
import 'components/product_attributes_section.dart';

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
  // Controllers for single product (when no variants)
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

  // Controllers for each variant's inventory and pricing
  // Map<variantIndex, Map<fieldName, controller>>
  Map<int, Map<String, TextEditingController>> variantInventoryControllers = {};
  Map<int, Map<String, TextEditingController>> variantPricingControllers = {};

  // Controllers for common attributes to maintain state
  List<TextEditingController> attributeControllers = [];

  // Controllers for variant-specific attributes
  // Map<variantIndex, Map<attributeIndex, controller>>
  Map<int, List<TextEditingController>> variantAttributeControllers = {};

  bool isViewInventoryInformation = false;
  bool isViewPricingInformation = false;
  List<bool> isViewVariantInfo = []; // Track each variant's visibility state
  List<bool> isViewVariantInventoryInfo =
      []; // Track each variant's inventory visibility
  List<bool> isViewVariantPricingInfo =
      []; // Track each variant's pricing visibility
  bool productHasVariant = false;

  // If productHasVariant is set to true
  // int numOfVariants = 1;
  // List<ProductAttributeModel> selectedVariantList = [];
  ConfigureVariantArg? _configureVariantArg;

  // Cover image (for single product)
  File? _coverImageFile;
  String? _coverImageUrl;

  // Additional product images (for single product)
  File? _additionalImageFile;
  String? _additionalImageUrl;

  // Images for each variant
  // Map<variantIndex, Map<imageType, File>>
  Map<int, Map<String, File?>> variantImages = {};
  Map<int, Map<String, String?>> variantImageUrls = {};

  // load state (for single product)
  bool loadCoverImage = false;
  bool loadAdditionalImages = false;

  // Load states for each variant
  // Map<variantIndex, Map<imageType, bool>>
  Map<int, Map<String, bool>> variantImageLoadStates = {};

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

  // Method to ensure variant controllers for each variant
  void _ensureVariantControllers() {
    if (_configureVariantArg == null) return;

    final numVariants = _configureVariantArg!.numOfVariants;
    final selectedVariantList = _configureVariantArg!.selectedVariantList;

    // Ensure we have the right number of variant visibility states
    _ensureListLength(isViewVariantInfo, numVariants, false);
    _ensureListLength(isViewVariantInventoryInfo, numVariants, false);
    _ensureListLength(isViewVariantPricingInfo, numVariants, false);

    // Ensure we have controllers for each variant's attributes
    for (int variantIndex = 0; variantIndex < numVariants; variantIndex++) {
      _ensureVariantAttributeControllers(
          variantIndex, selectedVariantList.length);
      _ensureVariantInventoryControllers(variantIndex);
      _ensureVariantPricingControllers(variantIndex);
      _ensureVariantImageStates(variantIndex);
    }

    // Remove controllers for variants that no longer exist
    _cleanupExcessVariants(numVariants);
  }

  void _ensureListLength<T>(List<T> list, int requiredLength, T defaultValue) {
    while (list.length < requiredLength) {
      list.add(defaultValue);
    }
    while (list.length > requiredLength) {
      list.removeLast();
    }
  }

  void _ensureVariantAttributeControllers(int variantIndex, int requiredCount) {
    if (!variantAttributeControllers.containsKey(variantIndex)) {
      variantAttributeControllers[variantIndex] = [];
    }

    final controllers = variantAttributeControllers[variantIndex]!;

    while (controllers.length < requiredCount) {
      controllers.add(TextEditingController());
    }

    while (controllers.length > requiredCount) {
      final controller = controllers.removeLast();
      controller.dispose();
    }
  }

  void _ensureVariantInventoryControllers(int variantIndex) {
    if (!variantInventoryControllers.containsKey(variantIndex)) {
      variantInventoryControllers[variantIndex] = {
        'sellingUnit': TextEditingController(),
        'stockQty': TextEditingController(),
        'qtyPerSellUnit': TextEditingController(),
        'minOrderQty': TextEditingController(),
        'measurement': TextEditingController(),
        'dimension': TextEditingController(),
        'weightPerSellUnit': TextEditingController(),
        'weightPerUnitItem': TextEditingController(),
        'reorderLevel': TextEditingController(),
        'sku': TextEditingController(),
      };
    }
  }

  void _ensureVariantPricingControllers(int variantIndex) {
    if (!variantPricingControllers.containsKey(variantIndex)) {
      variantPricingControllers[variantIndex] = {
        'costPricePerUnit': TextEditingController(),
        'sellingPricePerUnit': TextEditingController(),
        'discountPrice': TextEditingController(),
      };
    }
  }

  void _ensureVariantImageStates(int variantIndex) {
    if (!variantImages.containsKey(variantIndex)) {
      variantImages[variantIndex] = {
        'cover': null,
        'additional': null,
      };
    }
    if (!variantImageUrls.containsKey(variantIndex)) {
      variantImageUrls[variantIndex] = {
        'cover': null,
        'additional': null,
      };
    }
    if (!variantImageLoadStates.containsKey(variantIndex)) {
      variantImageLoadStates[variantIndex] = {
        'cover': false,
        'additional': false,
      };
    }
  }

  void _cleanupExcessVariants(int numVariants) {
    final keysToRemove = variantAttributeControllers.keys
        .where((key) => key >= numVariants)
        .toList();

    for (final key in keysToRemove) {
      // Dispose attribute controllers
      for (final controller in variantAttributeControllers[key]!) {
        controller.dispose();
      }
      variantAttributeControllers.remove(key);

      // Dispose inventory controllers
      if (variantInventoryControllers.containsKey(key)) {
        for (final controller in variantInventoryControllers[key]!.values) {
          controller.dispose();
        }
        variantInventoryControllers.remove(key);
      }

      // Dispose pricing controllers
      if (variantPricingControllers.containsKey(key)) {
        for (final controller in variantPricingControllers[key]!.values) {
          controller.dispose();
        }
        variantPricingControllers.remove(key);
      }

      // Clean up image states
      variantImages.remove(key);
      variantImageUrls.remove(key);
      variantImageLoadStates.remove(key);
    }
  }

  // Image handling methods for variants
  void _pickVariantCoverImage(int variantIndex) async {
    setState(() {
      variantImageLoadStates[variantIndex]?['cover'] = true;
    });

    try {
      // Reset progress tracking for any previous uploads
      ref.read(fileUploadVm).resetProgress();

      final pickedFile = await ImageAndDocUtils.pickImage(enableCropping: true);

      if (pickedFile != null) {
        variantImages[variantIndex]?['cover'] = File(pickedFile.path);
        setState(() {});
      }

      final imageFile = variantImages[variantIndex]?['cover'];
      if (imageFile != null) {
        final r = await ref.read(fileUploadVm).uploadFile(file: [imageFile]);
        if (r.success && r.data != null && r.data!.isNotEmpty) {
          printty(
              "variant $variantIndex cover upload complete ${r.data!.first.url}");
          variantImageUrls[variantIndex]?['cover'] = r.data!.first.url;
        }
      }
    } catch (e) {
      showWarningToast(e.toString());
    } finally {
      setState(() {
        variantImageLoadStates[variantIndex]?['cover'] = false;
      });
    }
  }

  void _pickVariantAdditionalImage(int variantIndex) async {
    setState(() {
      variantImageLoadStates[variantIndex]?['additional'] = true;
    });

    try {
      // Reset progress tracking for any previous uploads
      ref.read(fileUploadVm).resetProgress();

      final pickedFile = await ImageAndDocUtils.pickImage(enableCropping: true);

      if (pickedFile != null) {
        variantImages[variantIndex]?['additional'] = File(pickedFile.path);
        setState(() {});
      }

      final imageFile = variantImages[variantIndex]?['additional'];
      if (imageFile != null) {
        final r = await ref.read(fileUploadVm).uploadFile(file: [imageFile]);
        if (r.success && r.data != null && r.data!.isNotEmpty) {
          printty(
              "variant $variantIndex additional upload complete ${r.data!.first.url}");
          variantImageUrls[variantIndex]?['additional'] = r.data!.first.url;
        }
      }
    } catch (e) {
      showWarningToast(e.toString());
    } finally {
      setState(() {
        variantImageLoadStates[variantIndex]?['additional'] = false;
      });
    }
  }

  void _removeVariantCoverImage(int variantIndex) {
    setState(() {
      variantImages[variantIndex]?['cover'] = null;
      variantImageUrls[variantIndex]?['cover'] = null;
    });
  }

  void _removeVariantAdditionalImage(int variantIndex) {
    setState(() {
      variantImages[variantIndex]?['additional'] = null;
      variantImageUrls[variantIndex]?['additional'] = null;
    });
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

    // Dispose variant attribute controllers
    for (var variantControllers in variantAttributeControllers.values) {
      for (var controller in variantControllers) {
        controller.dispose();
      }
    }
    variantAttributeControllers.clear();

    // Dispose variant inventory controllers
    for (var variantControllers in variantInventoryControllers.values) {
      for (var controller in variantControllers.values) {
        controller.dispose();
      }
    }
    variantInventoryControllers.clear();

    // Dispose variant pricing controllers
    for (var variantControllers in variantPricingControllers.values) {
      for (var controller in variantControllers.values) {
        controller.dispose();
      }
    }
    variantPricingControllers.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.only(
        left: Sizer.width(16),
        right: Sizer.width(16),
        bottom: Sizer.height(50),
      ),
      children: [
        YBox(16),
        ProductAttributesSection(
          attributeControllers: attributeControllers,
          productHasVariant: productHasVariant,
          onProductHasVariantChanged: (value) {
            productHasVariant = value;
            setState(() {});
          },
          configureVariantArg: _configureVariantArg,
          onConfigureVariantChanged: (arg) {
            _configureVariantArg = arg;
            _ensureVariantControllers();
            setState(() {});
          },
          onEnsureControllers: _ensureControllers,
        ),
        YBox(16),
        CommonAttributesSection(
          attributeControllers: attributeControllers,
          productHasVariant: productHasVariant,
          configureVariantArg: _configureVariantArg,
          onConfigureVariantChanged: (arg) {
            _configureVariantArg = arg;
            _ensureVariantControllers();
            setState(() {});
          },
          onEnsureControllers: _ensureControllers,
        ),
        YBox(16),

        // Variant Container
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show multiple variants if configured
            if (_configureVariantArg != null && productHasVariant)
              MultipleVariantsSection(
                configureVariantArg: _configureVariantArg,
                variantAttributeControllers: variantAttributeControllers,
                variantInventoryControllers: variantInventoryControllers,
                variantPricingControllers: variantPricingControllers,
                isViewVariantInfo: isViewVariantInfo,
                isViewVariantInventoryInfo: isViewVariantInventoryInfo,
                isViewVariantPricingInfo: isViewVariantPricingInfo,
                variantImages: variantImages,
                variantImageLoadStates: variantImageLoadStates,
                onToggleVariantInfo: (variantIndex) {
                  if (variantIndex < isViewVariantInfo.length) {
                    isViewVariantInfo[variantIndex] =
                        !isViewVariantInfo[variantIndex];
                    setState(() {});
                  }
                },
                onToggleVariantInventoryInfo: (variantIndex) {
                  if (variantIndex < isViewVariantInventoryInfo.length) {
                    isViewVariantInventoryInfo[variantIndex] =
                        !isViewVariantInventoryInfo[variantIndex];
                    setState(() {});
                  }
                },
                onToggleVariantPricingInfo: (variantIndex) {
                  if (variantIndex < isViewVariantPricingInfo.length) {
                    isViewVariantPricingInfo[variantIndex] =
                        !isViewVariantPricingInfo[variantIndex];
                    setState(() {});
                  }
                },
                onEnsureVariantControllers: _ensureVariantControllers,
                onPickVariantCoverImage: _pickVariantCoverImage,
                onPickVariantAdditionalImage: _pickVariantAdditionalImage,
                onRemoveVariantCoverImage: _removeVariantCoverImage,
                onRemoveVariantAdditionalImage: _removeVariantAdditionalImage,
              ),
            // else
            //   // Show single variant section if no variants configured
            //   VariantInfoSection(
            //     attributeControllers: attributeControllers,
            //     isViewVariantInfo:
            //         isViewVariantInfo.isNotEmpty ? isViewVariantInfo[0] : false,
            //     onToggleVariantInfo: () {
            //       if (isViewVariantInfo.isEmpty) {
            //         isViewVariantInfo.add(false);
            //       }
            //       isViewVariantInfo[0] = !isViewVariantInfo[0];
            //       setState(() {});
            //     },
            //     onEnsureControllers: _ensureControllers,
            //   ),

            // Show inventory and pricing sections only when no variants are configured
            if (!productHasVariant) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.neutral1,
                  borderRadius: BorderRadius.circular(Sizer.radius(6)),
                ),
                child: Column(
                  children: [
                    InventoryInformationSection(
                      sellingUnitC: sellingUnitC,
                      stockQtyC: stockQtyC,
                      qtyPerSellUnitC: qtyPerSellUnitC,
                      minOrderQty: minOrderQty,
                      measurementC: measurementC,
                      dimensionC: dimensionC,
                      weightPerSellUnitC: weightPerSellUnitC,
                      weightPerUnitItemC: weightPerUnitItemC,
                      reorderLevelC: reorderLevelC,
                      skuC: skuC,
                      isViewInventoryInformation: isViewInventoryInformation,
                      onToggleInventoryInfo: () {
                        isViewInventoryInformation =
                            !isViewInventoryInformation;
                        setState(() {});
                      },
                      coverImageFile: _coverImageFile,
                      additionalImageFile: _additionalImageFile,
                      loadCoverImage: loadCoverImage,
                      loadAdditionalImages: loadAdditionalImages,
                      onPickCoverImage: _pickCoverImage,
                      onPickAdditionalImage: _pickAdditionalImage,
                      onRemoveCoverImage: () {
                        setState(() {
                          _coverImageFile = null;
                          _coverImageUrl = null;
                        });
                      },
                      onRemoveAdditionalImage: () {
                        setState(() {
                          _additionalImageFile = null;
                          _additionalImageUrl = null;
                        });
                      },
                    ),
                    PricingInformationSection(
                      costPricePerUnitC: costPricePerUnitC,
                      sellingPricePerUnitC: sellingPricePerUnitC,
                      discountPriceC: discountPriceC,
                      isViewPricingInformation: isViewPricingInformation,
                      onTogglePricingInfo: () {
                        setState(() {
                          isViewPricingInformation = !isViewPricingInformation;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
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

      if (productHasVariant && _configureVariantArg != null) {
        // Handle variant-based product submission
        _handleVariantSubmission(productInventoryVm);
      } else {
        if (!productHasVariant) {
          // Handle single product submission
          _handleSingleProductSubmission(productInventoryVm);
        } else {
          showWarningToast('Please configure at least one variant.');
        }
      }
    } catch (e) {
      showWarningToast('Error processing form data: ${e.toString()}');
    }
  }

  void _handleVariantSubmission(ProductInventoryVm productInventoryVm) {
    final currentParams = productInventoryVm.variationParams;
    final numVariants = _configureVariantArg!.numOfVariants;
    final selectedVariantList = _configureVariantArg!.selectedVariantList;

    // Create media object for the main product
    final media = ProductVarientMedia(
      productSpecification: _coverImageUrl ?? '',
      productAdditionalDocument: _additionalImageUrl ?? '',
    );

    // Collect common attributes (excluding variant attributes)
    final variantAttributeIds =
        selectedVariantList.map((attr) => attr.id).toSet();
    final commonAttributes = productInventoryVm.selectedAttributeList
        .where((attr) => !variantAttributeIds.contains(attr.id))
        .toList();

    final commonAttributeMap = <String, List<String>>{};
    for (int i = 0;
        i < commonAttributes.length && i < attributeControllers.length;
        i++) {
      final attribute = commonAttributes[i];
      final value = attributeControllers[i].text.trim();
      if (value.isNotEmpty) {
        commonAttributeMap[attribute.attribute ?? ''] = [value];
      }
    }

    // Create variants list
    final variants = <Variant>[];
    for (int variantIndex = 0; variantIndex < numVariants; variantIndex++) {
      final variant = _createVariantFromIndex(
          variantIndex, selectedVariantList, commonAttributeMap);
      if (variant != null) {
        variants.add(variant);
      }
    }

    if (variants.isEmpty) {
      showWarningToast(
          'Please configure at least one variant with complete information.');
      return;
    }

    // Update variation params
    final updatedParams = currentParams?.copyWith(
          media: media,
          variants: variants,
        ) ??
        ProductVariationParams(
          media: media,
          variants: variants,
        );

    // Set the variation params
    productInventoryVm.setVariationParams(updatedParams);

    // Navigate to next tab
    widget.onNext?.call();
  }

  void _handleSingleProductSubmission(ProductInventoryVm productInventoryVm) {
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
      sellingUnit:
          sellingUnitC.text.trim().isEmpty ? 'piece' : sellingUnitC.text.trim(),
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
  }

  Variant? _createVariantFromIndex(
    int variantIndex,
    List<ProductAttributeModel> selectedVariantList,
    Map<String, List<String>> commonAttributeMap,
  ) {
    final inventoryControllers = variantInventoryControllers[variantIndex];
    final pricingControllers = variantPricingControllers[variantIndex];
    final attributeControllers = variantAttributeControllers[variantIndex];
    final imageUrls = variantImageUrls[variantIndex];

    if (inventoryControllers == null ||
        pricingControllers == null ||
        attributeControllers == null ||
        imageUrls == null) {
      return null;
    }

    // Collect variant-specific attributes
    final variantAttributeMap =
        Map<String, List<String>>.from(commonAttributeMap);

    for (int i = 0;
        i < selectedVariantList.length && i < attributeControllers.length;
        i++) {
      final attribute = selectedVariantList[i];
      final value = attributeControllers[i].text.trim();
      if (value.isNotEmpty) {
        variantAttributeMap[attribute.attribute ?? ''] = [value];
      }
    }

    final variantMetadata = VariantMetadata(attributes: variantAttributeMap);

    // Create variant media
    final variantMedia = VariantMedia(
      coverImageUrl: imageUrls['cover'] ?? '',
      productImageUrl: imageUrls['additional'] ?? '',
    );

    // Parse numeric values with defaults
    final costPrice = int.tryParse(
            pricingControllers['costPricePerUnit']?.text.trim() ?? '') ??
        0;
    final sellingPrice = int.tryParse(
            pricingControllers['sellingPricePerUnit']?.text.trim() ?? '') ??
        0;
    final discountPrice =
        int.tryParse(pricingControllers['discountPrice']?.text.trim() ?? '') ??
            sellingPrice;
    final stockQuantity =
        int.tryParse(inventoryControllers['stockQty']?.text.trim() ?? '') ?? 0;
    final qtyPerSellingUnit = int.tryParse(
            inventoryControllers['qtyPerSellUnit']?.text.trim() ?? '') ??
        1;
    final minOrderQuantity =
        int.tryParse(inventoryControllers['minOrderQty']?.text.trim() ?? '') ??
            1;
    final reorderLevel =
        int.tryParse(inventoryControllers['reorderLevel']?.text.trim() ?? '') ??
            0;

    // Create unit values with defaults
    final physicalMeasurement = UnitValue(
      unit: 'cm',
      value: int.tryParse(
              inventoryControllers['measurement']?.text.trim() ?? '') ??
          0,
    );

    final physicalDimension = UnitValue(
      unit: 'cm',
      value:
          int.tryParse(inventoryControllers['dimension']?.text.trim() ?? '') ??
              0,
    );

    final weightPerUnitItem = UnitValue(
      unit: 'kg',
      value: int.tryParse(
              inventoryControllers['weightPerUnitItem']?.text.trim() ?? '') ??
          0,
    );

    final weight = UnitValue(
      unit: 'kg',
      value: int.tryParse(
              inventoryControllers['weightPerSellUnit']?.text.trim() ?? '') ??
          0,
    );

    // Create variant
    return Variant(
      sku: inventoryControllers['sku']?.text.trim().isEmpty == true
          ? 'SKU-${DateTime.now().millisecondsSinceEpoch}-$variantIndex'
          : inventoryControllers['sku']?.text.trim() ??
              'SKU-${DateTime.now().millisecondsSinceEpoch}-$variantIndex',
      physicalMeasurementUnit: physicalMeasurement,
      physicalDimension: physicalDimension,
      weightPerUnitItem: weightPerUnitItem,
      media: variantMedia,
      quantityPerSellingUnit: qtyPerSellingUnit,
      weight: weight,
      sellingUnit:
          inventoryControllers['sellingUnit']?.text.trim().isEmpty == true
              ? 'piece'
              : inventoryControllers['sellingUnit']?.text.trim() ?? 'piece',
      unitRetailPrice: sellingPrice,
      unitCostPrice: costPrice,
      currentPrice: discountPrice,
      reorderValue: reorderLevel,
      minimumOrderQuantity: minOrderQuantity,
      quantity: stockQuantity,
      metadata: variantMetadata,
    );
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
