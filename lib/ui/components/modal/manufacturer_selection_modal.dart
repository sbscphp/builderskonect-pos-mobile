import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ManufacturerSelectionModal extends ConsumerStatefulWidget {
  const ManufacturerSelectionModal({super.key});

  @override
  ConsumerState<ManufacturerSelectionModal> createState() =>
      _ManufacturerSelectionModalState();
}

class _ManufacturerSelectionModalState
    extends ConsumerState<ManufacturerSelectionModal> {
  // Timer? _debounceTimer;
  // final searchC = TextEditingController();
  // final searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchManufacturers();
    });
  }

  _fetchManufacturers() async {
    final vm = ref.read(accreditationVm);
    if (vm.manufacturers.isEmpty) {
      await vm.getBrands();
    }
  }

  List<Brand> selectedBrands = [];

  // void _performSearch(String query) {
  //   _debounceTimer?.cancel();
  //   _debounceTimer = Timer(const Duration(milliseconds: 500), () {
  //     final vm = ref.read(accreditationVm);
  //     vm.getAccreditaions(
  //       q: query.trim(),
  //       busyObjectName: searchState,
  //     );
  //   });
  // }

  // void _clearSearch() {
  //   searchC.clear();
  //   final vm = ref.read(accreditationVm);
  //   vm.getAccreditaions();
  // }

  // @override
  // void dispose() {
  //   searchC.dispose();
  //   searchFocus.dispose();
  //   _debounceTimer?.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final vm = ref.watch(accreditationVm);

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
              Text("Select Manufacturers", style: textTheme.text16?.medium),
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
          YBox(16),
          // CustomTextField(
          //   controller: searchC,
          //   isRequired: false,
          //   showLabelHeader: false,
          //   hintText: "Search",
          //   onChanged: _performSearch,
          //   suffixIcon: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       if (searchC.text.isNotEmpty)
          //         InkWell(
          //           onTap: () {
          //             _clearSearch();
          //           },
          //           child: Padding(
          //             padding: EdgeInsets.all(Sizer.width(10)),
          //             child: Icon(
          //               Icons.close,
          //               size: Sizer.width(20),
          //               color: AppColors.gray500,
          //             ),
          //           ),
          //         ),
          //       InkWell(
          //         onTap: () {},
          //         child: Container(
          //           padding: EdgeInsets.all(Sizer.width(10)),
          //           decoration: BoxDecoration(
          //               border: Border(
          //             left: BorderSide(
          //               color: AppColors.neutral5,
          //             ),
          //           )),
          //           child: SvgPicture.asset(AppSvgs.search),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // YBox(10),
          Expanded(
            child: LoadableContentBuilder(
              isBusy: vm.busy(getState),
              items: vm.manufacturers,
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
                        "Some Store Text",
                        style: textTheme.text14,
                      ),
                    );
                  },
                );
              },
              emptyBuilder: (context) {
                return Center(
                  child: Text(
                    "No Store found",
                    style: textTheme.text14?.medium.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                );
              },
              contentBuilder: (context) {
                return RefreshIndicator(
                  onRefresh: () async {
                    _fetchManufacturers();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      top: Sizer.height(10),
                      bottom: Sizer.height(80),
                    ),
                    shrinkWrap: true,
                    itemCount: vm.manufacturers.length,
                    separatorBuilder: (_, __) => YBox(24),
                    itemBuilder: (_, i) {
                      final item = vm.manufacturers[i];
                      return InkWell(
                        onTap: () {
                          if (selectedBrands.contains(item)) {
                            selectedBrands.remove(item);
                            setState(() {});
                          } else {
                            selectedBrands.add(item);
                            setState(() {});
                          }
                          // Navigator.pop(context, item);
                        },
                        child: Row(
                          children: [
                            CustomCheckbox(
                              isSelected: selectedBrands.contains(item),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Text(
                              item.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.text14,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          YBox(16),
          CustomBtn(
            onTap: () {
              if (selectedBrands.isEmpty) {
                FlushBarToast.fLSnackBar(
                    message: "Select at least one Manufacturer");
              } else {
                Navigator.pop(context, selectedBrands);
              }
            },
            text: "Next",
          ),
          YBox(32),
        ],
      ),
    );
  }
}
