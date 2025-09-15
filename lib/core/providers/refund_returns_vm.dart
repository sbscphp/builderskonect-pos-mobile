import 'package:builders_konnect/core/core.dart';

class RefundReturnsVm extends BaseVm {
  RefundStats? _stats;
  RefundStats? get stats => _stats;
  List<RefundData> _refundData = [];
  List<RefundData> get refundData => _refundData;

  Future<ApiResponse> getReturnsOverview({
    String? q,
    String? customerId,
    bool paginate = true,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/returns")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("customer_id", customerId ?? '')
      ..addQueryParameterIfNotEmpty("limit", '30')
      ..addQueryParameterIfNotEmpty("paginate", paginate ? '1' : '0');
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      onSuccess: (data) {
        if (paginate) {
          _stats = refundStatsFromJson(json.encode(data['data']?['stats']));
          _refundData =
              refundDataFromJson(json.encode(data['data']?['data']?['data']));
        } else {
          _refundData = refundDataFromJson(json.encode(data['data']));
        }
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> createReturns(ReturnParams params) async {
    final payload = params.toMap();
    payload.removeWhere((k, v) => v == null || v == "");
    return await performApiCall(
      url: "/api/v1/merchants/returns",
      method: apiService.postWithAuth,
      errorObjectName: createState,
      busyObjectName: createState,
      body: payload,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  ReturnRefurnDetailsModel? _returnRefurnDetailsModel;
  ReturnRefurnDetailsModel? get returnRefurnDetailsModel =>
      _returnRefurnDetailsModel;
  Future<ApiResponse> viewDetails(String id) async {
    return await performApiCall(
      url: "/api/v1/merchants/returns/$id",
      method: apiService.getWithAuth,
      errorObjectName: viewState,
      busyObjectName: viewState,
      onSuccess: (data) {
        _returnRefurnDetailsModel =
            returnRefurnDetailsModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }
}

final refundReturnsVm = ChangeNotifierProvider((ref) => RefundReturnsVm());
