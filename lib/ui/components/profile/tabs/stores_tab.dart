import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class StoresTab extends ConsumerStatefulWidget {
  const StoresTab({super.key});

  @override
  ConsumerState<StoresTab> createState() => _StoresTabState();
}

class _StoresTabState extends ConsumerState<StoresTab> {
  final searchC = TextEditingController();
  final searchF = FocusNode();

  @override
  void dispose() {
    searchC.dispose();
    searchF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
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
                title: "All Stores",
                subTitle: "This shows the stores created under this vendor ",
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
                      title: "TOTAL STORES",
                      value: "2",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProductColText(
                          textColor: colorScheme.black85,
                          title: "Active Stores",
                          value: "2",
                          valueColor: AppColors.green1A,
                        ),
                        ProductColText(
                          textColor: colorScheme.black85,
                          title: "Deactivated Stores",
                          value: "2",
                          valueColor: AppColors.red2D,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              YBox(40),
              FilterHeader(
                title: "Store List",
                subTitle: "This shows the stores created under this vendor ",
                onFilter: () {},
              ),
              YBox(16),
              CustomTextField(
                controller: searchC,
                focusNode: searchF,
                isRequired: false,
                showLabelHeader: false,
                hintText: "Search with order no.",
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
                  bottom: Sizer.height(50),
                ),
                itemCount: 10,
                separatorBuilder: (_, __) => HDivider(),
                itemBuilder: (ctx, i) {
                  return CustomColWidget(
                    firstColText: "#162826",
                    secondColText: "Mainland Store",
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
