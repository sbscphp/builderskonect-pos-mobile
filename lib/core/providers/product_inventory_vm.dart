import 'package:builders_konnect/core/core.dart';

class ProductInventoryVm extends BaseVm {
  //page number
  int pageNumber = 1;
  int? lastPage;

  InventoryProductModel? _inventoryProductModel;
  ProductStats? get productStats => _inventoryProductModel?.stats;
  List<ProductModel> _inventoryProducts = [];
  List<ProductModel> get inventoryProducts => _inventoryProducts;
  Future<ApiResponse> getInventoryProducts(
      {String? q,
      bool productReview = false,
      String? busyObjectName = getState,
      String? dateFilter,
      String? status}) async {
    if (busyObjectName != paginateState) {
      pageNumber = 1;
    }
    UriBuilder uriBuilder = UriBuilder(
        "/api/v1/merchants/inventory-products?page=$pageNumber")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("product_review", productReview.toString())
      ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '')
      ..addQueryParameterIfNotEmpty("status", status ?? '')
      ..addQueryParameterIfNotEmpty("limit", '50')
      ..addQueryParameterIfNotEmpty("paginate", '1');

    _inventoryProductModel = null;
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: busyObjectName,
      busyObjectName: busyObjectName,
      onSuccess: (data) {
        if (busyObjectName != paginateState) {
          _inventoryProductModel =
              inventoryProductModelFromJson(json.encode(data['data']));
          _inventoryProducts = _inventoryProductModel?.data?.data ?? [];
          pageNumber++;
          lastPage = _inventoryProductModel?.data?.lastPage;
        } else {
          _inventoryProductModel =
              inventoryProductModelFromJson(json.encode(data["data"]));
          _inventoryProducts.addAll(_inventoryProductModel?.data?.data ?? []);
          pageNumber++;
        }

        return apiResponse;
      },
    );
  }

  // View Product Inventory Details
  // ProductModel? _productDetails;
  // ProductModel? get productDetails => _productDetails;
  Future<ApiResponse<ProductModel>> viewProductInventory({
    required String productId,
  }) async {
    return await performApiCall<ProductModel>(
      url: "/api/v1/merchants/inventory-products/$productId",
      method: apiService.getWithAuth,
      errorObjectName: viewState,
      busyObjectName: viewState,
      onSuccess: (data) {
        final res = ProductModel.fromJson(data['data']);
        return ApiResponse(
          success: true,
          data: res,
        );
      },
    );
  }

  // Edit Inventory Level
  Future<ApiResponse> editInventoryLevel({
    required String productId,
    required String quantity,
    String? reOrderValue,
  }) async {
    final body = {
      "new_quantity": quantity,
      "reorder_value": reOrderValue,
    }..removeWhere((k, v) => v == null || v == "");
    return await performApiCall(
      url: "/api/v1/merchants/inventory-products/$productId/edit-quantity",
      method: apiService.putWithAuth,
      errorObjectName: updateState,
      busyObjectName: updateState,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  // Trigger reorder
  Future<ApiResponse> triggerReorder({
    required List<String> ids,
  }) async {
    final body = {"ids": ids};
    return await performApiCall(
      url: "/api/v1/merchants/inventory-products/trigger-reorder",
      method: apiService.postWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  // Delete Product
  Future<ApiResponse> deleteProduct({
    required String productId,
  }) async {
    return await performApiCall(
      url: "/api/v1/merchants/inventory-products/$productId",
      method: apiService.deleteWithAuth,
      errorObjectName: deleteState,
      busyObjectName: deleteState,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  // Create Product from Catalogue
  Future<ApiResponse> createProductFromCatalogue({
    required ProductCatalogueParams params,
  }) async {
    final body = params.toJson();

    return await performApiCall(
      url: "/api/v1/merchants/inventory-products",
      method: apiService.postWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

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

  clearControllers() {
    productNameC.clear();
    brandC.clear();
    categoryC.clear();
    subCategoryC.clear();
    typeC.clear();
    tagsC.clear();
    descriptionC.clear();

    notifyListeners();
  }

  List<ProductAttributeModel> productAttributes = [];
  List<ProductAttributeModel> selectedAttributeList = [];
  bool? hasVariant;

  updateUI() {
    notifyListeners();
  }

  Future<ApiResponse> getProductAttributes() async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/inventory-attributes")
      ..addQueryParameterIfNotEmpty("paginate", '0')
      ..addQueryParameterIfNotEmpty(
          "category_id", selectedCategoryType?.id ?? '');

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      onSuccess: (data) {
        productAttributes =
            productAttributeModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

//Inventory Form
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
  //pricing form
  final costPricePerUnitC = TextEditingController();
  final sellingPricePerUnitC = TextEditingController();
  final discountPriceC = TextEditingController();

  //shipping classification form
  final shippingWeightTypeC = TextEditingController();
  final shippingClassC = TextEditingController();

  //parcel dimension form
  final lengthC = TextEditingController();
  final widthC = TextEditingController();
  final heigthC = TextEditingController();

    //parcel measurement var
  String lengthUnit = '-';
  String widthUnit = '-';
  String heightUnit = '-';



  Future<ApiResponse> createMultipleVariation() async {
    final body = {
      "product_creation_format": "multiple",
      "name": productNameC.text,
      // "code": "{{$randomUUID}}",
      "category_id": selectedCategory?.id,
      "subcategory_id": selectedSubCategory?.id,
      "product_type_id": selectedCategoryType?.id,
      "brand": selectedBrand?.name,
      "description": descriptionC.text,
      "tags": tagsC.text,
      "shipping_classes": ["light", "hazardous"],
      "media": {"product_specification": "", "product_additional_document": ""},
      // "variants" : [
      //     {
      //         "SKU": "{{$randomUUID}}",
      //         "physical_measurement_unit": {
      //             "unit": "Area",
      //             "value": 13
      //         },
      //         "physical_dimension": {
      //             "unit": "Area",
      //             "value": 231
      //         },
      //         "weight_per_unit_item": {
      //             "unit": "kg",
      //             "value": 321
      //         },
      //         "media": {
      //             "cover_image_url": "{{$randomImageUrl}}",
      //             "product_image_url": "{{$randomImageUrl}}"
      //         },
      //         "quantity_per_selling_unit": 3,
      //         "weight": {
      //             "unit": "kg",
      //             "value": 321
      //         },
      //         "selling_unit": "Each",
      //         "unit_retail_price": 33500,
      //         "unit_cost_price": 30000,
      //         "current_price": 330000,
      //         "reorder_value": 2,
      //         "minimum_order_quantity": 3,
      //         "quantity": 15,
      //         "metadata": {
      //             "attributes": {
      //                 "Brand Tier": ["Local Brand"]
      //             }
      //         }
      //     },
      //     {
      //         "SKU": "{{$randomUUID}}",
      //         "physical_measurement_unit": {
      //             "unit": "Area",
      //             "value": 12
      //         },
      //         "physical_dimension": {
      //             "unit": "Area",
      //             "value": 21
      //         },
      //         "weight_per_unit_item": {
      //             "unit": "kg",
      //             "value": 301
      //         },
      //         "media": {
      //             "cover_image_url": "{{$randomImageUrl}}",
      //             "product_image_url": "{{$randomImageUrl}}"
      //         },
      //         "quantity_per_selling_unit": 3,
      //         "weight": {
      //             "unit": "kg",
      //             "value": 301
      //         },
      //         "selling_unit": "Piece",
      //         "unit_retail_price": 33500,
      //         "unit_cost_price": 30000,
      //         "current_price": 330000,
      //         "reorder_value": 2,
      //         "minimum_order_quantity": 3,
      //         "quantity": 15,
      //         "metadata": {
      //             "attributes": {
      //                 "Brand Tier": ["Local Brand"]
      //             }
      //         }
      //     }
      // ]
    };

    return await performApiCall(
      url: "/api/v1/merchants/inventory-products",
      method: apiService.postWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }
}

final productInventoryVmodel =
    ChangeNotifierProvider((ref) => ProductInventoryVm());
