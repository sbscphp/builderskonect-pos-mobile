import 'package:builders_konnect/core/core.dart';

class StoreVm extends BaseVm {
    //page number
  int pageNumber = 1;
  int? lastPage;

  StoreLocationModel? _storeLocationModel;
  Stats? get stats => _storeLocationModel?.stats;
  List<StoreModel> _storeList = [];
  List<StoreModel> get storeList => _storeList;
  Future<ApiResponse> getStoreOverview({
    String? q,
    String? sortBy,
    String? busyObjectName = getState
  }) async {
        if (busyObjectName != paginateState) {
      pageNumber = 1;
    }
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/locations?page=$pageNumber")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("sort_by", sortBy ?? '')
      ..addQueryParameterIfNotEmpty("limit", '50')
      ..addQueryParameterIfNotEmpty("paginate", '1');
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: busyObjectName,
      busyObjectName: busyObjectName,
      onSuccess: (data) {
        if (busyObjectName != paginateState) {
        _storeLocationModel =
            storeLocationModelFromJson(json.encode(data['data']));
            _storeList = _storeLocationModel?.data?.data ?? [];
           pageNumber++;
          lastPage = _storeLocationModel?.data?.lastPage;
            }else{
               _storeLocationModel =
            storeLocationModelFromJson(json.encode(data['data']));
              _storeList.addAll(_storeLocationModel?.data?.data ?? []);
           pageNumber++;
            }
        return apiResponse;
      },
    );
  }

  StoreOverviewModel? _storeOverviewModel;
  StoreOverviewModel? get storeOverviewModel => _storeOverviewModel;
  Future<ApiResponse> getStoreSalesOverview({required String id}) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/locations/$id")
      ..addQueryParameterIfNotEmpty("with_sales_overview", 'true');
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      onSuccess: (data) {
        _storeOverviewModel =
            storeOverviewModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

  StoreInventoryModel? _storeInventoryModel;
  StoreInventoryModel? get storeInventoryModel => _storeInventoryModel;
  Future<ApiResponse> getStoreInventoryOverview({required String id}) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/locations/$id")
      ..addQueryParameterIfNotEmpty("with_products", 'true');
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      onSuccess: (data) {
        _storeInventoryModel =
            storeInventoryModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }

  // StoreModel? _storeDeatils;
  // StoreModel? get storeDetails => _storeDeatils;
  Future<ApiResponse<StoreModel>> viewStoreDetails(String storeId) async {
    return await performApiCall<StoreModel>(
      url: "/api/v1/merchants/locations/$storeId",
      method: apiService.getWithAuth,
      onSuccess: (data) {
        final store = StoreModel.fromJson(data['data']);
        return ApiResponse<StoreModel>(success: true, data: store);
      },
    );
  }

  Future<ApiResponse> addNewStore({
    required String storeName,
    required String storeAddress,
    required int stateId,
    required int cityId,
  }) async {
    return await performApiCall(
      url: "/api/v1/merchants/locations",
      method: apiService.postWithAuth,
      busyObjectName: createState,
      body: {
        "name": storeName,
        "address": storeAddress,
        "state_id": stateId,
        "city_id": cityId,
      },
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> updateStore({
    required String storeId,
    required bool isActive,
  }) async {
    return await performApiCall(
      url: "/api/v1/merchants/locations/$storeId",
      method: apiService.putWithAuth,
      // busyObjectName: updateState,
      body: {"is_active": isActive},
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }
}

final storeVmodel = ChangeNotifierProvider((ref) => StoreVm());
