import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SelectCustomerModal extends ConsumerStatefulWidget {
  const SelectCustomerModal({super.key});

  @override
  ConsumerState<SelectCustomerModal> createState() =>
      _SelectCustomerModalState();
}

class _SelectCustomerModalState extends ConsumerState<SelectCustomerModal> {
  final searchC = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final customVm = ref.read(customerVmodel);
      if (customVm.customerData.isEmpty) {
        ref.read(customerVmodel).getCustomerOverview();
      }
    });
  }

  void _searchProducts(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(customerVmodel).getCustomerOverview(q: query, paginate: false);
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
    final customerVm = ref.watch(customerVmodel);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: Sizer.screenHeight * 0.60,
        padding: EdgeInsets.symmetric(
          horizontal: Sizer.width(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YBox(20),
            Row(
              children: [
                Text("Search Customer", style: textTheme.text16?.medium),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    color: AppColors.black,
                    size: Sizer.radius(24),
                  ),
                )
              ],
            ),
            YBox(16),
            CustomTextField(
              controller: searchC,
              isRequired: false,
              showLabelHeader: false,
              hintText: "Search for a customer",
              onChanged: (value) {
                _searchProducts(value.trim());
              },
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (searchC.text.isNotEmpty)
                    InkWell(
                      onTap: () {
                        searchC.clear();
                        _searchProducts("");
                      },
                      child: Padding(
                        padding: EdgeInsets.all(Sizer.width(10)),
                        child: Icon(
                          Icons.close,
                          size: Sizer.width(20),
                          color: AppColors.gray500,
                        ),
                      ),
                    )
                  else
                    InkWell(
                      onTap: () {
                        _searchProducts(searchC.text.trim());
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
            YBox(8),
            Expanded(
              child: LoadableContentBuilder(
                isBusy: customerVm.busy(getState),
                // isError: customerVm.error(getState),
                items: customerVm.customerData,
                loadingBuilder: (p0) {
                  return SizerLoader(
                    height: double.infinity,
                  );
                },
                emptyBuilder: (context) {
                  return EmptyListState(text: "No data");
                },
                contentBuilder: (context) {
                  return ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                      top: Sizer.height(10),
                      bottom: Sizer.height(50),
                    ),
                    itemCount: customerVm.customerData.length,
                    separatorBuilder: (_, __) => HDivider(),
                    itemBuilder: (ctx, i) {
                      final c = customerVm.customerData[i];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, c);
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.name ?? "",
                              style: textTheme.text14,
                            ),
                            YBox(4),
                            Text(
                              c.email ?? "",
                              style: textTheme.text12?.copyWith(
                                color: colorScheme.black45,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
