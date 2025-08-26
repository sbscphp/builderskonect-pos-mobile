import 'package:builders_konnect/core/core.dart';

class ProductWithSkuListTile extends StatelessWidget {
  const ProductWithSkuListTile({
    super.key,
    required this.productTitle,
    required this.productImage,
    required this.subTitle,
    required this.sku,
  });

  final String productTitle;
  final String productImage;
  final String subTitle;
  final String sku;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                width: Sizer.width(26),
                height: Sizer.height(26),
                child: MyCachedNetworkImage(
                  imageUrl: productImage,
                  fit: BoxFit.cover,
                ),
              ),
              XBox(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.text14,
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
        XBox(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "SKU",
              style: textTheme.text14?.copyWith(
                color: colorScheme.black45,
              ),
            ),
            YBox(4),
            Text(
              sku,
              style: textTheme.text12,
            ),
          ],
        ),
      ],
    );
  }
}
