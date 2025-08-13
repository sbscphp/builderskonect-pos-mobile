import 'dart:convert';

RevenueAndTrafficModel revenueAndTrafficModelFromJson(String str) =>
    RevenueAndTrafficModel.fromJson(json.decode(str));

class RevenueAndTrafficModel {
  final String? revenue;
  final Traffic? traffic;

  RevenueAndTrafficModel({
    this.revenue,
    this.traffic,
  });

  factory RevenueAndTrafficModel.fromJson(Map<String, dynamic> json) =>
      RevenueAndTrafficModel(
        revenue: json["revenue"],
        traffic:
            json["traffic"] == null ? null : Traffic.fromJson(json["traffic"]),
      );
}

class Traffic {
  final Omp? omp; // Online
  final Omp? pos; //Walk-in

  Traffic({
    this.omp,
    this.pos,
  });

  factory Traffic.fromJson(Map<String, dynamic> json) => Traffic(
        omp: json["omp"] == null ? null : Omp.fromJson(json["omp"]),
        pos: json["pos"] == null ? null : Omp.fromJson(json["pos"]),
      );
}

class Omp {
  final int? volume;
  final String? value;

  Omp({
    this.volume,
    this.value,
  });

  factory Omp.fromJson(Map<String, dynamic> json) => Omp(
        volume: json["volume"],
        value: json["value"],
      );
}
