import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class RequestDetailsTab extends ConsumerStatefulWidget {
  const RequestDetailsTab({super.key});

  @override
  ConsumerState<RequestDetailsTab> createState() => _RequestDetailsTabState();
}

class _RequestDetailsTabState extends ConsumerState<RequestDetailsTab> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productTransferVm);

    return Builder(builder: (context) {
      if (vm.busy(viewState)) {
        return Container(
          height: Sizer.screenHeight,
          width: Sizer.screenWidth,
          color: Colors.white,
        );
      }
      return ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.all(Sizer.radius(16)),
            decoration: BoxDecoration(
              color: colorScheme.white,
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child: Column(
              children: [
                FilterHeader(title: "Request Details"),
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
                        title: "Transfer ID",
                        subTitle: vm.transferProduct?.reference ?? "-----",
                        subtitleColor: AppColors.blueDD9,
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Total Products",
                        subTitle:
                            vm.transferProduct?.productCount?.toString() ?? "0",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Total Quantity",
                        subTitle:
                            vm.transferProduct?.quantity?.toString() ?? "0",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Initiated By",
                        subTitle:
                            vm.transferProduct?.source?.name?.toString() ??
                                "N/A",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Initiated On",
                        subTitle: AppUtils.formatDateTime(
                            vm.transferProduct?.dateInitiated?.toLocal() ??
                                DateTime.now()),
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Sent To",
                        subTitle:
                            vm.transferProduct?.destination?.name?.toString() ??
                                "N/A",
                      ),
                      YBox(16),
                      ProfileColText(
                        title: "Transfer Status",
                        subTitleWidget: OrderStatus(
                          status: vm.transferProduct?.status ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
                if (1 + 1 == 3)
                  Column(
                    children: [
                      YBox(16),
                      FilterHeader(title: "Response Details"),
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
                              title: "Response From",
                              subTitle: "Jessica Doe",
                            ),
                            YBox(16),
                            ProfileColText(
                              title: "Response Date",
                              subTitle: "24, July, 2025 | 09:00 AM",
                            ),
                            YBox(16),
                            ProfileColText(
                              title: "Appproved",
                              subTitle: "10",
                            ),
                            YBox(16),
                            ProfileColText(
                              title: "Rejected",
                              subTitle: "200",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
