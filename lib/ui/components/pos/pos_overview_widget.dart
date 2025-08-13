import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductOverviewWidget extends ConsumerStatefulWidget {
  const ProductOverviewWidget({
    super.key,
  });

  @override
  ConsumerState<ProductOverviewWidget> createState() =>
      _ProductOverviewWidgetState();
}

class _ProductOverviewWidgetState extends ConsumerState<ProductOverviewWidget> {
  final productCatColors = [
    const Color(0xFF4F8EF7),
    const Color(0xFF00BCD4),
    const Color(0xFF4CAF50),
    const Color(0xFFFFA726),
    const Color(0xFFEF5350),
    const Color(0xFF9C27B0),
    const Color(0xFF795548),
  ];

  @override
  Widget build(BuildContext context) {
    final dashVm = ref.watch(dashboardVmodel);

    // Calculate total revenue for percentage calculation
    final categories = dashVm.productOverviewModel?.topCategories ?? [];
    final totalRevenue = categories.fold<double>(
      0.0,
      (sum, category) =>
          sum + (double.tryParse(category.totalRevenue ?? '0') ?? 0),
    );

    return OverviewWidget(
      onFilterTap: () {
        ModalWrapper.bottomSheet(
            context: context,
            widget: FilterDataModal(
              title: "Filter Products",
              subtitle: "Filter products by multiple criteria",
              dateTitle: "Product Added Date",
              selectorGroups: [
                SelectorGroup(
                  key: "stock_status",
                  title: "Stock Status",
                  options: ["All", "In Stock", "Out of Stock", "Low Stock"],
                  selectedValue: "All",
                ),
                SelectorGroup(
                  key: "category",
                  title: "Product Category",
                  options: [
                    "Electronics",
                    "Clothing",
                    "Home & Garden",
                    "Sports",
                    "Books"
                  ],
                ),
              ],
              showPriceRange: false,
              priceRangeTitle: "Product Price Range",
              priceFromLabel: "Min Price",
              priceToLabel: "Max Price",
              onFilter: (filterData) {
                printty("Filter applied: $filterData");
                // Handle the filter data here
                // filterData will contain:
                // - startDate, endDate (if date selected)
                // - selectorGroups: Map<String, String> with selected values
                // - priceFrom, priceTo (if price range entered)
              },
              onReset: () {
                printty("Filters reset");
                // Handle reset action here
              },
            ));
      },
      title: 'Products Overview',
      subtitle: 'View top selling products and total amount sold',
      data: List.generate(
        categories.length,
        (i) {
          final amount =
              double.tryParse(categories[i].totalRevenue ?? '0') ?? 0;
          final percentage =
              totalRevenue > 0 ? (amount / totalRevenue) * 100 : 0.0;

          return OverviewData(
            name: categories[i].categoryName ?? '',
            amount: amount,
            color: productCatColors[i % productCatColors.length],
            percentage: percentage,
          );
        },
      ),
      totalValue:
          int.tryParse(dashVm.productOverviewModel?.productsCount ?? '0') ?? 0,
      totalLabel: 'Products sold',
      valuePrefix: '₦',
    );
  }
}
