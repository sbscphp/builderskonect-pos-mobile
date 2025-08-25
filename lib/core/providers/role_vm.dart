import 'package:builders_konnect/core/core.dart';

class RoleVm extends BaseVm {
  List<RoleModel> _roles = [];
  List<RoleModel> get roles => _roles;

  Future<ApiResponse> getAvailableRoles({String q = ''}) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/merchants/roles")
      ..addQueryParameterIfNotEmpty("paginate", "0")
      ..addQueryParameterIfNotEmpty("q", q);

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

  Future<ApiResponse> createRole(
      {required String name, required String description}) async {
    final body = {"name": name, "description": description};
    return await performApiCall(
      url: "/api/v1/merchants/roles",
      body: body,
      method: apiService.postWithAuth,
      onSuccess: (data) {
        getAvailableRoles();
        return apiResponse;
      },
      onError: (errorMessage) {
        return apiResponse;
      },
    );
  }
}

final roleVm = ChangeNotifierProvider((_) => RoleVm());
