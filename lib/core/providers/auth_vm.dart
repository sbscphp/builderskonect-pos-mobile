import 'package:builders_konnect/core/core.dart';

const String updateProfileState = "updateProfileState";

class AuthVm extends BaseVm {
  User? _user;
  User? get user => _user;

  Future<ApiResponse> login({
    required String identifier,
    required String password,
    String? entity,
  }) async {
    final body = {
      "identifier": identifier,
      "password": password,
      "entity": entity ?? "merchant" // fulfilment-officer, merchant, customer
    };
    body.removeWhere((k, v) => v == "");
    return await performApiCall(
      url: "/api/v1/auth/signin",
      method: apiService.post,
      body: body,
      onSuccess: (data) {
        final result = authUserModelFromJson(json.encode(data["data"]));

        _user = result.user;
        StorageService.storeAccessToken(result.accessToken ?? "");
        StorageService.storeStringItem(
            StorageKey.xTenantId,
            (result.user?.merchantAccount?.isNotEmpty == true
                    ? result.user!.merchantAccount!.first.id
                    : "") ??
                "");
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> createPassword({
    required String code,
    required String token,
    required String password,
    required String passwordConfirm,
  }) async {
    return await performApiCall(
      url: "/merchants/onboarding/add-password",
      method: apiService.post,
      body: {
        "code": code,
        "token": token,
        "password": password,
        "password_confirmation": passwordConfirm,
        "entity": "merchant",
      },
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> resetPassword({
    required String identifier,
  }) async {
    return await performApiCall(
      url: "/api/v1/auth/forgot-password/reset",
      method: apiService.post,
      body: {"identifier": identifier},
      onSuccess: (data) {
        return ApiResponse(
          success: true,
          data: data["data"]?["token"],
          message: data["message"],
        );
      },
    );
  }

  Future<ApiResponse> recoverPassword({
    required ForgotArg forgotArg,
  }) async {
    final body = forgotArg.toMap();
    body.removeWhere((k, v) => v == "");
    return await performApiCall(
      url: "/api/v1/auth/forgot-password/recover",
      method: apiService.post,
      isFormData: true,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? avatar,
    String? activityStatus,
    String? busyObjectName,
  }) async {
    final body = {
      "name": name,
      "phone": phone,
      "email": email,
      "avatar": avatar,
      "activity_status": activityStatus, //available, busy, offline
    };
    body.removeWhere((k, v) => v == null || v == "");
    return await performApiCall(
      url: "/api/v1/fulfilment-officers/profile",
      method: apiService.putWithAuth,
      busyObjectName: busyObjectName ?? updateProfileState,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }

  ProfileModel? _vendorProfile;
  ProfileModel? get vendorProfile => _vendorProfile;

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

  Future<ApiResponse> logout() async {
    try {
      setBusy(true);
      await Future.delayed(const Duration(seconds: 1));

      Navigator.pushNamedAndRemoveUntil(
        NavKey.appNavKey.currentContext!,
        RoutePath.loginScreen,
        (r) => false,
      );
      setBusy(false);
      String url = "/api/v1/auth/sign-out";
      apiResponse = await apiService.getWithAuth(body: null, url: url);
      await StorageService.logout();

      return apiResponse;
    } catch (e) {
      printty(e.toString(), logName: "Logout Error");
      setBusy(false);
      return ApiResponse(success: false, message: e.toString());
    }
  }
}

final authVmodel = ChangeNotifierProvider((ref) => AuthVm());
