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
      String? busyObjectName = getState,String? dateFilter,String? status}) async {
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
}

final productInventoryVmodel =
    ChangeNotifierProvider((ref) => ProductInventoryVm());
