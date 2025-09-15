// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:flutter_html/flutter_html.dart';

class ViewProductDetailsScreen extends ConsumerStatefulWidget {
  const ViewProductDetailsScreen({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  ConsumerState<ViewProductDetailsScreen> createState() =>
      _ViewProductScreenState();
}

class _ViewProductScreenState extends ConsumerState<ViewProductDetailsScreen> {
  ProductModel? productDetails;
  int currentMainImageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productDetails = widget.product;
      setState(() {});
    });
  }

  _getProductDetails() async {
    final prodVm = ref.read(productInventoryVmodel);
    final res = await prodVm.viewProductInventory(
      productId: widget.product.id ?? "",
    );
    if (res.success) {
      productDetails = res.data;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "View Product",
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _getProductDetails();
          },
          child: ListView(
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
                    // main product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Sizer.radius(4)),
                      child: MyCachedNetworkImage(
                        height: Sizer.height(270),
                        width: Sizer.screenWidth,
                        imageUrl: _getCurrentMainImage(),
                        fit: BoxFit.cover,
                      ),
                    ),
                    YBox(24),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          ...List.generate((productDetails?.media ?? []).length,
                              (i) {
                            final img = productDetails?.media?[i];
                            final isSelected = i == currentMainImageIndex;
                            return Padding(
                              padding: EdgeInsets.only(
                                right: Sizer.width(16),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentMainImageIndex = i;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: isSelected
                                        ? Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            width: 2,
                                          )
                                        : null,
                                    borderRadius:
                                        BorderRadius.circular(Sizer.radius(4)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(Sizer.radius(4)),
                                    child: MyCachedNetworkImage(
                                      height: Sizer.height(56),
                                      width: Sizer.width(56),
                                      imageUrl: img,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                    YBox(24),
                    Text(
                      productDetails?.name ?? "",
                      style: textTheme.text16?.medium,
                    ),
                    Text(
                      "${productDetails?.productType ?? "N/A"} (SKU):${productDetails?.sku ?? "N/A"}  ",
                      style: textTheme.text14?.copyWith(
                        color: colorScheme.black45,
                      ),
                    ),
                    YBox(16),
                    Text(
                      "${AppUtils.nairaSymbol}${AppUtils.formatNumber(
                        decimalPlaces: 2,
                        number:
                            double.tryParse(productDetails?.costPrice ?? "0") ??
                                0,
                      )}/pieces",
                      style: textTheme.text16?.medium,
                    ),
                    YBox(16),
                    RichText(
                      text: TextSpan(
                        style: textTheme.text14,
                        children: const [
                          TextSpan(
                            text: "Size: ",
                          ),
                          TextSpan(
                            text: "50kg:",
                          ),
                        ],
                      ),
                    ),
                    YBox(24),
                    RichText(
                      text: TextSpan(
                        style: textTheme.text14,
                        children: [
                          TextSpan(
                            text: "Category: ",
                          ),
                          TextSpan(
                            text: productDetails?.category ?? "N/A",
                          ),
                        ],
                      ),
                    ),
                    YBox(24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tags:",
                          style: textTheme.text14,
                        ),
                        XBox(8),
                        Expanded(
                          child: Wrap(
                            spacing: Sizer.width(10),
                            runSpacing: Sizer.height(10),
                            children: _buildTagWidgets(),
                          ),
                        )
                      ],
                    ),
                    YBox(24),

                    // Description
                    Html(
                      data: productDetails?.description ?? "",
                      style: {
                        "p.fancy": Style(
                          textAlign: TextAlign.center,
                          padding: HtmlPaddings.all(16),
                          backgroundColor: Colors.grey,
                          margin: Margins(
                              left: Margin(50, Unit.px), right: Margin.auto()),
                          width: Width(300, Unit.px),
                          fontWeight: FontWeight.bold,
                        ),
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  String _getCurrentMainImage() {
    if (productDetails?.media != null &&
        productDetails!.media!.isNotEmpty &&
        currentMainImageIndex < productDetails!.media!.length) {
      return productDetails!.media![currentMainImageIndex];
    }
    return productDetails?.primaryMediaUrl ?? "";
  }

  List<Widget> _buildTagWidgets() {
    if (productDetails?.tags == null || productDetails!.tags!.isEmpty) {
      return [
        Text(
          "N/A",
        )
      ];
    }

    // Split the comma-separated tags string
    final tagsList = productDetails!.tags!
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();

    return tagsList.map((tag) => TagWidget(tag: tag)).toList();
  }
}
