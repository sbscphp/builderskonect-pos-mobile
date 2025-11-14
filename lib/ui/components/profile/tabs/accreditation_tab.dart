import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class AccreditationTab extends ConsumerStatefulWidget {
  const AccreditationTab({super.key});

  @override
  ConsumerState<AccreditationTab> createState() => _AccreditationTabState();
}

class _AccreditationTabState extends ConsumerState<AccreditationTab> {
  final searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(subscriptionVModel).getSubcriptionHistory();
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final subscriptionVm = ref.watch(subscriptionVModel);

    return LoadableContentBuilder(
        isBusy: subscriptionVm.isBusy,
        loadingBuilder: (ctx) {
          return SizerLoader(
            height: double.infinity,
          );
        },
        emptyBuilder: (ctx) {
          return Center(
            child: Text(
              "No Data",
              style: textTheme.text14?.medium.copyWith(
                color: AppColors.gray500,
              ),
            ),
          );
        },
        contentBuilder: (ctx) {
          return RefreshIndicator(
            onRefresh: () async {
              subscriptionVm.getSubcriptionHistory();
            },
            child: ListView(
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
                        title: "Accreditation List",
                        subTitle:
                            "This shows the manufacturers you are accredited with.",
                        // onFilter: () {},
                        trailingWidget: NewButtonWidget(
                          onTap: () {},
                          text: "Add",
                        ),
                      ),
                      // HLine(),
                      YBox(16),
                      CustomTextField(
                        controller: searchC,
                        isRequired: false,
                        showLabelHeader: false,
                        hintText: "Search",
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
                        itemCount: subscriptionVm.subscriptionHistory.length,
                        separatorBuilder: (_, __) => HDivider(),
                        itemBuilder: (ctx, i) {
                          final item = subscriptionVm.subscriptionHistory[i];
                          return AccreditationTile();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class AccreditationTile extends StatelessWidget {
  final VoidCallback? onTap;

  const AccreditationTile({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sterling Bosch",
                  style:
                      textTheme.text14?.medium.copyWith(color: AppColors.black),
                ),
                YBox(4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Acc No: ",
                        style: textTheme.text12?.medium.copyWith(
                          color: colorScheme.black85,
                          fontFamily: "Roboto",
                        ),
                      ),
                      TextSpan(
                        text: "12345708",
                        style: textTheme.text12?.copyWith(
                          color: colorScheme.primaryColor,
                          fontFamily: "Roboto",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              OrderStatus(status: "active"),
              YBox(8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Expiring: ",
                      style: textTheme.text12?.medium.copyWith(
                        color: colorScheme.black85,
                        fontFamily: "Roboto",
                      ),
                    ),
                    TextSpan(
                      text: AppUtils.dateFirstYear(DateTime.now()),
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                        fontFamily: "Roboto",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
