import 'package:builders_konnect/core/core.dart';

class ProfileVm extends BaseVm {
  VendorProfileModel? _vendorProfile;
  VendorProfileModel? get vendorProfile => _vendorProfile;

  Future<ApiResponse> getVendorProfile() async {
    return await performApiCall(
      url: "/api/v1/merchants/profile/view",
      method: apiService.getWithAuth,
      onSuccess: (data) {
        _vendorProfile = profileModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

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

  Future<ApiResponse> contactSupport({
    String? name,
    String? email,
    String? phone,
    String? message,
    String application = "vendor",
    String? media,
  }) async {
    final body = {
      "name": name,
      "email": email,
      "phone": phone,
      "message": message,
      "application": application,
      "media": media,
    };
    body.removeWhere((k, v) => v == null || v == "");
    return await performApiCall(
      url: "/api/v1/shared/supports",
      method: apiService.postWithAuth,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }
}

final profileVmodel = ChangeNotifierProvider((ref) => ProfileVm());
