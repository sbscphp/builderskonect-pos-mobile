import 'dart:convert';
import 'network.dart';

TransferProductOverviewModel transferProductOverviewModelFromJson(String str) => TransferProductOverviewModel.fromJson(json.decode(str));

class TransferProductOverviewModel {
  final TransferProductStats? stats;
  final PaginatedData? data;

  TransferProductOverviewModel({this.stats, this.data});

  factory TransferProductOverviewModel.fromJson(Map<String, dynamic> json) =>
      TransferProductOverviewModel(
        stats: json['stats'] != null
            ? TransferProductStats.fromJson(json['stats'])
            : null,
        data:
            json['data'] != null ? PaginatedData.fromJson(json['data']) : null,
      );
}

class TransferProductStats {
  final dynamic requestSentValue;
  final dynamic requestSentVolume;
  final dynamic stockReceived;
  final dynamic pendingTransfers;
  final dynamic declinedTransfers;
  final dynamic totalTransfers;

  TransferProductStats(
      {this.requestSentValue,
      this.requestSentVolume,
      this.stockReceived,
      this.pendingTransfers,
      this.declinedTransfers,
      this.totalTransfers});

  factory TransferProductStats.fromJson(Map<String, dynamic> json) =>
      TransferProductStats(
          requestSentValue: json['request_sent_value'],
          requestSentVolume: json['request_sent_volume'],
          stockReceived: json['stock_received'],
          pendingTransfers: json['pending_transfers'],
          declinedTransfers: json['declined_transfers'],
          totalTransfers: json['total_transfers']);
}
