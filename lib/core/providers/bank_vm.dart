import 'package:builders_konnect/core/core.dart';

const verifyBankState = "verifyBankState";

class BankVm extends BaseVm {
  List<BankModel> _bankList = [];
  List<BankModel> get bankList => _bankList;

  Future<ApiResponse> getBanks([String? query]) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/banks")
      ..addQueryParameterIfNotEmpty("q", query ?? '');
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      onSuccess: (data) {
        _bankList = bankModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> verifyBank({
    required String accountNumber,
    required int bankId,
    String? busyObjectName,
  }) async {
    return await performApiCall(
      url: "/api/v1/merchants/onboarding/verify-bank",
      method: apiService.postWithAuth,
      busyObjectName: busyObjectName ?? verifyBankState,
      body: {
        "account_number": accountNumber,
        "bank_id": bankId,
      },
      onSuccess: (data) {
        return ApiResponse(
          success: true,
          data: data["data"]?["account_name"],
          message: data["message"],
        );
      },
    );
  }
}

final bankVmodel = ChangeNotifierProvider((ref) => BankVm());
