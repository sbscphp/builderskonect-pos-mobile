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

final List<MeasurementCategory> measuringUnitCategories = [
  MeasurementCategory(
    id: 'linear',
    label: 'Linear Measurement',
    example: 'LxWxH',
    subOptions: [
      SubOption(
        id: 'L×W×H',
        label: 'Length × Width × Height',
        description: '(boxes, panels, cartons)',
      ),
      SubOption(
        id: 'L×D',
        label: 'Length × Diameter',
        description: '(pipes, rods)',
      ),
      SubOption(
        id: 'L',
        label: 'Length Only',
        description: '(liquids, containers)',
      ),
      SubOption(
        id: 'feet',
        label: 'Feet',
      ),
      SubOption(
        id: 'D',
        label: 'Diameter Only',
      ),
    ],
  ),
  MeasurementCategory(
    id: 'volume',
    label: 'Volume Measurement',
    example: 'Ltr',
    subOptions: [
      SubOption(id: 'capacity', label: 'Capacity', description: '(Litres)'),
      SubOption(id: 'volume', label: 'Volume', description: '(Cubic Meters)'),
      SubOption(id: 'displacement', label: 'Displacement', description: '(CC)'),
    ],
  ),
  MeasurementCategory(
    id: 'area',
    label: 'Area Measurement',
    example: 'sqm',
    subOptions: [
      SubOption(
          id: 'coverage', label: 'Coverage', description: '(Square Meters)'),
      SubOption(
          id: 'surface', label: 'Surface Area', description: '(Square Feet)'),
    ],
  ),
  MeasurementCategory(
    id: 'weight',
    label: 'Weight Based',
    example: 'kg',
    subOptions: [
      SubOption(id: 'perUnit', label: 'Per Unit Weight'),
      SubOption(id: 'total', label: 'Total Weight'),
    ],
  ),
  MeasurementCategory(
    id: 'complex',
    label: 'Complex / Multiple',
    example: 'custom',
    subOptions: [
      SubOption(id: 'multiple', label: 'Multiple Parameters'),
      SubOption(id: 'custom', label: 'Custom Measurement'),
    ],
  ),
];

final Map<String, List<String>> _dimensionUnitsMap = {
  'L×W×H': ['mm', 'cm', 'm', 'in', 'ft'],
  'L×D': ['mm', 'cm', 'm', 'in', 'ft'],
  'D': ['mm', 'cm', 'm', 'in', 'ft'],
  'L': ['mm', 'cm', 'm', 'km', 'in', 'ft', 'yd', 'mile'],
  'capacity': ['mL', 'L', 'kL', 'gal', 'pint', 'quart'],
  'volume': ['cm³', 'm³', 'in³', 'ft³'],
  'displacement': ['cc', 'L', 'm³'],
  'coverage': ['cm²', 'm²', 'km²', 'in²', 'ft²', 'yd²', 'acre', 'hectare'],
  'surface': ['cm²', 'm²', 'ft²', 'in²'],
  'perUnit': ['g', 'kg', 'mg', 'lb', 'oz'],
  'total': ['g', 'kg', 'mg', 'tonne', 'lb', 'oz'],
};

// Backward compatibility alias
final List<MeasurementCategory> sellingUnits = sellingUnitCategories;
final List<MeasurementCategory> measuringUnits = measuringUnitCategories;
List<String> getUnitsForDimensionUnit(String unit) =>
    _dimensionUnitsMap[unit] ?? [];
