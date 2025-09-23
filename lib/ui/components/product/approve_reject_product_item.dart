import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ApproveRejectProductItem extends StatefulWidget {
  const ApproveRejectProductItem(
      {super.key,
      required this.productTitle,
      required this.productImage,
      required this.subTitle,
      required this.status,
      this.sku,
      this.onTap,
      this.qty});

  final String productTitle;
  final String productImage;
  final String subTitle;
  final String status;
  final VoidCallback? onTap;
  final String? qty;
  final String? sku;

  @override
  State<ApproveRejectProductItem> createState() =>
      _ApproveRejectProductItemState();
}

class _ApproveRejectProductItemState extends State<ApproveRejectProductItem> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.status == 'approved' || widget.status == 'pending')
              InkWell(
                onTap: () {
                  setState(() {
                    _isSelected = !_isSelected;
                    widget.onTap?.call();
                  });
                },
                child: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                      color: _isSelected
                          ? AppColors.primaryBlue
                          : Colors.transparent,
                      border: Border.all(color: AppColors.gray500)),
                  child: Center(
                    child: Icon(
                      Icons.done,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            if (widget.status == 'approved' || widget.status == 'pending')
              SizedBox(
                width: 12.w,
              ),
            SizedBox(
              width: Sizer.width(26),
              height: Sizer.height(26),
              child: MyCachedNetworkImage(
                imageUrl: widget.productImage,
                fit: BoxFit.cover,
              ),
            ),
            XBox(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.productTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.text14,
                  ),
                  YBox(4),
                  Text(
                    widget.subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.status != 'pending')
              OrderStatus(
                status: widget.status,
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "SKU",
                    style: textTheme.text14?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  if (widget.sku != null) YBox(4),
                  if (widget.sku != null)
                    Text(
                      widget.sku!,
                      style: textTheme.text12,
                    ),
                ],
              ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Quantity: ",
                style: textTheme.text12?.medium.copyWith(
                  color: AppColors.gray500,
                ),
              ),
              TextSpan(
                text: widget.qty,
                style: textTheme.text12?.medium.copyWith(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
