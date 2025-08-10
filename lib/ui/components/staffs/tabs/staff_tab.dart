import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class StaffTab extends ConsumerStatefulWidget {
  const StaffTab({super.key});

  @override
  ConsumerState<StaffTab> createState() => _StaffTabState();
}

class _StaffTabState extends ConsumerState<StaffTab> {
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
    return Container(
      padding: EdgeInsets.all(Sizer.radius(16)),
      decoration: BoxDecoration(
        color: colorScheme.white,
        borderRadius: BorderRadius.circular(Sizer.radius(4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterHeader(
            title: "Staff Overview",
            subTitle: "View and manage all business staff here",
            svgIcon: AppSvgs.circleAdd,
            trailingWidget: NewButtonWidget(
              onTap: () {
                Navigator.pushNamed(context, RoutePath.newStaffScreen);
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
                  title: "TOTAL STAFF",
                  value: "100",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProductColText(
                      textColor: colorScheme.black85,
                      title: "Total Active",
                      value: "80",
                      valueTextSize: 12,
                      valueColor: AppColors.green1A,
                    ),
                    ProductColText(
                      textColor: colorScheme.black85,
                      title: "Total Deactivated",
                      value: "20",
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
            title: "Staff List",
            subTitle: "See all staff created",
            onFilter: () async {},
          ),
          YBox(16),
          CustomTextField(
            controller: searchC,
            isRequired: false,
            showLabelHeader: false,
            hintText: "Search by user. id, name,  etc.",
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
            if (1 + 2 == 2) {
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
                  itemCount: 10,
                  separatorBuilder: (_, __) => HDivider(),
                  itemBuilder: (ctx, i) {
                    return StaffListTile(
                      title: "1234567890",
                      staffId: "John Doe",
                      status: "Active",
                      role: "Admin",
                      onTap: () {},
                    );
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
