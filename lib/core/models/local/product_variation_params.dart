class ProductVariationParams {
  final String? productCreationFormat;
  final String? name;
  final String? code;
  final String? categoryId;
  final String? subcategoryId;
  final String? productTypeId;
  final String? brand;
  final String? description;
  final String? tags;
  final List<String>? shippingClasses;
  final ProductVarientMedia? media;
  final List<Variant>? variants;

  ProductVariationParams({
    this.productCreationFormat,
    this.name,
    this.code,
    this.categoryId,
    this.subcategoryId,
    this.productTypeId,
    this.brand,
    this.description,
    this.tags,
    this.shippingClasses,
    this.media,
    this.variants,
  });

  factory ProductVariationParams.fromJson(Map<String, dynamic> json) =>
      ProductVariationParams(
        productCreationFormat: json['product_creation_format'],
        name: json['name'],
        code: json['code'],
        categoryId: json['category_id'],
        subcategoryId: json['subcategory_id'],
        productTypeId: json['product_type_id'],
        brand: json['brand'],
        description: json['description'],
        tags: json['tags'],
        shippingClasses: List<String>.from(json['shipping_classes']),
        media: ProductVarientMedia.fromJson(json['media']),
        variants:
            (json['variants'] as List).map((v) => Variant.fromJson(v)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'product_creation_format': productCreationFormat,
        'name': name,
        'code': code,
        'category_id': categoryId,
        'subcategory_id': subcategoryId,
        'product_type_id': productTypeId,
        'brand': brand,
        'description': description,
        'tags': tags,
        'shipping_classes': shippingClasses,
        'media': media?.toJson(),
        'variants': variants?.map((v) => v.toJson()).toList(),
      };

  ProductVariationParams copyWith({
    String? productCreationFormat,
    String? name,
    String? code,
    String? categoryId,
    String? subcategoryId,
    String? productTypeId,
    String? brand,
    String? description,
    String? tags,
    List<String>? shippingClasses,
    ProductVarientMedia? media,
    List<Variant>? variants,
  }) {
    return ProductVariationParams(
      productCreationFormat:
          productCreationFormat ?? this.productCreationFormat,
      name: name ?? this.name,
      code: code ?? this.code,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      productTypeId: productTypeId ?? this.productTypeId,
      brand: brand ?? this.brand,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      shippingClasses: shippingClasses ?? this.shippingClasses,
      media: media ?? this.media,
      variants: variants ?? this.variants,
    );
  }
}

class ProductVarientMedia {
  final String productSpecification;
  final String productAdditionalDocument;

  ProductVarientMedia({
    required this.productSpecification,
    required this.productAdditionalDocument,
  });

  factory ProductVarientMedia.fromJson(Map<String, dynamic> json) =>
      ProductVarientMedia(
        productSpecification: json['product_specification'],
        productAdditionalDocument: json['product_additional_document'],
      );

  Map<String, dynamic> toJson() => {
        'product_specification': productSpecification,
        'product_additional_document': productAdditionalDocument,
      };

  ProductVarientMedia copyWith({
    String? productSpecification,
    String? productAdditionalDocument,
  }) {
    return ProductVarientMedia(
      productSpecification: productSpecification ?? this.productSpecification,
      productAdditionalDocument:
          productAdditionalDocument ?? this.productAdditionalDocument,
    );
  }
}

class Variant {
  final String sku;
  final UnitValue physicalMeasurementUnit;
  final UnitValue physicalDimension;
  final UnitValue weightPerUnitItem;
  final VariantMedia media;
  final int quantityPerSellingUnit;
  final UnitValue weight;
  final String sellingUnit;
  final int unitRetailPrice;
  final int unitCostPrice;
  final int currentPrice;
  final int reorderValue;
  final int minimumOrderQuantity;
  final int quantity;
  final VariantMetadata metadata;

  Variant({
    required this.sku,
    required this.physicalMeasurementUnit,
    required this.physicalDimension,
    required this.weightPerUnitItem,
    required this.media,
    required this.quantityPerSellingUnit,
    required this.weight,
    required this.sellingUnit,
    required this.unitRetailPrice,
    required this.unitCostPrice,
    required this.currentPrice,
    required this.reorderValue,
    required this.minimumOrderQuantity,
    required this.quantity,
    required this.metadata,
  });

  factory Variant.fromJson(Map<String, dynamic> json) => Variant(
        sku: json['SKU'],
        physicalMeasurementUnit:
            UnitValue.fromJson(json['physical_measurement_unit']),
        physicalDimension: UnitValue.fromJson(json['physical_dimension']),
        weightPerUnitItem: UnitValue.fromJson(json['weight_per_unit_item']),
        media: VariantMedia.fromJson(json['media']),
        quantityPerSellingUnit: json['quantity_per_selling_unit'],
        weight: UnitValue.fromJson(json['weight']),
        sellingUnit: json['selling_unit'],
        unitRetailPrice: json['unit_retail_price'],
        unitCostPrice: json['unit_cost_price'],
        currentPrice: json['current_price'],
        reorderValue: json['reorder_value'],
        minimumOrderQuantity: json['minimum_order_quantity'],
        quantity: json['quantity'],
        metadata: VariantMetadata.fromJson(json['metadata']),
      );

  Map<String, dynamic> toJson() => {
        'SKU': sku,
        'physical_measurement_unit': physicalMeasurementUnit.toJson(),
        'physical_dimension': physicalDimension.toJson(),
        'weight_per_unit_item': weightPerUnitItem.toJson(),
        'media': media.toJson(),
        'quantity_per_selling_unit': quantityPerSellingUnit,
        'weight': weight.toJson(),
        'selling_unit': sellingUnit,
        'unit_retail_price': unitRetailPrice,
        'unit_cost_price': unitCostPrice,
        'current_price': currentPrice,
        'reorder_value': reorderValue,
        'minimum_order_quantity': minimumOrderQuantity,
        'quantity': quantity,
        'metadata': metadata.toJson(),
      };

  Variant copyWith({
    String? sku,
    UnitValue? physicalMeasurementUnit,
    UnitValue? physicalDimension,
    UnitValue? weightPerUnitItem,
    VariantMedia? media,
    int? quantityPerSellingUnit,
    UnitValue? weight,
    String? sellingUnit,
    int? unitRetailPrice,
    int? unitCostPrice,
    int? currentPrice,
    int? reorderValue,
    int? minimumOrderQuantity,
    int? quantity,
    VariantMetadata? metadata,
  }) {
    return Variant(
      sku: sku ?? this.sku,
      physicalMeasurementUnit:
          physicalMeasurementUnit ?? this.physicalMeasurementUnit,
      physicalDimension: physicalDimension ?? this.physicalDimension,
      weightPerUnitItem: weightPerUnitItem ?? this.weightPerUnitItem,
      media: media ?? this.media,
      quantityPerSellingUnit:
          quantityPerSellingUnit ?? this.quantityPerSellingUnit,
      weight: weight ?? this.weight,
      sellingUnit: sellingUnit ?? this.sellingUnit,
      unitRetailPrice: unitRetailPrice ?? this.unitRetailPrice,
      unitCostPrice: unitCostPrice ?? this.unitCostPrice,
      currentPrice: currentPrice ?? this.currentPrice,
      reorderValue: reorderValue ?? this.reorderValue,
      minimumOrderQuantity: minimumOrderQuantity ?? this.minimumOrderQuantity,
      quantity: quantity ?? this.quantity,
      metadata: metadata ?? this.metadata,
    );
  }
}

class UnitValue {
  final String unit;
  final int value;

  UnitValue({required this.unit, required this.value});

  factory UnitValue.fromJson(Map<String, dynamic> json) => UnitValue(
        unit: json['unit'],
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'unit': unit,
        'value': value,
      };

  UnitValue copyWith({String? unit, int? value}) {
    return UnitValue(
      unit: unit ?? this.unit,
      value: value ?? this.value,
    );
  }
}

class VariantMedia {
  final String coverImageUrl;
  final String productImageUrl;

  VariantMedia({required this.coverImageUrl, required this.productImageUrl});

  factory VariantMedia.fromJson(Map<String, dynamic> json) => VariantMedia(
        coverImageUrl: json['cover_image_url'],
        productImageUrl: json['product_image_url'],
      );

  Map<String, dynamic> toJson() => {
        'cover_image_url': coverImageUrl,
        'product_image_url': productImageUrl,
      };

  VariantMedia copyWith({String? coverImageUrl, String? productImageUrl}) {
    return VariantMedia(
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      productImageUrl: productImageUrl ?? this.productImageUrl,
    );
  }
}

class VariantMetadata {
  final Map<String, List<String>> attributes;

  VariantMetadata({required this.attributes});

  factory VariantMetadata.fromJson(Map<String, dynamic> json) {
    final attributes = <String, List<String>>{};
    (json['attributes'] as Map<String, dynamic>).forEach((key, value) {
      attributes[key] = List<String>.from(value);
    });
    return VariantMetadata(attributes: attributes);
  }

  Map<String, dynamic> toJson() => {'attributes': attributes};

  VariantMetadata copyWith({Map<String, List<String>>? attributes}) {
    return VariantMetadata(
      attributes: attributes ?? this.attributes,
    );
  }
}
