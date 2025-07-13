import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioApiService {
  int timeOutDurationInSeconds = 30;
  int connectionTimeout = 6000;
  Interceptor appInterceptors;
  late Dio dio;

  var options = BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: const Duration(seconds: 6000),
    receiveTimeout: const Duration(seconds: 3000),
  );

  PrettyDioLogger logger = PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
    error: true,
    compact: true,
    maxWidth: 10090,
  );

  DioApiService({required this.appInterceptors}) {
    dio = Dio(options);
    dio.interceptors.add(appInterceptors);
    dio.interceptors.add(logger);
    Map<String, dynamic> headers = {'Accept': 'application/json'};
    dio.options.headers = headers;
  }

  Future<ApiResponse> post({
    var body,
    required String url,
    bool isFormData = false,
    bool addDeviceHeaders = false,
  }) async {
    try {
      final dio = Dio(options);
      dio.interceptors.add(logger);
      printty(options.baseUrl, logName: "custom options");
      Response response = await dio
          .post(
            url,
            data: isFormData ? FormData.fromMap(body) : body,
          )
          .timeout(Duration(seconds: timeOutDurationInSeconds));
      return DioResponseHandler.parseResponse(response);
    } on DioException catch (e) {
      printty("error");
      return DioResponseHandler.dioErrorHandler(e);
    }
  }

  Future<ApiResponse> get({
    var body,
    required String url,
    bool isFormData = false,
    bool addDeviceHeaders = false,
  }) async {
    try {
      // options.headers = await getDeviceHeaders();
      Response response = await dio
          .get(url)
          .timeout(Duration(seconds: timeOutDurationInSeconds));
      return DioResponseHandler.parseResponse(response);
    } on DioException catch (e, s) {
      printty('${e.toString()} $s', logName: "get error");
      return DioResponseHandler.dioErrorHandler(e);
    }
  }

  Future<ApiResponse> putWithAuth({
    dynamic body,
    required String url,
    bool isFormData = false,
    bool addDeviceHeaders = false,
  }) async {
    try {
      Response response = await dio
          .put(url, data: isFormData ? FormData.fromMap(body) : body)
          .timeout(Duration(seconds: timeOutDurationInSeconds));
      return DioResponseHandler.parseResponse(response);
    } on DioException catch (e, s) {
      printty('${e.toString()} $s', logName: "get error");
      return DioResponseHandler.dioErrorHandler(e);
    }
  }

  Future<ApiResponse> patchWithAuth({
    dynamic body,
    required String url,
    bool isFormData = false,
    bool addDeviceHeaders = false,
  }) async {
    try {
      Response response = await dio
          .patch(url, data: body)
          .timeout(Duration(seconds: timeOutDurationInSeconds));
      return DioResponseHandler.parseResponse(response);
    } on DioException catch (e, s) {
      printty('${e.toString()} $s', logName: "get error");
      return DioResponseHandler.dioErrorHandler(e);
    }
  }

  Future<ApiResponse> postWithAuth({
    var body,
    required String url,
    bool canRetry = true,
    bool isFormData = false,
    bool addDeviceHeaders = false,
    String? contentType,
  }) async {
    try {
      if (contentType != null) {
        dio.options.contentType = contentType;
      }

      Response response = await dio
          .post(url, data: isFormData ? FormData.fromMap(body) : body)
          .timeout(Duration(seconds: timeOutDurationInSeconds));
      return DioResponseHandler.parseResponse(response);
    } on DioException catch (e, s) {
      printty('${e.toString()} $s', logName: "postWithAuth error");

      return DioResponseHandler.dioErrorHandler(e);
    } catch (e) {
      return ApiResponse(success: false);
    }
  }

  Future<ApiResponse> deleteWithAuth({
    var body,
    required String url,
    bool canRetry = true,
    String? contentType,
    bool isFormData = false,
    bool addDeviceHeaders = false,
  }) async {
    try {
      if (contentType != null) {
        dio.options.contentType = contentType;
      }

      dynamic data = body;
      if (body != null) {
        data = FormData.fromMap(body);
      }

      Response response = await dio
          .delete(url, data: contentType == null ? data : body)
          .timeout(Duration(seconds: timeOutDurationInSeconds));
      return DioResponseHandler.parseResponse(response);
    } on DioException catch (e, s) {
      printty(e.toString());
      printty(s.toString());
      return DioResponseHandler.dioErrorHandler(e);
    } catch (e) {
      printty("flsjfklskf: $e");
      return ApiResponse(success: false);
    }
  }

  Future<ApiResponse> getWithAuth({
    var body,
    required String url,
    bool canRetry = true,
    bool isFormData = false,
    bool addDeviceHeaders = false,
  }) async {
    try {
      printty(dio.options.baseUrl);
      Response response = await dio
          .get(url)
          .timeout(Duration(seconds: timeOutDurationInSeconds));
      return DioResponseHandler.parseResponse(response);
    } on DioException catch (e) {
      return DioResponseHandler.dioErrorHandler(e);
    }
  }

  Future<ApiResponse> printtyout() async {
    // await StorageService.logout();
    return ApiResponse(
        code: 401, success: false, message: "Unauthorized. Access denied!!!");
  }
}

DioApiService apiService = DioApiService(appInterceptors: AppInterceptors());
