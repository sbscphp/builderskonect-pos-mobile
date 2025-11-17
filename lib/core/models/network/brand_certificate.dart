class Certificate {
  String? id;
  String? status;
  String? certificateNo;
  String? certificateExpiryDate;
  String? certificateFileUrl;
  CertificateBrand? brand;
  CertificateManufacturer? manufacturer;

  Certificate({
    this.id,
    this.status,
    this.certificateNo,
    this.certificateExpiryDate,
    this.certificateFileUrl,
    this.brand,
    this.manufacturer,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
      id: json['id'] as String?,
      status: json['status'] as String?,
      certificateNo: json['certificate_no'] as String?,
      certificateExpiryDate: json['certificate_expiry_date'] as String?,
      certificateFileUrl: json['certificate_file_url'] as String?,
      brand: json['brand'] != null
          ? CertificateBrand.fromJson(json['brand'] as Map<String, dynamic>)
          : null,
      manufacturer: json['manufacturer'] != null
          ? CertificateManufacturer.fromJson(
              json['manufacturer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'certificate_no': certificateNo,
      'certificate_expiry_date': certificateExpiryDate,
      'certificate_file_url': certificateFileUrl,
      'brand': brand?.toJson(),
      'manufacturer': manufacturer?.toJson(),
    };
  }
}

class CertificateBrand {
  int? id;
  String? name;

  CertificateBrand({
    this.id,
    this.name,
  });

  factory CertificateBrand.fromJson(Map<String, dynamic> json) {
    return CertificateBrand(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class CertificateManufacturer {
  int? id;
  String? name;

  CertificateManufacturer({
    this.id,
    this.name,
  });

  factory CertificateManufacturer.fromJson(Map<String, dynamic> json) {
    return CertificateManufacturer(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}