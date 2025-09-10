import 'dart:convert';

List<ReviewsData> reviewsDataFromJson(String str) => List<ReviewsData>.from(
    json.decode(str).map((x) => ReviewsData.fromJson(x)));

String reviewsDataToJson(List<ReviewsData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewsData {
  final int? id;
  final String? customerId;
  final String? customerName;
  final String? feedback;
  final String? ratings;
  final DateTime? feedbackDate;
  final String? response;

  ReviewsData({
    this.id,
    this.customerId,
    this.customerName,
    this.feedback,
    this.ratings,
    this.feedbackDate,
    this.response,
  });

  factory ReviewsData.fromJson(Map<String, dynamic> json) => ReviewsData(
        id: json["id"],
        customerId: json["customerID"],
        customerName: json["customer_name"],
        feedback: json["feedback"],
        ratings: json["ratings"],
        feedbackDate: json["feedback_date"] == null
            ? null
            : DateTime.parse(json["feedback_date"]),
        response: json["response"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerID": customerId,
        "customer_name": customerName,
        "feedback": feedback,
        "ratings": ratings,
        "feedback_date": feedbackDate?.toIso8601String(),
        "response": response,
      };
}
