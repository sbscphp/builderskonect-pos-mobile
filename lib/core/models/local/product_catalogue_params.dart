import '../network/catalogue_model.dart';

class ProductCatalogueParams {
  final String? productCreationFormat;
  final List<Product>? products;

  ProductCatalogueParams({
    this.productCreationFormat = "catalogue",
    this.products,
  });

  Map<String, dynamic> toJson() {
    return {
      "product_creation_format": productCreationFormat,
      "products": products?.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductCatalogueWithStatus {
  final CatalogueModel catalogueModel;
  final bool isComplete;
  final ProductFormData? formData;

  ProductCatalogueWithStatus({
    required this.catalogueModel,
    this.isComplete = false,
    this.formData,
  });

  ProductCatalogueWithStatus copyWith({
    CatalogueModel? catalogueModel,
    bool? isComplete,
    ProductFormData? formData,
  }) {
    return ProductCatalogueWithStatus(
      catalogueModel: catalogueModel ?? this.catalogueModel,
      isComplete: isComplete ?? this.isComplete,
      formData: formData ?? this.formData,
    );
  }

  // Transform to Product object for API call
  Product toProduct() {
    if (formData == null) {
      throw Exception('Product form data is required to create Product object');
    }

    return Product(
      name: catalogueModel.name,
      sellingUnit: formData!.sellingUnit,
      quantityPerSellingUnit: formData!.quantityPerSellingUnit?.toString(),
      minimumOrderQuantity: formData!.minimumOrderQuantity?.toString(),
      sku: formData!.sku,
      code: catalogueModel.code,
      unitCostPrice: formData!.costPrice,
      unitRetailPrice: formData!.sellingPrice,
      quantity: formData!.stockQuantity,
      reorderValue: formData!.reorderLevel,
      description: formData!.description,
      tags: formData!.tags,
      catalogueId: catalogueModel.id,
      currentPrice: formData!.discountPrice ?? formData!.sellingPrice,
      media: formData!.media,
    );
  }
}

class ProductFormData {
  final String? sellingUnit;
  final String? subUnit;
  final String? stockQuantity;
  final String? quantityPerSellingUnit;
  final String? minimumOrderQuantity;
  final String? weightPerSellingUnit;
  final String? reorderLevel;
  final String? costPrice;
  final String? sellingPrice;
  final String? discountPrice;
  final String? tags;
  final String? sku;
  final String? description;
  final InventoryMedia? media;

  ProductFormData({
    this.sellingUnit,
    this.subUnit,
    this.stockQuantity,
    this.quantityPerSellingUnit,
    this.minimumOrderQuantity,
    this.weightPerSellingUnit,
    this.reorderLevel,
    this.costPrice,
    this.sellingPrice,
    this.discountPrice,
    this.tags,
    this.sku,
    this.description,
    this.media,
  });

  ProductFormData copyWith({
    String? sellingUnit,
    String? subUnit,
    String? stockQuantity,
    String? quantityPerSellingUnit,
    String? minimumOrderQuantity,
    String? weightPerSellingUnit,
    String? reorderLevel,
    String? costPrice,
    String? sellingPrice,
    String? discountPrice,
    String? tags,
    String? sku,
    String? description,
    InventoryMedia? media,
  }) {
    return ProductFormData(
      sellingUnit: sellingUnit ?? this.sellingUnit,
      subUnit: subUnit ?? this.subUnit,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      quantityPerSellingUnit:
          quantityPerSellingUnit ?? this.quantityPerSellingUnit,
      minimumOrderQuantity: minimumOrderQuantity ?? this.minimumOrderQuantity,
      weightPerSellingUnit: weightPerSellingUnit ?? this.weightPerSellingUnit,
      reorderLevel: reorderLevel ?? this.reorderLevel,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      tags: tags ?? this.tags,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      media: media ?? this.media,
    );
  }

  // Validation method to check if all required fields are filled
  bool get isComplete {
    return sellingUnit != null &&
        sellingUnit!.isNotEmpty &&
        costPrice != null &&
        int.parse(costPrice!) > 0 &&
        sellingPrice != null &&
        int.parse(sellingPrice!) > 0 &&
        sku != null &&
        sku!.isNotEmpty;
  }
}

class Product {
  final String? name;
  final String? sellingUnit;
  final String? quantityPerSellingUnit;
  final String? minimumOrderQuantity;
  final String? sku;
  final String? code;
  final String? unitCostPrice;
  final String? unitRetailPrice;
  final String? quantity;
  final String? reorderValue;
  final String? description;
  final String? tags;
  final String? catalogueId;
  final String? currentPrice;
  final InventoryMedia? media;

  Product({
    this.name,
    this.sellingUnit,
    this.quantityPerSellingUnit,
    this.minimumOrderQuantity,
    this.sku,
    this.code,
    this.unitCostPrice,
    this.unitRetailPrice,
    this.quantity,
    this.reorderValue,
    this.description,
    this.tags,
    this.catalogueId,
    this.currentPrice,
    this.media,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "selling_unit": sellingUnit,
      "quantity_per_selling_unit": quantityPerSellingUnit,
      "minimum_order_quantity": minimumOrderQuantity,
      "SKU": sku,
      "code": code,
      "unit_cost_price": unitCostPrice,
      "unit_retail_price": unitRetailPrice,
      "quantity": quantity,
      "reorder_value": reorderValue,
      "description": description,
      "tags": tags,
      "catalogue_id": catalogueId,
      "current_price": currentPrice,
      "media": media?.toJson(),
    };
  }
}

class InventoryMedia {
  final String? coverImageUrl;
  final String? productImageUrl;

  InventoryMedia({
    this.coverImageUrl,
    this.productImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "cover_image_url": coverImageUrl,
      "product_image_url": productImageUrl,
    };
  }
}
