import 'dart:convert';
import 'network.dart';

DiscountOverviewViewModel discountOverviewViewModelFromJson(String str) =>
    DiscountOverviewViewModel.fromJson(json.decode(str));
    
class DiscountOverviewViewModel {
  final DiscountStats? stats;
  final PaginatedData? data;

  DiscountOverviewViewModel({
    this.stats,this.data
  });
  factory DiscountOverviewViewModel.fromJson(Map<String, dynamic> json) => DiscountOverviewViewModel(
    stats: json['stats'] != null ? DiscountStats.fromJson(json['stats']) : null,
    data: json['data'] != null ? PaginatedData.fromJson(json['data']) : null,
  );
}

class DiscountStats{
  final int? total;
  final int? active;
  final int? expired;
  final int? scheduled;

  DiscountStats({
    this.total,
    this.active,
    this.expired,
    this.scheduled,
  });

  factory DiscountStats.fromJson(Map<String, dynamic> json) => DiscountStats(
      total: json['total'],
      active: json['active'],
      expired: json['expired'],
      scheduled: json['scheduled']);

}