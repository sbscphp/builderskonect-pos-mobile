class SubOption {
  final String id;
  final String label;
  final String? description;

  const SubOption({
    required this.id,
    required this.label,
    this.description,
  });

  factory SubOption.fromMap(Map<String, dynamic> map) {
    return SubOption(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'description': description,
    };
  }
}

class MeasurementCategory {
  final String id;
  final String label;
  final String example;
  final List<SubOption> subOptions;

  const MeasurementCategory({
    required this.id,
    required this.label,
    required this.example,
    required this.subOptions,
  });

  factory MeasurementCategory.fromMap(Map<String, dynamic> map) {
    return MeasurementCategory(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      example: map['example'] ?? '',
      subOptions: List<SubOption>.from(
        (map['subOptions'] ?? []).map((x) => SubOption.fromMap(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'example': example,
      'subOptions': subOptions.map((x) => x.toMap()).toList(),
    };
  }

  bool get hasSubOptions => subOptions.isNotEmpty;

  // For backward compatibility with existing code
  String get name => label;
  String get eg => 'e.g $example';
  // List<String> get value => subOptions.map((option) => option.label).toList();
  // bool get hasSubUnits => hasSubOptions;
}
