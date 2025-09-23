import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductReviewsTab extends ConsumerStatefulWidget {
  const ProductReviewsTab({super.key});

  @override
  ProductReviewsTabState createState() => ProductReviewsTabState();
}

class ProductReviewsTabState extends ConsumerState<ProductReviewsTab> {
  final searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref
          .read(productInventoryVmodel)
          .getInventoryProducts(productReview: true);
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final productVm = ref.watch(productInventoryVmodel);
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: Sizer.width(16),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Sizer.radius(16),
        ),
        decoration: BoxDecoration(
          color: colorScheme.white,
          borderRadius: BorderRadius.circular(Sizer.radius(4)),
        ),
        child: Column(
          children: [
            YBox(16),
            FilterHeader(
              title: "Reviews and Feedbacks",
              subTitle: "View and manage reviews here",
            ),
            YBox(16),
            CustomTextField(
              controller: searchC,
              isRequired: false,
              showLabelHeader: false,
              hintText: "Search reviews.",
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
            Expanded(
              child: LoadableContentBuilder(
                isBusy: productVm.busy(getState),
                isError: productVm.error(getState),
                items: productVm.inventoryProducts,
                loadingBuilder: (p0) {
                  return SizerLoader(
                    height: double.infinity,
                  );
                },
                emptyBuilder: (context) {
                  return Center(
                    child: EmptyListState(text: "No data"),
                  );
                },
                errorBuilder: (context) {
                  return Center(
                    child: ErrorState(
                      onPressed: () {
                        ref
                            .read(productInventoryVmodel)
                            .getInventoryProducts(productReview: true);
                      },
                    ),
                  );
                },
                contentBuilder: (context) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(productInventoryVmodel)
                          .getInventoryProducts(productReview: true);
                    },
                    child: ListView.separated(
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: Sizer.height(14),
                        bottom: Sizer.height(100),
                      ),
                      itemCount: productVm.inventoryProducts.length,
                      separatorBuilder: (_, __) => HDivider(),
                      itemBuilder: (ctx, i) {
                        final p = productVm.inventoryProducts[i];
                        return ReviewsFeedbackListTile(
                          productId: p.id ?? '',
                          category: p.category ?? '',
                          productImage: p.primaryMediaUrl ?? '',
                          productName: p.name ?? '',
                          productType: p.productType ?? '',
                          numOfReviews: p.totalReviews?.toString() ?? '0',
                          rating: p.ratings?.toDouble() ?? 0,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutePath.feedbackReviewDetailsScreen,
                              arguments: p,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
