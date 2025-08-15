import 'package:builders_konnect/core/core.dart';

class UserProfileVm extends BaseVm {
  UserProfileModel? _userProfile;
  UserProfileModel? get userProfile => _userProfile;
  Future<ApiResponse> getUserProfile() async {
    return await performApiCall(
      url: "/api/v1/merchants/staff/get/profile",
      method: apiService.getWithAuth,
      onSuccess: (data) {
        _userProfile = userProfileModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> updateProfile({
    String? name,
    String? avatar,
    String? password,
    String? passwordConfirm,
    String? currentPassword,
    String? busyObjectName,
  }) async {
    final body = {
      "name": name,
      "avatar": avatar,
      "password": password,
      "password_confirmation": passwordConfirm,
      "current_password": currentPassword,
    };
    body.removeWhere((k, v) => v == null || v == "");
    return await performApiCall(
      url: "/api/v1/merchants/staff/update/profile",
      method: apiService.putWithAuth,
      busyObjectName: busyObjectName,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }
}

final userProfileVmodel = ChangeNotifierProvider((ref) => UserProfileVm());
