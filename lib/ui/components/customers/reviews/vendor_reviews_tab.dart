import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class VendorReviewsTab extends ConsumerStatefulWidget {
  const VendorReviewsTab({super.key});

  @override
  VendorReviewsTabState createState() => VendorReviewsTabState();
}

class VendorReviewsTabState extends ConsumerState<VendorReviewsTab> {
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
