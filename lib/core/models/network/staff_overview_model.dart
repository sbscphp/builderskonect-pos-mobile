import 'dart:convert';
import 'network.dart';

StaffOverviewModel staffOverviewModelFromJson(String str) =>
    StaffOverviewModel.fromJson(json.decode(str));

class StaffOverviewModel {
  final StaffStats? stats;
  final PaginatedData? data;

  StaffOverviewModel({
    this.stats,this.data
  });

  factory StaffOverviewModel.fromJson(Map<String, dynamic> json) => StaffOverviewModel(
    stats: json['stats'] != null ? StaffStats.fromJson(json['stats']) : null,
    data: json['data'] != null ? PaginatedData.fromJson(json['data']) : null,
  );
}


class StaffStats {
  final int? total;
  final int? active;
  final int? inactive;

  StaffStats({
    this.total,
    this.active,
    this.inactive,
  });

  factory StaffStats.fromJson(Map<String, dynamic> json) => StaffStats(
      total: json['total'], active: json['active'], inactive: json['inactive']);
}
