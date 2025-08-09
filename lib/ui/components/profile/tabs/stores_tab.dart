import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class StoresTab extends ConsumerStatefulWidget {
  const StoresTab({super.key});

  @override
  ConsumerState<StoresTab> createState() => _StoresTabState();
}

class _StoresTabState extends ConsumerState<StoresTab> {
  final searchC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(storeVmodel).getStoreOverview();
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final storeVm = ref.watch(storeVmodel);
    return LoadableContentBuilder(
      isBusy: storeVm.busy(getState),
      isError: storeVm.error(getState),
      loadingBuilder: (p0) {
        return SizerLoader(
          height: double.infinity,
        );
      },
      emptyBuilder: (context) {
        return Center(
          child: Text(
            "No Data",
            style: textTheme.text14?.medium.copyWith(
              color: AppColors.gray500,
            ),
          ),
        );
      },
      contentBuilder: (context) {
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
                    title: "All Stores",
                    subTitle: "See and manage all created stores",
                    svgIcon: AppSvgs.circleAdd,
                    trailingWidget: NewButtonWidget(
                      onTap: () {
                        Navigator.pushNamed(context, RoutePath.newStoreScreen);
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
                          title: "TOTAL STORES",
                          value: storeVm.stats?.total.toString() ?? '0',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Active Stores",
                              value: storeVm.stats?.active.toString() ?? '0',
                              valueTextSize: 12,
                              valueColor: AppColors.green1A,
                            ),
                            ProductColText(
                              textColor: colorScheme.black85,
                              title: "Deactivated Stores",
                              value: storeVm.stats?.inactive.toString() ?? '0',
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
                    title: "Store List",
                    subTitle:
                        "This shows the stores created under this vendor ",
                    onFilter: () async {},
                  ),
                  YBox(16),
                  Builder(builder: (context) {
                    if (storeVm.storeList.isEmpty) {
                      return SizedBox(
                        height: Sizer.height(300),
                        child: EmptyListState(
                          text: "No Data",
                        ),
                      );
                    }
                    return Column(
                      children: [
                        CustomTextField(
                          controller: searchC,
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
                          itemCount: storeVm.storeList.length,
                          separatorBuilder: (_, __) => HDivider(),
                          itemBuilder: (ctx, i) {
                            final store = storeVm.storeList[i];
                            return CustomColWidget(
                              firstColText: store.storeId ?? '',
                              subTitle: store.name ?? '',
                              status: store.status ?? '',
                              date: store.dateCreated?.toLocal(),
                              onTap: () {
                                ModalWrapper.bottomSheet(
                                  context: context,
                                  widget: StoreOptionModal(options: [
                                    ModalOption(
                                      title: "View store details",
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, RoutePath.viewStoreScreen,
                                            arguments: store);
                                      },
                                    ),
                                    ModalOption(
                                      title: "Store sales overview",
                                      onTap: () {
                                        Navigator.pushNamed(context,
                                            RoutePath.storeSalesOverviewScreen,
                                            arguments: store);
                                      },
                                    ),
                                    ModalOption(
                                      title: "Store products/inventory list",
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            RoutePath
                                                .storeInventoryOverviewScreen,
                                            arguments: store);
                                      },
                                    ),
                                  ]),
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
      },
    );
  }
}
