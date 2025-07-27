import 'dart:async';

import 'package:builders_konnect/core/core.dart';

class AppInterceptors extends QueuedInterceptorsWrapper {
  Dio dio = Dio();
  CancelToken cancelToken = CancelToken();
  bool isTrustedDevice = true;

  @override
  FutureOr<dynamic> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    String? token = await StorageService.getStringItem(StorageKey.accessToken);
    String? tenantId = await StorageService.getStringItem(StorageKey.xTenantId);

    // printty(token.toString());
    options.headers.addAll({
      "authorization": "Bearer $token",
      "X-Tenant-ID": tenantId,
    });
    handler.next(options);
    // printty("url headers:===> ${options.headers.toString()}");
  }

  @override
  FutureOr<dynamic> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    handler.next(response);
  }

  @override
  FutureOr<dynamic> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    ApiResponse res = DioResponseHandler.dioErrorHandler(err);

    if (res.code == 401 || res.code == 403) {
      logout();
      return handler.reject(err);
    }

    if (res.code == 500 &&
        res.message != null &&
        res.message!
            .contains("This device is not set as your trusted device.")) {
      ApiResponse res = DioResponseHandler.dioErrorHandler(err);
      printty("ssss: ${res.message}");
      final dioError = DioException(
          message: res.message,
          type: DioExceptionType.badResponse,
          requestOptions: err.requestOptions,
          response: Response(
              statusCode: 409,
              requestOptions: err.requestOptions,
              data: {
                "success": false,
                "message": res.message ??
                    "This device is not set as your trusted device"
              },
              statusMessage: res.message ??
                  "This device is not set as your trusted device"));
      return handler.reject(dioError);
    }

    return handler.next(err);
  }

  Future<void> logout() async {
    await StorageService.logout();
    gotoNextScreen(RoutePath.loginScreen);
  }

  gotoNextScreen(String route) {
    Navigator.pushNamedAndRemoveUntil(
        NavKey.appNavKey.currentContext!, route, (r) => false);
  }
}
