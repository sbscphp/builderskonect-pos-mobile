class SubcriptionArg {
  final bool isUpgrade;
  final String priceItemId;
  final String planName;

  SubcriptionArg({
    this.isUpgrade = false,
    required this.priceItemId,
    required this.planName,
  });
}
