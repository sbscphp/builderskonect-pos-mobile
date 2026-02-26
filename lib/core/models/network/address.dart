import 'dart:convert';

List<Address> addressFromJson(String str) =>
    List<Address>.from(
        json.decode(str).map((x) => Address.fromJson(x)));


class Address {
  final String? id;
  final String? name;
  final String? company;
  final String? address;
  final String? phone;
  final bool? isDefault;
  final String? country;
  final String? state;
  final String? city;
  final String? type;
  final String? placeId;
  final String? description;
  final String? mainText;
  final String? secondaryText;
  final String? formattedAddress;
  final String? streetNumber;
  final String? route;
  final String? locality;
  final String? postalCode;
  final dynamic latitude;
  final dynamic longitude;
  final dynamic lat;
  final dynamic lon;

  Address({
    this.id,
    this.name,
    this.company,
    this.address,
    this.phone,
    this.isDefault,
    this.country,
    this.state,
    this.city,
    this.type,
    this.placeId,
    this.description,
    this.mainText,
    this.secondaryText,
    this.formattedAddress,
    this.streetNumber,
    this.route,
    this.locality,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.lat,
    this.lon
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    name: json["name"],
    company: json["company"],
    address: json["address"],
    phone: json["phone"],
    isDefault: json["is_default"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    type: json["type"],
    placeId: json["place_id"],
    description: json["description"],
    mainText: json["main_text"],
    secondaryText: json["secondary_text"],
    formattedAddress: json["formatted_address"],
    streetNumber: json["street_number"],
    route: json["route"],
    locality: json["locality"],
    postalCode: json["postal_code"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    lat: json["lat"],
    lon: json["lon"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "company": company,
    "address": address,
    "phone": phone,
    "is_default": isDefault,
    "country": country,
    "state": state,
    "city": city,
    "type": type,
    "place_id": placeId,
    "description": description,
    "main_text": mainText,
    "secondary_text": secondaryText,
    "formatted_address": formattedAddress,
    "street_number": streetNumber,
    "route": route,
    "locality": locality,
    "postal_code": postalCode,
    "latitude": latitude,
    "longitude": longitude,
    "lat": lat,
    "lon": lon,
  };
}