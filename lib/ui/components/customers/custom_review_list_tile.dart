import 'package:builders_konnect/core/core.dart';
import 'package:flutter_rating/flutter_rating.dart';

class CustomerReviewListTile extends StatelessWidget {
  const CustomerReviewListTile({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    this.subTitle2,
    required this.date,
    this.rating,
    this.leadWidget,
    this.onTap,
  });

  final String image;
  final String title;
  final String subTitle;
  final String? subTitle2;
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
                  imageUrl: image,
                  fit: BoxFit.cover,
                ),
          ),
          XBox(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.text14,
                ),
                YBox(4),
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                    children: [
                      TextSpan(text: subTitle),
                      if (subTitle2 != null)
                        TextSpan(
                            text: subTitle2,
                            style: textTheme.text12?.medium.copyWith(
                              color: colorScheme.primaryColor,
                            )),
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
              StarRating(
                rating: rating ?? 0,
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
