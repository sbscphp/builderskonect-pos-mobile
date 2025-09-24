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

  // final productNameC = TextEditingController();
  // final brandC = TextEditingController();
  // final categoryC = TextEditingController();
  // final subCategoryC = TextEditingController();
  // final typeC = TextEditingController();
  // final tagsC = TextEditingController();
  // final descriptionC = TextEditingController();

  // BrandModel? selectedBrand;
  // CategoryModel? selectedCategory;
  // CategoryModel? selectedSubCategory;
  // CategoryModel? selectedCategoryType;

  // clearControllers() {
  //   productNameC.clear();
  //   brandC.clear();
  //   categoryC.clear();
  //   subCategoryC.clear();
  //   typeC.clear();
  //   tagsC.clear();
  //   descriptionC.clear();

  //   notifyListeners();
  // }

  List<ProductAttributeModel> productAttributes = [];
  List<ProductAttributeModel> selectedAttributeList = [];

  // Media handling fields
  String? coverImageUrl;
  // String? productImageUrl;
  List<String> additionalImageUrls = [];

  // Attribute values for variant generation
  Map<String, String> selectedAttributeValues = {};

  updateUI() {
    notifyListeners();
  }

  Future<ApiResponse> getProductAttributes(String catTypeId) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/inventory-attributes")
      ..addQueryParameterIfNotEmpty("paginate", '0')
      ..addQueryParameterIfNotEmpty("category_id", catTypeId.toString());

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

// //Inventory Form
//   final sellingUnitC = TextEditingController();
//   final stockQtyC = TextEditingController();
//   final qtyPerSellUnitC = TextEditingController();
//   final minOrderQty = TextEditingController();
//   final measurementC = TextEditingController();
//   final dimensionC = TextEditingController();
//   final weightPerSellUnitC = TextEditingController();
//   final weightPerUnitItemC = TextEditingController();
//   final reorderLevelC = TextEditingController();
//   final skuC = TextEditingController();
//   //pricing form
//   final costPricePerUnitC = TextEditingController();
//   final sellingPricePerUnitC = TextEditingController();
//   final discountPriceC = TextEditingController();

//   //shipping classification form
//   final shippingWeightTypeC = TextEditingController();
//   final shippingClassC = TextEditingController();

//   //parcel dimension form
//   final lengthC = TextEditingController();
//   final widthC = TextEditingController();
//   final heigthC = TextEditingController();

//   //parcel measurement var
//   String lengthUnit = '-';
//   String widthUnit = '-';
//   String heightUnit = '-';
  /// Holds the current product variation parameters
  ///
  ProductVariationParams? _variationParams;
  ProductVariationParams? get variationParams => _variationParams;
  void setVariationParams(ProductVariationParams? params) {
    if (params == null) {
      _variationParams = null;
      reBuildUI();
      return;
    }

    _variationParams = _variationParams?.copyWith(
          productCreationFormat: "multiple",
          name: params.name,
          code: params.code,
          categoryId: params.categoryId,
          subcategoryId: params.subcategoryId,
          productTypeId: params.productTypeId,
          brand: params.brand,
          description: params.description,
          tags: params.tags,
          shippingClasses: params.shippingClasses,
          media: params.media,
          variants: params.variants,
        ) ??
        params;

    reBuildUI();
  }

  Future<ApiResponse> createMultipleVariation() async {
    final body = _variationParams?.toJson();

    return await performApiCall(
      url: "/api/v1/merchants/inventory-products",
      method: apiService.postWithAuth,
      errorObjectName: createState,
      busyObjectName: createState,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  // Create individual variant data structure

  // Update attribute value
  void updateAttributeValue(String attributeName, String value) {
    selectedAttributeValues[attributeName] = value;
    notifyListeners();
  }
}

final productInventoryVmodel =
    ChangeNotifierProvider((ref) => ProductInventoryVm());
