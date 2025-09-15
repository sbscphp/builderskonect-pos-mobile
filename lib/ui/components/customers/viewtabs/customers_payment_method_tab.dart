import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomersPaymentMethodTab extends ConsumerStatefulWidget {
  const CustomersPaymentMethodTab({super.key});

  @override
  CustomersPaymentMethodTabState createState() =>
      CustomersPaymentMethodTabState();
}

class CustomersPaymentMethodTabState
    extends ConsumerState<CustomersPaymentMethodTab> {
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
                title: "Payment Methods",
                subTitle: "View all customer orders with payment methods",
              ),
              YBox(16),
              CustomTextField(
                controller: searchC,
                isRequired: false,
                showLabelHeader: false,
                hintText: "Search by order ID, name etc",
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
                  return CustomerPaymentListTile(
                    orderId: "#12746398",
                    amount: "N55,500",
                    itemCount: "2",
                    status: "Completed",
                    date: DateTime.now(),
                    method: "Transfer, Credit note",
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

class CustomerPaymentListTile extends StatelessWidget {
  const CustomerPaymentListTile({
    super.key,
    required this.amount,
    required this.method,
    required this.orderId,
    required this.itemCount,
    required this.status,
    required this.date,
  });

  final String orderId;
  final String itemCount;
  final String status;
  final String amount;
  final String method;
  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        CustomColWidget(
          firstColText: orderId,
          subTitle: "Total items: ",
          subTitle2: itemCount,
          status: status,
          date: date,
        ),
        YBox(8),
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
                    text: amount,
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
                    text: "Method: ",
                    style: textTheme.text12?.medium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                  TextSpan(
                    text: method,
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
    );
  }
}
