import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final searchC = TextEditingController();
  final searchFocus = FocusNode();

  @override
  void dispose() {
    searchC.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "Inventory",
        ),
        body: ListView(
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
                    title: "Inventory Overview",
                    subTitle: "View and manage products inventory.",
                  ),
                  YBox(16),
                  Container(
                    width: double.infinity,
                    height: Sizer.height(200),
                    padding: EdgeInsets.all(Sizer.radius(16)),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.blueDD9),
                      borderRadius: BorderRadius.circular(Sizer.radius(4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProductColText(
                          title: "TOTAL PRODUCTS VALUE",
                          value: "2",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Total Products",
                              value: "2",
                              valueTextSize: 12,
                              valueColor: AppColors.green1A,
                            ),
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Available",
                              value: "2",
                              valueTextSize: 12,
                              valueColor: AppColors.red2D,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Sold-out Products",
                              value: "2",
                              valueTextSize: 12,
                              valueColor: AppColors.green1A,
                            ),
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Low Stocks",
                              value: "2",
                              valueTextSize: 12,
                              valueColor: AppColors.red2D,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  YBox(40),
                  FilterHeader(
                    title: "Inventory List",
                    subTitle: "See all products in inventory",
                    onFilter: () {},
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: searchC,
                    focusNode: searchFocus,
                    isRequired: false,
                    showLabelHeader: false,
                    hintText: "Search by product id, name etc.",
                    onChanged: (value) {
                      setState(() {});
                    },
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (searchC.text.isNotEmpty)
                          InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(Sizer.width(10)),
                              child: Icon(
                                Icons.close,
                                size: Sizer.width(20),
                                color: AppColors.gray500,
                              ),
                            ),
                          ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.all(Sizer.width(10)),
                            decoration: BoxDecoration(
                                border: Border(
                              left: BorderSide(
                                color: AppColors.neutral5,
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
                    itemCount: 10,
                    separatorBuilder: (_, __) => HDivider(),
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onTap: () {},
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
                                        child: MyCachedNetworkImage(),
                                      ),
                                      XBox(16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Premium Cement",
                                              style: textTheme.text14?.medium,
                                            ),
                                            YBox(4),
                                            Text(
                                              "10kg Smooth",
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
                                OrderStatus(status: "Active"),
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
                                        style:
                                            textTheme.text12?.medium.copyWith(
                                          color: AppColors.gray500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "N 2000",
                                        style:
                                            textTheme.text12?.medium.copyWith(
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
                                        style:
                                            textTheme.text12?.medium.copyWith(
                                          color: AppColors.gray500,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "280 left",
                                        style:
                                            textTheme.text12?.medium.copyWith(
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
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
