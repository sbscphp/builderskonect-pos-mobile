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
}

final profileVmodel = ChangeNotifierProvider((ref) => ProfileVm());
