import 'package:builders_konnect/core/core.dart';

class DashboardVm extends BaseVm {
  StatModel? _statModel;
  StatModel? get statModel => _statModel;

  Future<ApiResponse> getDashboardStats({
    String? dateFilter,
    String? locationId,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/dashboard/stats")
      ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '')
      ..addQueryParameterIfNotEmpty("location_id", locationId ?? '');
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      isFormData: true,
      onSuccess: (data) {
        _statModel = statModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

  RevenueAndTrafficModel? _revenueAndTrafficModel;
  RevenueAndTrafficModel? get revenueAndTrafficModel => _revenueAndTrafficModel;
  Future<ApiResponse> getRevenueAndTraffic({
    String? dateFilter,
    String? locationId,
  }) async {
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/dashboard/revenue-and-traffic")
          ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '')
          ..addQueryParameterIfNotEmpty("location_id", locationId ?? '');
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      isFormData: true,
      onSuccess: (data) {
        _revenueAndTrafficModel =
            revenueAndTrafficModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

  ProductOverviewModel? _productOverviewModel;
  ProductOverviewModel? get productOverviewModel => _productOverviewModel;
  Future<ApiResponse> getProductOverview({
    String? dateFilter,
    String? locationId,
  }) async {
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/dashboard/product-overview")
          ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '')
          ..addQueryParameterIfNotEmpty("location_id", locationId ?? '');
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      isFormData: true,
      onSuccess: (data) {
        _productOverviewModel =
            productOverviewModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

  MerchantCheckListModel? _merchantCheckListModel;
  MerchantCheckListModel? get merchantCheckListModel => _merchantCheckListModel;
  Future<ApiResponse> getMerchantCheckList() async {
    return await performApiCall(
      url: "/api/v1/merchants/dashboard/checklist",
      method: apiService.getWithAuth,
      isFormData: true,
      onSuccess: (data) {
        _merchantCheckListModel =
            merchantCheckListModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }
}

final dashboardVmodel = ChangeNotifierProvider((ref) => DashboardVm());
