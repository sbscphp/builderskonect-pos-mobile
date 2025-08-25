import 'package:builders_konnect/core/core.dart';

class StaffVm extends BaseVm {
  StaffOverviewModel? _staffOverviewModel;
  StaffOverviewModel? get staffOverviewModel => _staffOverviewModel;

  List<StaffModel> _staffs = [];
  List<StaffModel> get staffs => _staffs;

  Future<ApiResponse> getDashboardStats() async { 
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/staff")
      ..addQueryParameterIfNotEmpty("paginate", "1")
      ..addQueryParameterIfNotEmpty("limit", "10");

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      onSuccess: (data) {
        _staffOverviewModel =
            staffOverviewModelFromJson(json.encode(data["data"]));
        _staffs = staffModelListFromJson(
            json.encode(_staffOverviewModel?.data?.data));
        
        return apiResponse;
      },
      onError: (errorMessage) {
        return apiResponse;
      },
    );
  }

  
    Future<ApiResponse> addNewStaff({
      required String fullName,
      required String email,
      required String phone,
      dynamic roleId
    }) async { 
    final body = {
      "name": fullName,
      "email": email,
      "phone": phone,
      "role_id": roleId,
    };

    return await performApiCall(
      url: "/api/v1/merchants/staff",
      method: apiService.postWithAuth,
      body: body,
      onSuccess: (data) {
        
        return apiResponse;
      },
      onError: (errorMessage) {
        return apiResponse;
      },
    );
  }
}

final staffVm = ChangeNotifierProvider((_) => StaffVm());
