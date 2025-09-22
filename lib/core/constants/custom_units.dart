import '../models/measurement_category_model.dart';

final List<MeasurementCategory> sellingUnitCategories = [
  MeasurementCategory(
    id: 'count-based',
    label: 'Count based',
    example: 'pcs',
    subOptions: [
      SubOption(id: 'pcs', label: 'Pieces'),
      SubOption(id: 'unit', label: 'Unit'),
      SubOption(id: 'dozen', label: 'Dozen'),
      SubOption(id: 'pair', label: 'Pair'),
      SubOption(id: 'set', label: 'Set'),
      SubOption(id: 'box', label: 'Box(es)'),
      SubOption(id: 'carton', label: 'Carton(s)'),
      SubOption(id: 'buckets', label: 'Bucket(s)'),
      SubOption(id: 'bag', label: 'Bag(s)'),
      SubOption(id: 'crate', label: 'Crate(s)'),
      SubOption(id: 'bundle', label: 'Bundle(s)'),
      SubOption(id: 'other', label: 'Other'),
    ],
  ),
  MeasurementCategory(
    id: 'length',
    label: 'Length',
    example: 'pcs',
    subOptions: [
      SubOption(id: 'm', label: 'Meter(s)'),
      SubOption(id: 'cm', label: 'Centimeter(s)'),
      SubOption(id: 'mm', label: 'Millimeter(s)'),
      SubOption(id: 'feet', label: 'Feet'),
      SubOption(id: 'yard', label: 'Yard(s)'),
    ],
  ),
  MeasurementCategory(
    id: 'weight',
    label: 'Weight',
    example: 'kg',
    subOptions: [
      SubOption(id: 'kg', label: 'Kilogram(s)'),
      SubOption(id: 'g', label: 'Gram(s)'),
      SubOption(id: 'ounce', label: 'Ounce(s)'),
      SubOption(id: 'tonne', label: 'Tonne(s)'),
      SubOption(id: 'pound', label: 'Pound(s)'),
      SubOption(id: 'mg', label: 'Milligram(s)'),
    ],
  ),
  MeasurementCategory(
    id: 'volume',
    label: 'Volume',
    example: 'l',
    subOptions: [
      SubOption(id: 'l', label: 'Liter(s)'),
      SubOption(id: 'ml', label: 'Milliliter(s)'),
      SubOption(id: 'm3', label: 'Cubic Meter(s)'),
      SubOption(id: 'cm3', label: 'Cubic Centimeter(s)'),
      SubOption(id: 'mm3', label: 'Cubic Millimeter(s)'),
    ],
  ),
  MeasurementCategory(
    id: 'area',
    label: 'Area',
    example: 'm2',
    subOptions: [
      SubOption(id: 'm2', label: 'Square Meter(s)'),
      SubOption(id: 'cm2', label: 'Square Centimeter(s)'),
      SubOption(id: 'mm2', label: 'Square Millimeter(s)'),
      SubOption(id: 'ft2', label: 'Square Feet(s)'),
    ],
  ),
];

// Backward compatibility alias
final List<MeasurementCategory> sellingUnits = sellingUnitCategories;
