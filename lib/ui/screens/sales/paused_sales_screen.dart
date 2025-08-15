import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PausedSalesScreen extends ConsumerStatefulWidget {
  const PausedSalesScreen({super.key});

  @override
  ConsumerState<PausedSalesScreen> createState() => _PausedSalesScreenState();
}

class _PausedSalesScreenState extends ConsumerState<PausedSalesScreen> {
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
    return Scaffold(
        appBar: CustomAppbar(
          title: "Paused Sales",
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
                    title: "Paused Sales",
                    subTitle: "See all paused sales made in your business",
                    onFilter: () {},
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: searchC,
                    isRequired: false,
                    showLabelHeader: false,
                    hintText: "Search by order id, name etc",
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
                      return PausedSalesListTile(
                        firstColText: "#162826",
                        subTitle: "John Doe Oluwabunmi",
                        amount: "N1000",
                        totalItems: "2",
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
