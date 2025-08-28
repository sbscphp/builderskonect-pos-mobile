class PaginatedData {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final dynamic data;
  final String? firstPageUrl;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final int? perPage;
  final int? total;
  final int? to;

  PaginatedData(
      {this.currentPage,
      this.from,
      this.lastPage,
      this.data,
      this.firstPageUrl,
      this.lastPageUrl,
      this.nextPageUrl,
      this.perPage,
      this.total,
      this.to});

  factory PaginatedData.fromJson(Map<String, dynamic> json) => PaginatedData(
        currentPage: json['current_page'],
        from: json['from'],
        lastPage: json['last_page'],
        data: json['data'],
        firstPageUrl: json['first_page_url'],
        lastPageUrl: json['last_page_url'],
        nextPageUrl: json['next_page_url'],
        perPage: json['per_page'],
        total: json['total'],
        to: json['to'],
      );
}
