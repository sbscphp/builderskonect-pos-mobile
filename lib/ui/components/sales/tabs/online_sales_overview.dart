import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class OnlineSalesOverview extends ConsumerStatefulWidget {
  const OnlineSalesOverview({super.key});

  @override
  ConsumerState<OnlineSalesOverview> createState() =>
      _OnlineSalesOverviewState();
}

class _OnlineSalesOverviewState extends ConsumerState<OnlineSalesOverview> {
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
                title: "Sales Overview",
                subTitle: "View and manage offline and online sales",
                trailingWidget: NewButtonWidget(
                  onTap: () {
                    // Navigator.pushNamed(context, RoutePath.newSalesScreen);
                  },
                ),
                onFilter: () {},
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
                      title: "TOTAL ONLINE SALES VALUE",
                      value: "N 2",
                    ),
                    ProductColText(
                      textColor: colorScheme.black85,
                      title: "Total Online Sales",
                      value: "2",
                      valueTextSize: 12,
                    ),
                  ],
                ),
              ),
              YBox(24),
              FilterHeader(
                title: "Sales List",
                subTitle: "See all sales made in your business",
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
                        decoration: BoxDecoration(),
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
    );
  }
}
