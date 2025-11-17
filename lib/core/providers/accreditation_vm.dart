import 'package:builders_konnect/core/core.dart';

class AccreditationVm extends BaseVm {
  //page number
  int pageNumber = 1;
  int? lastPage;

  List<Certificate> _brandCertificates = [];
  List<Certificate> get brandCertificates => _brandCertificates;

  PaginatedData? _accreditaionResponse;

  Future<ApiResponse> getAccreditaions(
      {String? q,
      String? busyObjectName = getState,
      String? dateFilter,
      String? status}) async {
    if (busyObjectName != paginateState) {
      pageNumber = 1;
    }
    UriBuilder uriBuilder =
        UriBuilder("/api/v1/merchants/accreditations?page=$pageNumber")
          ..addQueryParameterIfNotEmpty("q", q ?? '')
          ..addQueryParameterIfNotEmpty("date_filter", dateFilter ?? '')
          ..addQueryParameterIfNotEmpty("status", status ?? '')
          ..addQueryParameterIfNotEmpty("limit", '10')
          ..addQueryParameterIfNotEmpty("paginate", '1');

    // _inventoryProductModel = null;
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.getWithAuth,
      errorObjectName: busyObjectName,
      busyObjectName: busyObjectName,
      onSuccess: (data) {
        if (busyObjectName != paginateState) {
          _accreditaionResponse = PaginatedData.fromJson(data['data']);
          _brandCertificates = List.from(_accreditaionResponse?.data)
              .map((e) => Certificate.fromJson(e))
              .toList();
          pageNumber++;
          lastPage = _accreditaionResponse?.lastPage;
        } else {
          _accreditaionResponse = PaginatedData.fromJson(data['data']);
          _brandCertificates.addAll(List.from(_accreditaionResponse?.data)
              .map((e) => Certificate.fromJson(e))
              .toList());
          pageNumber++;
        }

        return apiResponse;
      },
    );
  }

  List<Brand> _manufacturers = [];
  List<Brand> get manufacturers => _manufacturers;

  Future<ApiResponse> getBrands() async {
    return await performApiCall(
      url:
          "/api/v1/super_admin/platform-configurations/brands?has_accreditation=true",
      method: apiService.getWithAuth,
      errorObjectName: getBrandState,
      busyObjectName: getBrandState,
      onSuccess: (data) {
        final res = BrandsResponse.fromJson(data);
        _manufacturers = res.data ?? [];
        return apiResponse;
      },
    );
  }

  Future<ApiResponse> createAccreditation(List<Brand> manufactueres) async {
    final body = {
      "action_by": "vendor_create",
      "brands": manufactueres
          .map((item) => {
                "brand_id": item.id?.toString(),
                "certificate_no": item.certificateNum.text,
                "certificate_expiry_date":
                    item.expireyDateTime?.toIso8601String().split("T").first,
                "certificate_file_url": item.docUrl
              })
          .toList()
    };
    return await performApiCall(
      url: "/api/v1/merchants/accreditations",
      method: apiService.postWithAuth,
      errorObjectName: createAccreditationState,
      busyObjectName: createAccreditationState,
      body: body,
      onSuccess: (data) {
        return apiResponse;
      },
    );
  }
}

final accreditationVm = ChangeNotifierProvider((ref) => AccreditationVm());
