// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ViewSalesOrderScreen extends ConsumerStatefulWidget {
  const ViewSalesOrderScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ViewSalesOrderScreen> createState() =>
      _ViewSalesOrderScreenState();
}

class _ViewSalesOrderScreenState extends ConsumerState<ViewSalesOrderScreen>
    with TickerProviderStateMixin {
  bool showListOfItems = false;
  late ScrollController _scrollController;
  late AnimationController _arrowAnimationController;
  final GlobalKey _listItemsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _arrowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salesVmodel).getSalesOrderDetails(widget.id);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _arrowAnimationController.dispose();
    super.dispose();
  }

  void _scrollToListItems() {
    if (_listItemsKey.currentContext != null) {
      // Wait for the animation to complete before scrolling
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_listItemsKey.currentContext != null) {
          final RenderBox renderBox =
              _listItemsKey.currentContext!.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          final screenHeight = MediaQuery.of(context).size.height;

          // Calculate optimal scroll position to center the expanded content
          final targetPosition =
              _scrollController.offset + position.dy - (screenHeight * 0.2);

          _scrollController.animateTo(
            targetPosition.clamp(
                0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
          );
        }
      });
    }
  }

  bool get isStatusPending =>
      ref.watch(salesVmodel).salesOrdersModel?.paymentStatus?.toLowerCase() ==
      "pending";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final salesVm = ref.watch(salesVmodel);
    return Scaffold(
      appBar: CustomAppbar(
        title: isStatusPending ? "Pending Confirmation" : "View Order",
      ),
      body: Builder(builder: (context) {
        if (salesVm.busy(viewState)) {
          return SizerLoader(
            height: double.infinity,
          );
        }
        if (salesVm.error(viewState)) {
          return ErrorState(
            onPressed: () {
              ref.read(salesVmodel).getSalesOrderDetails(widget.id);
            },
          );
        }
        return ListView(
          controller: _scrollController,
          padding: EdgeInsets.only(
            bottom: Sizer.height(50),
          ),
          children: [
            YBox(16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
              padding: EdgeInsets.symmetric(
                horizontal: Sizer.width(16),
                vertical: Sizer.height(16),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizer.radius(4)),
                color: colorScheme.white,
              ),
              child: Column(
                children: [
                  FilterHeader(
                    title: "Order Details",
                    subTitle: "View order information below",
                  ),
                  YBox(16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(Sizer.radius(16)),
                    decoration: BoxDecoration(
                      color: AppColors.neutral3,
                      borderRadius: BorderRadius.circular(Sizer.radius(4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileColText(
                          title: "Order ID -",
                          title2: "ONLINE",
                          subTitle:
                              "#${salesVm.salesOrdersModel?.orderNumber ?? ""}",
                        ),
                        YBox(16),
                        ProfileColText(
                          title: "Customer Name",
                          subTitle:
                              salesVm.salesOrdersModel?.customer?.name ?? "N/A",
                        ),
                        YBox(16),
                        ProfileColText(
                          title: "Email",
                          subTitle: salesVm.salesOrdersModel?.customer?.email ??
                              "N/A",
                        ),
                        YBox(16),
                        ProfileColText(
                          title: "Phone number",
                          subTitle: salesVm.salesOrdersModel?.customer?.phone ??
                              "N/A",
                        ),
                        YBox(16),
                        ProfileColText(
                          title: "Total Items",
                          subTitle: (salesVm.salesOrdersModel?.itemsCount ?? 0)
                              .toString(),
                        ),
                        YBox(16),
                        Text(
                          "Payment Method",
                          style: textTheme.text12?.copyWith(
                            color: AppColors.grey175,
                          ),
                        ),
                        YBox(4),
                        ...List.generate(
                          salesVm.salesOrdersModel?.paymentMethods?.length ?? 0,
                          (i) => Padding(
                            padding: EdgeInsets.only(
                              bottom: Sizer.height(8),
                            ),
                            child: Text(
                              salesVm.salesOrdersModel?.paymentMethods?[i]
                                      .method ??
                                  "N/A",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.text14?.medium.copyWith(
                                color: AppColors.black23,
                              ),
                            ),
                          ),
                        ),
                        YBox(16),
                        Text(
                          "Payment Status",
                          style: textTheme.text12?.copyWith(
                            color: AppColors.grey175,
                          ),
                        ),
                        YBox(6),
                        OrderStatus(
                          status:
                              salesVm.salesOrdersModel?.paymentStatus ?? "N/A",
                        ),
                        if (!isStatusPending)
                          Padding(
                            padding: EdgeInsets.only(
                              top: Sizer.height(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Order Status",
                                  style: textTheme.text12?.copyWith(
                                    color: AppColors.grey175,
                                  ),
                                ),
                                YBox(6),
                                OrderStatus(
                                  status:
                                      salesVm.salesOrdersModel?.status ?? "N/A",
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            YBox(16),
            Container(
              key: _listItemsKey,
              margin: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
              padding: EdgeInsets.symmetric(
                horizontal: Sizer.width(16),
                vertical: Sizer.height(16),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizer.radius(4)),
                color: colorScheme.white,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "List of Items (${salesVm.salesOrdersModel?.itemsCount ?? 0})",
                          style: textTheme.text16?.medium.copyWith(
                            color: AppColors.black23,
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              showListOfItems = !showListOfItems;
                            });

                            if (showListOfItems) {
                              _arrowAnimationController.forward();
                              _scrollToListItems();
                            } else {
                              _arrowAnimationController.reverse();
                            }
                          },
                          borderRadius: BorderRadius.circular(Sizer.radius(12)),
                          child: Container(
                            padding: EdgeInsets.all(Sizer.radius(8)),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(Sizer.radius(12)),
                              color: showListOfItems
                                  ? AppColors.primaryBlue.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: AnimatedBuilder(
                              animation: _arrowAnimationController,
                              builder: (context, child) {
                                return Transform.rotate(
                                  angle:
                                      _arrowAnimationController.value * 3.14159,
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: Sizer.radius(24),
                                    color: showListOfItems
                                        ? AppColors.primaryBlue
                                        : AppColors.black23,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    child: showListOfItems
                        ? Column(
                            children: [
                              YBox(16),
                              AnimatedOpacity(
                                opacity: showListOfItems ? 1.0 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(Sizer.radius(8)),
                                    border: Border.all(
                                      color: AppColors.neutral5,
                                      width: 1,
                                    ),
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(Sizer.radius(12)),
                                    itemCount: salesVm.salesOrdersModel
                                            ?.lineItems?.length ??
                                        0,
                                    separatorBuilder: (_, __) => Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Sizer.height(8)),
                                      child: HDivider(),
                                    ),
                                    itemBuilder: (ctx, i) {
                                      final lineItem = salesVm
                                          .salesOrdersModel?.lineItems?[i];
                                      return AnimatedContainer(
                                        duration: Duration(
                                            milliseconds: 200 + (i * 50)),
                                        curve: Curves.easeOutBack,
                                        child: SaleDetailsListTile(
                                          productImage:
                                              lineItem?.productMediaUrl ?? "",
                                          productTitle: lineItem?.product ?? "",
                                          subTitle: lineItem?.productType ?? "",
                                          sku: lineItem?.productSku ?? "",
                                          price:
                                              lineItem?.unitCost?.toString() ??
                                                  "",
                                          totalAmount:
                                              lineItem?.totalCost?.toString() ??
                                                  "",
                                          quantity:
                                              lineItem?.quantity?.toString() ??
                                                  "",
                                          discount: lineItem?.discountedAmount
                                                  ?.toString() ??
                                              "",
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              YBox(8),
                            ],
                          )
                        : const SizedBox.shrink(),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

class SaleDetailsListTile extends StatelessWidget {
  const SaleDetailsListTile({
    super.key,
    this.onTap,
    required this.productImage,
    required this.productTitle,
    required this.subTitle,
    required this.sku,
    required this.price,
    required this.totalAmount,
    required this.quantity,
    required this.discount,
  });
  final VoidCallback? onTap;
  final String productImage;
  final String productTitle;
  final String subTitle;
  final String sku;
  final String price;
  final String totalAmount;
  final String quantity;
  final String discount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ProductWithSkuListTile(
            productImage: productImage,
            productTitle: productTitle,
            subTitle: subTitle,
            sku: sku,
          ),
          YBox(10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Price: ",
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                    TextSpan(
                      text: price,
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
                      text: "Total Amount: ",
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                    TextSpan(
                      text: totalAmount,
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.neutral11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (quantity != "")
            _buildRow(textTheme, title: "Quantity:", value: quantity),
          if (discount != "")
            _buildRow(textTheme, title: "Discount:", value: discount),
        ],
      ),
    );
  }

  Widget _buildRow(
    TextTheme textTheme, {
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: Sizer.height(8),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: textTheme.text12?.medium,
          ),
          XBox(16),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: Sizer.width(12),
                vertical: Sizer.height(5),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizer.radius(4)),
                border: Border.all(
                  color: AppColors.neutral5,
                ),
              ),
              child: Text(
                value,
                style: textTheme.text14?.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
