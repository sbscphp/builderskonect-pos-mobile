import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductWithStatusListTile extends StatelessWidget {
  const ProductWithStatusListTile({
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    SizedBox(
                      width: Sizer.width(26),
                      height: Sizer.height(26),
                      child: MyCachedNetworkImage(
                        imageUrl: AppUtils.dummyImage,
                      ),
                    ),
                    XBox(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productTitle,
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
              OrderStatus(status: status),
            ],
          ),
          YBox(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Amount: ",
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                    TextSpan(
                      text: "N 2000",
                      style: textTheme.text12?.medium.copyWith(
                        color: colorScheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Stock level: ",
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                    TextSpan(
                      text: "280 left",
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
