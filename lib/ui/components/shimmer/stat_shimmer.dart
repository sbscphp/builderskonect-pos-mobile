import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/pos/stat_card.dart';

class StatShimmer extends StatelessWidget {
  const StatShimmer({
    super.key,
    this.row = 2,
  });

  final int row;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          row,
          (i) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: i == row - 1 ? 0 : 16,
              ),
              child: RowStat(),
            );
          },
        ),
      ),
    );
  }
}

class RowStat extends StatelessWidget {
  const RowStat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: "Total Orders",
            value: "₦1.1 M",
            bgColor: AppColors.blueFF,
            borderColor: AppColors.blue5,
            amountColor: AppColors.primaryBlue,
            onTap: () {},
          ),
        ),
        XBox(16),
        Expanded(
          child: StatCard(
            title: "Pending Pending",
            value: "18100",
            bgColor: AppColors.magentaF8,
            borderColor: AppColors.magenta4,
            borderButtomColor: AppColors.magenta2,
            amountColor: AppColors.magenta6,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
