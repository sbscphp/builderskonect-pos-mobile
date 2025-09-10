import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductWithStatusListTile extends StatelessWidget {
  const ProductWithStatusListTile({
    super.key,
    required this.productTitle,
    required this.productImage,
    required this.subTitle,
    required this.subTitle1,
    required this.subValue1,
    required this.subTitle2,
    required this.subValue2,
    required this.status,
    this.onTap,
  });

  final String productTitle;
  final String productImage;
  final String subTitle;
  final String subTitle1;
  final String subValue1;
  final String subTitle2;
  final String subValue2;
  final String status;
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
                            style: textTheme.text14?.medium,
                          ),
                          YBox(4),
                          Text(
                            subTitle,
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
              XBox(20),
              OrderStatus(status: status),
            ],
          ),
          YBox(10),
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
                        text: subTitle1,
                        style: textTheme.text12?.medium.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                      TextSpan(
                        text: subValue1,
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
                      text: subTitle2,
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                    TextSpan(
                      text: subValue2,
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.neutral11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
