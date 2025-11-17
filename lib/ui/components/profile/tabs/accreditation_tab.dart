import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class AccreditationTab extends ConsumerStatefulWidget {
  const AccreditationTab({super.key});

  @override
  ConsumerState<AccreditationTab> createState() => _AccreditationTabState();
}

class _AccreditationTabState extends ConsumerState<AccreditationTab> {
  final searchC = TextEditingController();
  final searchFocus = FocusNode();
  final _scrollController = ScrollController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(accreditationVm).getAccreditaions();
      _scrollListener();
    });
  }

  _scrollListener() {
    final vm = ref.watch(accreditationVm);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (!vm.busy(paginateState) && vm.pageNumber <= (vm.lastPage ?? 1)) {
          vm.getAccreditaions(busyObjectName: paginateState);
        }
      }
    });
  }

  void _performSearch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final vm = ref.read(accreditationVm);
      vm.getAccreditaions(
        q: query.trim(),
        busyObjectName: searchState,
      );
    });
  }

  void _clearSearch() {
    searchC.clear();
    final vm = ref.read(accreditationVm);
    vm.getAccreditaions();
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
    final vm = ref.watch(accreditationVm);

    return LoadableContentBuilder(
        isBusy: vm.busy(getState),
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
              vm.getAccreditaions();
            },
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
              controller: _scrollController,
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
                        trailingWidget: NewButtonWidget(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutePath.accreditationScreen);
                          },
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
                        onChanged: _performSearch,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (searchC.text.isNotEmpty)
                              InkWell(
                                onTap: () {
                                  _clearSearch();
                                },
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
                      LoadableContentBuilder(
                          isBusy: vm.busy(getState),
                          items: vm.brandCertificates,
                          loadingBuilder: (context) {
                            return SizerLoader(height: 300);
                          },
                          emptyBuilder: (context) {
                            return SizedBox(
                              height: Sizer.height(240),
                              child: EmptyListState(
                                text: "No data",
                              ),
                            );
                          },
                          contentBuilder: (context) {
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.only(
                                top: Sizer.height(14),
                                bottom: Sizer.height(50),
                              ),
                              itemCount: vm.brandCertificates.length,
                              separatorBuilder: (_, __) => HDivider(),
                              itemBuilder: (ctx, i) {
                                final item = vm.brandCertificates[i];
                                return AccreditationTile(
                                  item: item,
                                );
                              },
                            );
                          }),
                      if (vm.busy(paginateState))
                        SpinKitLoader(
                          size: 16,
                          color: AppColors.neutral5,
                        ),
                      if (vm.error(paginateState))
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: ErrorState(
                            onPressed: () {
                              vm.getAccreditaions(
                                  busyObjectName: paginateState);
                            },
                            isPaginationType: true,
                          ),
                        )
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
  final Certificate item;

  const AccreditationTile({super.key, this.onTap, required this.item});

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
                  item.brand?.name ?? "---",
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
                        text: item.certificateNo ?? "---",
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
              OrderStatus(status: item.status ?? ''),
              YBox(8),
              if (item.certificateExpiryDate != null)
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
                        text: AppUtils.dateFirstYear(
                            DateTime.parse(item.certificateExpiryDate ?? "")),
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
