import 'package:builders_konnect/core/core.dart';
import 'package:flutter_rating/flutter_rating.dart';

class CustomerReviewListTile extends StatelessWidget {
  const CustomerReviewListTile({
    super.key,
    required this.productImage,
    required this.productName,
    required this.productType,
    required this.date,
    this.rating,
    this.leadWidget,
    this.onTap,
  });

  final String productImage;
  final String productName;
  final String productType;
  final String date;
  final double? rating;
  final Widget? leadWidget;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox(
            width: Sizer.width(26),
            height: Sizer.height(26),
            child: leadWidget ??
                MyCachedNetworkImage(
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
                  productName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.text14,
                ),
                YBox(4),
                Text(
                  productType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.text12?.copyWith(
                    color: colorScheme.black45,
                  ),
                ),
              ],
            ),
          ),
          XBox(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              StarRating(
                rating: 4,
                size: Sizer.radius(15),
                color: AppColors.yellow6,
                allowHalfRating: false,
                onRatingChanged: (rating) {},
              ),
              YBox(8),
              Text(
                date,
                style: textTheme.text12,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
