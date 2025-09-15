import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class WalkInCustomersTab extends ConsumerStatefulWidget {
  const WalkInCustomersTab({super.key});

  @override
  ConsumerState<WalkInCustomersTab> createState() => _WalkInCustomersTabState();
}

class _WalkInCustomersTabState extends ConsumerState<WalkInCustomersTab> {
  final searchC = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final customerVm = ref.read(customerVmodel);
      if (customerVm.walkInCustomerData.isEmpty) {
        customerVm.getCustomerOverview(type: CustomType.offline);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final customerVm = ref.watch(customerVmodel);
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
                title: "Customer Overview",
                subTitle: "Manage online and walk-in customers",
                svgIcon: AppSvgs.circleAdd,
                trailingWidget: NewButtonWidget(
                  onTap: () {
                    Navigator.pushNamed(context, RoutePath.newCustomerScreen);
                  },
                ),
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
                      title: "TOTAL CUSTOMERS",
                      value: customerVm.customerStats?.total.toString() ?? '0',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProductColText(
                          textColor: colorScheme.black85,
                          title: "Online Customers",
                          value: customerVm.onlineCustomerStats?.online
                                  .toString() ??
                              '0',
                          valueTextSize: 12,
                          valueColor: AppColors.primaryBlue,
                        ),
                        ProductColText(
                          textColor: colorScheme.black85,
                          title: "Walk-in Customers",
                          value: customerVm.onlineCustomerStats?.offline
                                  .toString() ??
                              '0',
                          valueTextSize: 12,
                          valueColor: AppColors.purple6,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              YBox(40),
              FilterHeader(
                title: "All Customers",
                subTitle: "See all customers that hav returns your business",
                onFilter: () async {},
              ),
              YBox(16),
              CustomTextField(
                controller: searchC,
                isRequired: false,
                showLabelHeader: false,
                hintText: "Search by customer ID, name etc",
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
              Builder(builder: (context) {
                if (customerVm.busy(getState)) {
                  return SizerLoader(height: 300);
                }
                if (customerVm.walkInCustomerData.isEmpty) {
                  return SizedBox(
                    height: Sizer.height(300),
                    child: EmptyListState(
                      text: "No Data",
                    ),
                  );
                }
                return Column(
                  children: [
                    YBox(10),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: Sizer.height(14),
                        bottom: Sizer.height(50),
                      ),
                      itemCount: customerVm.walkInCustomerData.length,
                      separatorBuilder: (_, __) => HDivider(),
                      itemBuilder: (ctx, i) {
                        final customer = customerVm.walkInCustomerData[i];
                        return CustomerListTile(
                          customerId: " #${customer.customerId ?? ""}",
                          title: customer.name ?? 'N/A',
                          subTitle: customer.email ?? 'N/A',
                          channel: customer.channel?.toLowerCase() == "offline"
                              ? "Walk-in"
                              : customer.channel?.capitalizeFirst ?? "N/A",
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutePath.viewCustomerScreen,
                              arguments: customer,
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}
