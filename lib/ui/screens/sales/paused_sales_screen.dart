import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class PausedSalesScreen extends ConsumerStatefulWidget {
  const PausedSalesScreen({super.key});

  @override
  ConsumerState<PausedSalesScreen> createState() => _PausedSalesScreenState();
}

class _PausedSalesScreenState extends ConsumerState<PausedSalesScreen> {
  final searchC = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(salesVmodel).getDraftOverview();
    });
  }

  @override
  void dispose() {
    searchC.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _searchSales(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(salesVmodel).getDraftOverview(q: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final salesVm = ref.watch(salesVmodel);
    return Scaffold(
        appBar: CustomAppbar(
          title: "Paused Sales",
        ),
        body: Builder(builder: (context) {
          if (salesVm.busy(draftSalesState)) {
            return SizerLoader(
              height: double.infinity,
            );
          }
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
                        _searchSales(value.trim());
                      },
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (searchC.text.isNotEmpty)
                            InkWell(
                              onTap: () {
                                searchC.clear();
                                _searchSales("");
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
                            onTap: () {
                              _searchSales(searchC.text.trim());
                            },
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
                    Builder(builder: (context) {
                      if (salesVm.busy(searchState)) {
                        return SizerLoader(
                          height: Sizer.height(500),
                        );
                      }
                      if (salesVm.pausedSales.isEmpty) {
                        return SizedBox(
                          height: Sizer.height(500),
                          child: EmptyListState(text: "No data"),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: Sizer.height(14),
                        ),
                        itemCount: salesVm.pausedSales.length,
                        separatorBuilder: (_, __) => HDivider(),
                        itemBuilder: (ctx, i) {
                          final item = salesVm.pausedSales[i];
                          return PausedSalesListTile(
                            firstColText: "#${item.orderNumber ?? "N/A"}",
                            subTitle: item.customer?.name ?? "",
                            amount: item.amount ?? "",
                            totalItems: (item.itemsCount ?? 0).toString(),
                            status: item.orderDetails?.status ?? "",
                            date: item.orderDate ?? DateTime.now(),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ],
          );
        }));
  }
}
