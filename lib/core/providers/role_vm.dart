import 'package:builders_konnect/core/core.dart';

class RoleVm extends BaseVm {

  List<RoleModel> _roles = [];
  List<RoleModel> get roles => _roles;

    Future<ApiResponse> getAvailableRoles() async { 
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/roles")
      ..addQueryParameterIfNotEmpty("paginate", "0");

    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      onSuccess: (data) {
        _roles = roleModelListFromJson(json.encode(data["data"]));
        return apiResponse;
      },
      onError: (errorMessage) {
        return apiResponse;
      },
    );
  }



}

final roleVm = ChangeNotifierProvider((_) => RoleVm());
