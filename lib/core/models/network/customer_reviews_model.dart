import 'dart:convert';

ReviewsStatModel reviewsStatModelFromJson(String str) =>
    ReviewsStatModel.fromJson(json.decode(str));

String reviewsStatModelToJson(ReviewsStatModel data) =>
    json.encode(data.toJson());

class ReviewsStatModel {
  final int? total;
  final int? five;
  final int? four;
  final int? three;
  final int? two;
  final int? one;

  ReviewsStatModel({
    this.total,
    this.five,
    this.four,
    this.three,
    this.two,
    this.one,
  });

  factory ReviewsStatModel.fromJson(Map<String, dynamic> json) =>
      ReviewsStatModel(
        total: json["total"],
        five: json["five"],
        four: json["four"],
        three: json["three"],
        two: json["two"],
        one: json["one"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "five": five,
        "four": four,
        "three": three,
        "two": two,
        "one": one,
      };
}

List<ReviewsModel> reviewsModelFromJson(String str) => List<ReviewsModel>.from(
    json.decode(str).map((x) => ReviewsModel.fromJson(x)));

String reviewsModelToJson(List<ReviewsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewsModel {
  final int? id;
  final String? customerId;
  final String? customerName;
  final String? feedback;
  final String? ratings;
  final DateTime? feedbackDate;
  final String? response;

  ReviewsModel({
    this.id,
    this.customerId,
    this.customerName,
    this.feedback,
    this.ratings,
    this.feedbackDate,
    this.response,
  });

  factory ReviewsModel.fromJson(Map<String, dynamic> json) => ReviewsModel(
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
