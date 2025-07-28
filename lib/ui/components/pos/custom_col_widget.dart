import 'package:builders_konnect/core/core.dart';

class CustomColWidget extends StatelessWidget {
  const CustomColWidget({
    super.key,
    required this.firstColText,
    required this.secondColText,
    required this.status,
    required this.date,
    this.onTap,
  });

  final String firstColText;
  final String secondColText;
  final String status;
  final DateTime date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  firstColText,
                  style: textTheme.text14?.medium
                      .copyWith(color: AppColors.primaryBlue),
                ),
                YBox(4),
                Text(
                  secondColText,
                  style: textTheme.text14?.medium.copyWith(
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OrderStatus(status: status),
              YBox(8),
              Text(
                AppUtils.dayWithSuffixMonthAndYear(date),
                style: textTheme.text12?.medium.copyWith(
                  color: AppColors.gray500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderStatus extends StatefulWidget {
  const OrderStatus({
    super.key,
    required this.status,
  });

  final String status;

  @override
  State<OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(8),
        vertical: Sizer.height(2),
      ),
      decoration: BoxDecoration(
          color: getColor(widget.status)["bgColor"],
          borderRadius: BorderRadius.circular(Sizer.radius(2)),
          border: Border.all(
            color: getColor(widget.status)["borderColor"] ?? AppColors.yellow3,
          )),
      child: Text(
        widget.status.capitalizeFirst,
        style: textTheme.text12?.medium.copyWith(
          color: getColor(widget.status)["textColor"] ?? AppColors.yellow6,
        ),
      ),
    );
  }

  Map<String, Color> getColor(String status) {
    final status = widget.status.toLowerCase();
    switch (status) {
      case "processing":
        return {
          "bgColor": AppColors.yellowE6,
          "textColor": AppColors.yellow6,
          "borderColor": AppColors.yellow3
        };
      case "pending":
        return {
          "bgColor": AppColors.red1,
          "textColor": AppColors.red2D,
          "borderColor": AppColors.red3,
        };
      case "delivered":
        return {
          "bgColor": AppColors.greenED,
          "textColor": AppColors.green1A,
          "borderColor": AppColors.green4,
        };
      default:
        return {
          "bgColor": AppColors.yellowE6,
          "textColor": AppColors.yellow6,
          "borderColor": AppColors.yellow3,
        };
    }
  }
}
