import 'package:builders_konnect/core/core.dart';

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
    final colorScheme = Theme.of(context).colorScheme;
    switch (status) {
      case "processing":
      case "pending":
        return {
          "bgColor": AppColors.yellowE6,
          "textColor": AppColors.yellow6,
          "borderColor": AppColors.yellow3
        };
      case "not active":
      case "deactivated":
      case "declined":
        return {
          "bgColor": AppColors.red1,
          "textColor": AppColors.red2D,
          "borderColor": AppColors.red3,
        };
      case "delivered":
      case "completed":
      case "available":
      case "active":
      case "approved":
      case "received":
        return {
          "bgColor": AppColors.greenED,
          "textColor": AppColors.green1A,
          "borderColor": AppColors.green4,
        };
      case "draft":
      case "request sent":
        return {
          "bgColor": AppColors.neutral2,
          "textColor": colorScheme.black85,
          "borderColor": AppColors.neutral5,
        };
      case "paid":
      case "action taken":
        return {
          "bgColor": AppColors.dayBreakBlue,
          "textColor": colorScheme.primaryColor,
          "borderColor": AppColors.dayBreakBlue3,
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
