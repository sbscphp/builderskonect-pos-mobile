import 'package:builders_konnect/core/core.dart';

class CatalogueVm extends BaseVm {
  List<CatalogueModel> _catalogueProducts = [];
  List<CatalogueModel> get catalogueProducts => _catalogueProducts;
  Future<ApiResponse> getCatalogueProducts({
    String? q,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/super_admin/catalogues")
      ..addQueryParameterIfNotEmpty("q", q ?? '');

    _catalogueProducts = [];
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      onSuccess: (data) {
        _catalogueProducts = catalogueModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }
}

final catalogueVmodel = ChangeNotifierProvider((ref) => CatalogueVm());
