import 'package:builders_konnect/core/core.dart';

class PlanFeatureArg {
  final List<PlanFeature> planFeature;
  final String name;
  final PriceItem priceItem;
  final String duration;

  PlanFeatureArg({
    required this.planFeature,
    required this.name,
    required this.duration,
    required this.priceItem,
  });

  // Function that calculates the total cost
  // double get totalCost {
  //   final amount = double.tryParse(priceItem.amount ?? '0') ?? 0;
  //   final discount = double.tryParse(priceItem.discount ?? '0') ?? 0;
  //   final vat = double.tryParse(priceItem.vat ?? '0') ?? 0;

  //   return amount - discount + vat;
  // }
}
