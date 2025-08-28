import 'package:builders_konnect/core/core.dart';

class ProductInventoryVm extends BaseVm {
  InventoryProductModel? _inventoryProductModel;
  List<ProductModel> get inventoryProducts =>
      _inventoryProductModel?.data?.data ?? [];
  Future<ApiResponse> getInventoryProducts({
    String? q,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/inventory-products")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
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
}

final productInventoryVmodel =
    ChangeNotifierProvider((ref) => ProductInventoryVm());
