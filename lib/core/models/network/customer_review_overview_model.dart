import 'package:builders_konnect/core/core.dart';

CustomerReviewOverviewModel customerReviewOverviewModelFromJson(String str) =>
    CustomerReviewOverviewModel.fromJson(json.decode(str));

class CustomerReviewOverviewModel {
  final CustomerReviewStats? stats;
  final PaginatedData? data;
  CustomerReviewOverviewModel({this.stats, this.data});

  factory CustomerReviewOverviewModel.fromJson(Map<String, dynamic> json) => CustomerReviewOverviewModel(
    stats: json['stats'] != null ? CustomerReviewStats.fromJson(json['stats']) : null,
    data: json['data'] != null ? PaginatedData.fromJson(json['data']) : null,
  );
}

class CustomerReviewStats {
  final int? total;
  final int? five;
  final int? four;
  final int? three;
  final int? two;
  final int? one;
  CustomerReviewStats(
      {this.total, this.five, this.four, this.three, this.two, this.one});

  factory CustomerReviewStats.fromJson(Map<String, dynamic> json) =>
      CustomerReviewStats(
        total: json['total'],
        five: json['five'],
        four: json['four'],
        three: json['three'],
        two: json['two'],
        one: json['one'],
      );
}
