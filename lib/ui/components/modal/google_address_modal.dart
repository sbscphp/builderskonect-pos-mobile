import 'dart:async';

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class GoogleAddressModal extends ConsumerStatefulWidget {
  const GoogleAddressModal({super.key});

  @override
  ConsumerState<GoogleAddressModal> createState() => _CustomListModalState();
}

class _CustomListModalState extends ConsumerState<GoogleAddressModal> {
  final searchC = TextEditingController();
  final searchF = FocusNode();

  Timer? _debounce;

  void _searchState(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      await ref.read(geographyVmodel).getAddressSuggestions(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchC.dispose();
    searchF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    final geographyVm = ref.watch(geographyVmodel);
    return Container(
      height: Sizer.screenHeight * 0.70,
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
              Text("Select Address", style: textTheme.text16?.medium),
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
          Divider(color: AppColors.neutral4, height: 1),
          YBox(24),
          CustomTextField(
            controller: searchC,
            focusNode: searchF,
            hintText: "Start typing to search",
            borderRadius: 8,
            showLabelHeader: false,
            onChanged: (p0) {
              _searchState(p0.trim());
            },
            prefixIcon: Icon(
              Iconsax.search_normal_1,
              size: Sizer.radius(16),
              color: AppColors.black.withValues(alpha: 0.85),
            ),
          ),
          YBox(7),
          Expanded(
            child: LoadableContentBuilder(
              isBusy: geographyVm.isBusy,
              items: geographyVm.addresses,
              loadingBuilder: (context) {
                return ListView.separated(
                  padding: EdgeInsets.only(
                    top: Sizer.height(10),
                    bottom: Sizer.height(80),
                  ),
                  shrinkWrap: true,
                  itemCount: 20,
                  separatorBuilder: (_, __) => YBox(24),
                  itemBuilder: (_, i) {
                    return Skeletonizer(
                      enabled: true,
                      child: Text(
                        "AB Microfinance Bank",
                        style: textTheme.text14,
                      ),
                    );
                  },
                );
              },
              emptyBuilder: (context) {
                return (searchC.text.isNotEmpty && searchF.hasFocus)
                    ? Text(
                        "No Address found",
                        style: textTheme.text14,
                      )
                    : SizedBox.shrink();
              },
              contentBuilder: (context) {
                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.read(geographyVmodel).getStates();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      top: Sizer.height(10),
                      bottom: Sizer.height(80),
                    ),
                    shrinkWrap: true,
                    itemCount: geographyVm.addresses.length,
                    separatorBuilder: (_, __) => YBox(24),
                    itemBuilder: (_, i) {
                      final item = geographyVm.addresses[i];
                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                        child: Text(
                          item.address ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.text14,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
