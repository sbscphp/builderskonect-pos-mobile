import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ReturnRefundScreen extends ConsumerStatefulWidget {
  const ReturnRefundScreen({super.key});

  @override
  ConsumerState<ReturnRefundScreen> createState() => _ReturnRefundScreenState();
}

class _ReturnRefundScreenState extends ConsumerState<ReturnRefundScreen> {
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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: CustomAppbar(
          title: "Returns and Refund",
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
                    title: "Returns & Refund Overview",
                    subTitle: "View and manage logged returns ",
                    trailingWidget: NewButtonWidget(
                      onTap: () {
                        Navigator.pushNamed(
                            context, RoutePath.logNewReturnScreen);
                      },
                    ),
                    onFilter: () {},
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
                          title: "TOTAL REFUND VALUE",
                          value: "2",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Total Returns",
                              value: "2",
                              valueTextSize: 12,
                            ),
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Approved Returns",
                              value: "2",
                              valueTextSize: 12,
                              valueColor: AppColors.purple6,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Rejected Returns",
                              value: "2",
                              valueTextSize: 12,
                              valueColor: AppColors.red2D,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  YBox(24),
                  FilterHeader(
                    title: "Logged Returns",
                    subTitle: "See all logged returns your business",
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
                    itemCount: 10,
                    separatorBuilder: (_, __) => HDivider(),
                    itemBuilder: (ctx, i) {
                      return CustomColWidget(
                        firstColText: "#162826",
                        subTitle: "Mainland Store",
                        status: "Expired",
                        date: DateTime.now(),
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
