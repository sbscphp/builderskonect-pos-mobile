import 'dart:io';

import 'package:builders_konnect/core/core.dart';

const String uploadState = "uploadState";

class FileUploadVm extends BaseVm {
  // Map to track upload progress for each file
  final Map<String, double> _uploadProgress = {};

  // Getter to access upload progress
  Map<String, double> get uploadProgress => _uploadProgress;

  // Method to get progress for a specific file
  double getProgressForFile(String filePath) {
    return _uploadProgress[filePath] ?? 0.0;
  }

  // Reset progress for all files
  void resetProgress() {
    _uploadProgress.clear();
    notifyListeners();
  }

  // Update progress for a specific file
  void _updateProgress(String filePath, double progress) {
    _uploadProgress[filePath] = progress;
    notifyListeners();
  }

  Future<ApiResponse<List<UploadFileModel>>> uploadFile({
    required List<File> file,
  }) async {
    // Initialize progress for each file
    for (var f in file) {
      _uploadProgress[f.path] = 0.0;
    }

    return await performApiCall<List<UploadFileModel>>(
      url: "/api/v1/shared/media/upload",
      method: (
          {required String url,
          dynamic body,
          bool isFormData = false,
          bool addDeviceHeaders = false}) async {
        try {
          final dio = Dio(apiService.options);
          dio.interceptors.add(apiService.logger);

          // Create FormData manually to track progress
          FormData formData = FormData();

          // Add files to FormData
          for (var f in file) {
            final fileName = f.path.split('/').last;
            final multipartFile = await MultipartFile.fromFile(
              f.path,
              filename: fileName,
            );
            formData.files.add(MapEntry('media[]', multipartFile));
          }

          // Make the request with progress tracking
          Response response = await dio.post(
            url,
            data: formData,
            onSendProgress: (sent, total) {
              // Calculate overall progress
              final progress = sent / total;

              // Update progress for each file (simplified approach - all files share same progress)
              for (var f in file) {
                _updateProgress(f.path, progress);
              }
            },
          ).timeout(Duration(seconds: apiService.timeOutDurationInSeconds));

          // Set all files to 100% when complete
          for (var f in file) {
            _updateProgress(f.path, 1.0);
          }

          return DioResponseHandler.parseResponse(response);
        } on DioException catch (e) {
          printty("error");
          return DioResponseHandler.dioErrorHandler(e);
        }
      },
      busyObjectName: uploadState,
      isFormData: true,
      body: {}, // Empty body since we're handling FormData manually
      onSuccess: (data) {
        List<UploadFileModel> result;
        if (data is List) {
          // If data is already a list
          result = uploadFileModelFromJson(json.encode(data));
        } else if (data is Map && data.containsKey('data')) {
          // If data is a map with a 'data' key that contains the list
          result = uploadFileModelFromJson(json.encode(data['data']));
        } else {
          result = [];
        }
        return ApiResponse(success: true, data: result);
      },
    );
  }
}

final fileUploadVm = ChangeNotifierProvider((ref) {
  return FileUploadVm();
});
