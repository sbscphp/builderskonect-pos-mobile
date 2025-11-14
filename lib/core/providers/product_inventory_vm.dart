import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/core/models/network/promotion_fees_model.dart';
import 'package:builders_konnect/core/models/network/promotion_payment_breakdown_model.dart';
import 'package:builders_konnect/core/models/network/promotion_response.dart';

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
      ..addQueryParameterIfNotEmpty("limit", '10')
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

  InventoryProductModel? _dotdinventoryProductModel;
  ProductStats? get dotdproductStats => _dotdinventoryProductModel?.stats;
  List<ProductModel> _dotdinventoryProducts = [];
  List<ProductModel> get dotdinventoryProducts => _dotdinventoryProducts;
  Future<ApiResponse> getdotdProducts(
      {String? q,
      // bool productReview = false,
      String? busyObjectName = getState,
      String? dateFilter,
      String? status}) async {
    if (busyObjectName != paginateState) {
      pageNumber = 1;
    }
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/inventory-products?page=$pageNumber")
          ..addQueryParameterIfNotEmpty("q", q ?? '')
          ..addQueryParameterIfNotEmpty("collection", "deals of the day")
          ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '')
          ..addQueryParameterIfNotEmpty("status", status ?? '')
          ..addQueryParameterIfNotEmpty("limit", '50')
          ..addQueryParameterIfNotEmpty("paginate", '1');

    _dotdinventoryProductModel = null;
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: busyObjectName,
      busyObjectName: busyObjectName,
      onSuccess: (data) {
        if (busyObjectName != paginateState) {
          _dotdinventoryProductModel =
              inventoryProductModelFromJson(json.encode(data['data']));
          _dotdinventoryProducts = _dotdinventoryProductModel?.data?.data ?? [];
          pageNumber++;
          lastPage = _dotdinventoryProductModel?.data?.lastPage;
        } else {
          _dotdinventoryProductModel =
              inventoryProductModelFromJson(json.encode(data["data"]));
          _dotdinventoryProducts
              .addAll(_dotdinventoryProductModel?.data?.data ?? []);
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
    String? costPrice,
    String? retailPrice,
    String? currentPrice,
    String? minimumOrderQuantity,
  }) async {
    final body = {
      "new_quantity": quantity,
      "reorder_value": reOrderValue,
      "unit_cost_price": costPrice,
      "unit_retail_price": retailPrice,
      "current_price": currentPrice,
      "minimum_order_quantity": minimumOrderQuantity,
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

  List<ProductAttributeModel> _productAttributes = [];
  List<ProductAttributeModel> get productAttributes => _productAttributes;
  List<ProductAttributeModel> _selectedAttributeList = [];
  List<ProductAttributeModel> get selectedAttributeList =>
      _selectedAttributeList;
  setSelectedAttributeList(List<ProductAttributeModel> val) {
    _selectedAttributeList = val;
    reBuildUI();
  }

  Future<ApiResponse> getProductAttributes(String subCategoryId) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/inventory-attributes")
      ..addQueryParameterIfNotEmpty("paginate", '0')
      ..addQueryParameterIfNotEmpty("category_id", subCategoryId.toString())
      ..addQueryParameterIfNotEmpty(
          "show_general", "1") // Show general attributes
      ..addQueryParameterIfNotEmpty("scope", "children"); // parent or children

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      onSuccess: (data) {
        _productAttributes =
            productAttributeModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

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

  Future<ApiResponse> updateDiscountPrice(
      {required String discountPrice, required String productId}) async {
    final body = {"current_price": discountPrice};
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

  PromotionFeesResponse? _promotionFeesResponse;
  PromotionFeesResponse? get promotionFeesResponse => _promotionFeesResponse;

  FeeData? selectedFeeData;

  Future<ApiResponse> fetchPromotionFees() async {
    selectedFeeData = null;
    _paymentBreakdownResponse = null;
    return await performApiCall(
      url: "/api/v1/super_admin/fees?charge_usage=promotions&paginate=0",
      method: apiService.getWithAuth,
      errorObjectName: getFeesState,
      busyObjectName: getFeesState,
      onSuccess: (data) {
        _promotionFeesResponse = PromotionFeesResponse.fromJson(data);
        return apiResponse;
      },
    );
  }

  PaymentBreakdownResponse? _paymentBreakdownResponse;
  PaymentBreakdownResponse? get paymentBreakdownResponse =>
      _paymentBreakdownResponse;
  set paymentBreakdownResponse(PaymentBreakdownResponse? val) {
    _paymentBreakdownResponse = val;
    notifyListeners();
  }

  Future<ApiResponse> getPaymentBreakdown(
      {DateTime? startDate, DateTime? endDate}) async {
    final body = {
      "start_date": startDate?.toIso8601String().split("T").first,
      "end_date": endDate?.toIso8601String().split("T").first,
      "promotion_type":
          selectedFeeData?.name?.toLowerCase().contains("regular") ?? false
              ? "regular"
              : "deluxe",
    };
    return await performApiCall(
      url: "/api/v1/merchants/inventory-products/promotions/payment-breakdown",
      method: apiService.postWithAuth,
      errorObjectName: paymentBreakdownState,
      busyObjectName: paymentBreakdownState,
      body: body,
      onSuccess: (data) {
        _paymentBreakdownResponse = PaymentBreakdownResponse.fromJson(data);
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> creatPromotion(
      {required String productId,
      String? callbackUrl,
      DateTime? startDate,
      DateTime? endDate}) async {
    final body = {
      "product_id": productId,
      "start_date": startDate?.toIso8601String().split("T").first,
      "end_date": endDate?.toIso8601String().split("T").first,
      "amount_paid": _paymentBreakdownResponse?.data?.total
          ?.substring(1)
          .replaceAll(",", ''),
      "callback_url": callbackUrl,
      "promotion_type":
          selectedFeeData?.name?.toLowerCase().contains("regular") ?? false
              ? "regular"
              : "deluxe",
    };
    return await performApiCall(
      url: "/api/v1/merchants/inventory-products/promotions",
      method: apiService.postWithAuth,
      errorObjectName: createPromotionState,
      busyObjectName: createPromotionState,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> verifyPayment(String? reference) async {
    return await performApiCall(
      url: "/api/v1/merchants/inventory-products/promotions/$reference/verify",
      method: apiService.getWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }
}

final productInventoryVmodel =
    ChangeNotifierProvider((ref) => ProductInventoryVm());
