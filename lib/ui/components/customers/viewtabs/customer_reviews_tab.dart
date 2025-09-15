import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter_rating/flutter_rating.dart';

class CustomerReviewsTab extends ConsumerStatefulWidget {
  const CustomerReviewsTab({super.key});

  @override
  CustomerReviewsTabState createState() => CustomerReviewsTabState();
}

class CustomerReviewsTabState extends ConsumerState<CustomerReviewsTab> {
  final searchC = TextEditingController();

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.only(
        left: Sizer.width(16),
        right: Sizer.width(16),
        bottom: Sizer.height(50),
      ),
      children: [
        YBox(16),
        Container(
          padding: EdgeInsets.all(Sizer.radius(16)),
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterHeader(
                title: "Reviews",
                subTitle: "See all reviews by this customer",
                onFilter: () {},
              ),
              YBox(16),
              CustomTextField(
                controller: searchC,
                isRequired: false,
                showLabelHeader: false,
                hintText: "Search by product id, name etc.",
                onChanged: (value) {
                  setState(() {});
                },
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(Sizer.width(14)),
                        decoration: BoxDecoration(
                            border: Border(
                          left: BorderSide(
                            color: AppColors.neutral5,
                            width: 1,
                          ),
                        )),
                        child: SvgPicture.asset(AppSvgs.search),
                      ),
                    ),
                  ],
                ),
              ),
              YBox(10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  top: Sizer.height(14),
                ),
                itemCount: 8,
                separatorBuilder: (_, __) => HDivider(),
                itemBuilder: (ctx, i) {
                  return CustomerReviewListTile(
                    productImage: "https://picsum.photos/200/300",
                    productName: "Product Name",
                    productType: "Product Type",
                    date: "2023-01-01",
                    rating: 4,
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomerReviewListTile extends StatelessWidget {
  const CustomerReviewListTile({
    super.key,
    required this.productImage,
    required this.productName,
    required this.productType,
    required this.date,
    this.rating,
  });

  final String productImage;
  final String productName;
  final String productType;
  final String date;
  final double? rating;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
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
              date,
              style: textTheme.text12,
            ),
          ],
        ),
      ],
    );
  }
}
