class ApiResponse<T> {
  bool success;
  T? data;
  String? message;
  int? code;

  ApiResponse({required this.success, this.data, this.message, this.code});

  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, message: $message, code: $code)';
  }
}
