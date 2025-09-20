class SellingUnitModel {
  final String name;
  final String? eg;
  final List<String> value;

  const SellingUnitModel({
    required this.name,
    this.eg,
    required this.value,
  });

  factory SellingUnitModel.fromMap(Map<String, dynamic> map) {
    return SellingUnitModel(
      name: map['name'] ?? '',
      eg: map['eg'],
      value: List<String>.from(map['value'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'eg': eg,
      'value': value,
    };
  }

  bool get hasSubUnits => value.isNotEmpty;
}