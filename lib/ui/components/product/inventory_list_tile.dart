import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class InventoryListTile extends StatelessWidget {
  const InventoryListTile({
    super.key,
    required this.productTitle,
    required this.productImage,
    required this.subTitle,
    required this.status,
    required this.date,
    this.onTap,
  });

  final String productTitle;
  final String productImage;
  final String subTitle;
  final String status;
  final String date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: Sizer.width(26),
                      height: Sizer.height(26),
                      child: MyCachedNetworkImage(
                        imageUrl: productImage,
                      ),
                    ),
                    XBox(8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.text14?.medium,
                          ),
                          YBox(4),
                          Text(
                            subTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.text12?.copyWith(
                              color: colorScheme.black45,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              XBox(8),
              Column(
                children: [
                  OrderStatus(status: status),
                  YBox(4),
                  Text(
                    date,
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
          YBox(10),
        ],
      ),
    );
  }
}
