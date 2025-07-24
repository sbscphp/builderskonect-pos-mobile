import 'dart:convert';

List<UploadFileModel> uploadFileModelFromJson(String str) =>
    List<UploadFileModel>.from(
        json.decode(str).map((x) => UploadFileModel.fromJson(x)));

String uploadFileModelToJson(List<UploadFileModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UploadFileModel {
  final String? title;
  final double? size;
  final String? url;
  final String? ext;
  final String? retrievalId;

  UploadFileModel({
    this.title,
    this.size,
    this.url,
    this.ext,
    this.retrievalId,
  });

  factory UploadFileModel.fromJson(Map<String, dynamic> json) =>
      UploadFileModel(
        title: json["title"],
        size: json["size"]?.toDouble(),
        url: json["url"],
        ext: json["ext"],
        retrievalId: json["retrieval_id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "size": size,
        "url": url,
        "ext": ext,
        "retrieval_id": retrievalId,
      };
}
