import 'package:builders_konnect/core/core.dart';

class RefundReturnsVm extends BaseVm {
  RefundsOverviewModel? _refundsOverviewModel;
  RefundStats? get stats => _refundsOverviewModel?.stats;
  List<RefundData>? get refundData => _refundsOverviewModel?.data?.data;

  Future<ApiResponse> getReturnsOverview({
    String? q,
  }) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/returns")
      ..addQueryParameterIfNotEmpty("q", q ?? '')
      ..addQueryParameterIfNotEmpty("limit", '50')
      ..addQueryParameterIfNotEmpty("paginate", '1');
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: getState,
      busyObjectName: getState,
      onSuccess: (data) {
        _refundsOverviewModel =
            refundsOverviewModelFromJson(json.encode(data['data']));
        return apiResponse;
      },
    );
  }
}

final refundReturnsVm = ChangeNotifierProvider((ref) => RefundReturnsVm());
