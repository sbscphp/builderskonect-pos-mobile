import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class BasicInfoTab extends ConsumerStatefulWidget {
  const BasicInfoTab({
    super.key,
    required this.customer,
  });

  final CustomerData customer;

  @override
  ConsumerState<BasicInfoTab> createState() => _BasicInfoTabState();
}

class _BasicInfoTabState extends ConsumerState<BasicInfoTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      printty("BasicInfoTab initState");
      final customerVm = ref.read(customerVmodel);
      customerVm.viewCustomerDetails(widget.customer.id ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final customerVm = ref.watch(customerVmodel);
    printty(
        "customerVm.customerDetails ${customerVm.customerDetails?.toJson().toString()}");
    return Expanded(
      child: Container(
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
              title: "Returns & Refund Overview",
              subTitle: "View and manage logged returns ",
            ),
            YBox(16),
            Builder(builder: (context) {
              if (customerVm.busy(viewState)) {
                return SizerLoader(height: 500);
              }
              return Container(
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
                      title: "customer ID -",
                      title2: customerVm.customerDetails?.channel ?? "",
                      subTitle:
                          "#${customerVm.customerDetails?.customerId ?? ""}",
                    ),
                    YBox(16),
                    ProfileColText(
                      title: "Full Name",
                      subTitle: customerVm.customerDetails?.name ?? "",
                    ),
                    YBox(16),
                    ProfileColText(
                      title: "Email",
                      subTitle: customerVm.customerDetails?.email ?? "",
                    ),
                    YBox(16),
                    ProfileColText(
                      title: "Phone number",
                      subTitle: customerVm.customerDetails?.phone ?? "",
                    ),
                    YBox(16),
                    ProfileColText(
                      title: "Address",
                      subTitle: customerVm.customerDetails?.address ?? "N/A",
                    ),
                    YBox(16),
                    ProfileColText(
                        title: "Shipping Information",
                        subTitle: customerVm
                                .customerDetails?.shippingInformation
                                ?.toString() ??
                            "N/A"),
                    YBox(16),
                    ProfileColText(
                      title: "Billing Information",
                      subTitle: customerVm.customerDetails?.billingInformation
                              ?.toString() ??
                          "N/A",
                    ),
                    YBox(16),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
