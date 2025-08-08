import 'package:builders_konnect/core/core.dart';

class GeographyVm extends BaseVm {
  List<StateModel> _states = [];
  List<StateModel> get states => _states;

  Future<ApiResponse> getStates([String query = ""]) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/states")
      ..addQueryParameterIfNotEmpty("country_id", "161")
      ..addQueryParameterIfNotEmpty("q", query);
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.get,
      onSuccess: (data) {
        _states = stateModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

  List<CityModel> _cities = [];
  List<CityModel> get cities => _cities;
  Future<ApiResponse> getCities(int stateId, [String query = ""]) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/cities")
      ..addQueryParameterIfNotEmpty("state_id", stateId.toString())
      ..addQueryParameterIfNotEmpty("q", query);
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.get,
      onSuccess: (data) {
        _cities = cityModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }

  List<GoogleAddressModel> _addresses = [];
  List<GoogleAddressModel> get addresses => _addresses;
  Future<ApiResponse> getAddressSuggestions(String q) async {
    UriBuilder uriBuilder = UriBuilder("/api/v1/shared/search-address")
      ..addQueryParameterIfNotEmpty("q", q);
    return await performApiCall(
      url: uriBuilder.build().toString(),
      method: apiService.get,
      onSuccess: (data) {
        _addresses = googleAddressModelFromJson(json.encode(data["data"]));
        return apiResponse;
      },
    );
  }
}

final geographyVmodel = ChangeNotifierProvider((ref) => GeographyVm());
