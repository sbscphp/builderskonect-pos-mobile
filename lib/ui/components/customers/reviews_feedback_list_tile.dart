import 'package:builders_konnect/core/core.dart';
import 'package:flutter_rating/flutter_rating.dart';

class ReviewsFeedbackListTile extends StatelessWidget {
  const ReviewsFeedbackListTile({
    super.key,
    required this.productImage,
    required this.productName,
    required this.productType,
    required this.numOfReviews,
    this.rating,
    this.onTap,
  });

  final String productImage;
  final String productName;
  final String productType;
  final String numOfReviews;
  final double? rating;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
                    numOfReviews,
                    style: textTheme.text12,
                  ),
                ],
              ),
            ],
          ),
          YBox(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "ID: ",
                        style: textTheme.text12?.medium.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                      TextSpan(
                        text: "#2826492",
                        style: textTheme.text12?.medium.copyWith(
                          color: colorScheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              XBox(30),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Category: ",
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                    TextSpan(
                      text: "Building Materials",
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.neutral11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
