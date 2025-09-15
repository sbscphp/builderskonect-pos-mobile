import 'package:builders_konnect/core/core.dart';

class ProductInventoryVm extends BaseVm {
  InventoryProductModel? _inventoryProductModel;
  ProductStats? get productStats => _inventoryProductModel?.stats;
  List<ProductModel> get inventoryProducts =>
      _inventoryProductModel?.data?.data ?? [];
  Future<ApiResponse> getInventoryProducts({
    String? q,
    bool productReview = false,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/inventory-products")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("product_review", productReview.toString())
      ..addQueryParameterIfNotEmpty("limit", '50')
      ..addQueryParameterIfNotEmpty("paginate", '1');

    _inventoryProductModel = null;
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      onSuccess: (data) {
        _inventoryProductModel =
            inventoryProductModelFromJson(json.encode(data['data']));
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
}

final productInventoryVmodel =
    ChangeNotifierProvider((ref) => ProductInventoryVm());
