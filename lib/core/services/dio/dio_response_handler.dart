// ignore_for_file: unused_catch_stack

import 'package:builders_konnect/core/core.dart';

class DioResponseHandler {
  static ApiResponse parseResponse(Response res) {
    try {
      return ApiResponse(
        code: res.statusCode,
        success: res.statusCode! >= 200 && res.statusCode! < 300,
        data: res.data,
        message: res.data is Map && res.data.containsKey("message")
            ? res.data["message"]
            : "Operation successful",
      );
    } catch (e) {
      return ApiResponse(
        code: res.statusCode,
        success: false,
        message: e.toString(),
      );
    }
  }

  static ApiResponse dioErrorHandler(DioException e) {
    final dioError = e;
    printty("Dio Error dioErrorHandler: $dioError ,,,,, ${dioError.type}.");

    switch (dioError.type) {
      case DioExceptionType.badResponse:
        try {
          return ApiResponse(
            code: dioError.response?.statusCode,
            success: false,
            message: dioError.response?.data["message"] ??
                dioError.response?.statusMessage ??
                AppText.errorMsg,
          );
        } catch (e, s) {
          printty(e.toString(), logName: 'error catch');
          printty(dioError.response?.data, logName: 'Dio Response Error');
          return ApiResponse(
            code: dioError.response?.statusCode,
            success: false,
            message: dioError.response?.data["message"] ??
                dioError.response?.statusMessage ??
                AppText.errorMsg, // AppText.errorMsg,
          );
        }

      case DioExceptionType.cancel:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.unknown:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.receiveTimeout:
        return ApiResponse(
          code: 500,
          success: false,
          message: _getErrorMsg(dioError.type),
        );
      default:
        return ApiResponse(
          code: 500,
          success: false,
          message: AppText.errorMsg,
        );
    }
  }

  static String _getErrorMsg(DioExceptionType type) {
    switch (type) {
      case DioExceptionType.cancel:
        return "Operation cancelled";
      case DioExceptionType.connectionTimeout:
        return "Connection Timed Out";
      case DioExceptionType.unknown:
        return AppText.errorMsg;
      case DioExceptionType.sendTimeout:
        return "Sender Connection Timed Out";
      case DioExceptionType.connectionError:
        return "Connection Error, Please check your internet connection";
      case DioExceptionType.receiveTimeout:
        return "Reciever Connection Timed Out";
      default:
        return AppText.errorMsg;
    }
  }
}
