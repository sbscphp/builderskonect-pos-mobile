import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomerOrdersTab extends ConsumerStatefulWidget {
  const CustomerOrdersTab({super.key});

  @override
  CustomerOrdersTabState createState() => CustomerOrdersTabState();
}

class CustomerOrdersTabState extends ConsumerState<CustomerOrdersTab> {
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
                title: "Customer Orders",
                subTitle: "View all customer orders below",
              ),
              YBox(16),
              Container(
                width: double.infinity,
                height: Sizer.height(140),
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
                      title: "TOTAL ORDERS VALUE",
                      value:
                          "${AppUtils.nairaSymbol}${AppUtils.formatNumber(decimalPlaces: 2, number: 10300)}",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ProductColText(
                          textColor: colorScheme.black85,
                          title: "Total Orders",
                          value: AppUtils.formatNumber(number: 10),
                          valueTextSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              YBox(24),
              FilterHeader(
                title: "All Orders",
                subTitle: "See all orders by this customer",
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
                  return CustomColWidget(
                    firstColText: "#12746398",
                    subTitle: "total items: ",
                    subTitle2: "2",
                    status: "Completed",
                    date: DateTime.now(),
                    onTap: () {},
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
