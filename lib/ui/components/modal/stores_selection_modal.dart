import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class StoresSelectionModal extends ConsumerStatefulWidget {
  const StoresSelectionModal({super.key});

  @override
  ConsumerState<StoresSelectionModal> createState() =>
      _StoresSelectionModalState();
}

class _StoresSelectionModalState extends ConsumerState<StoresSelectionModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFormStores();
    });
  }

  _fetchFormStores() async {
    final vm = ref.read(storeVmodel);
    if (vm.storeList.isEmpty) {
      await vm.getStoreOverview();
    }
  }

  List<StoreModel> selectedStores = [];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final vm = ref.watch(storeVmodel);

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
              Text("Select Store", style: textTheme.text16?.medium),
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
          Expanded(
            child: LoadableContentBuilder(
              isBusy: vm.busy(getState),
              items: vm.storeList,
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
                    _fetchFormStores();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      top: Sizer.height(10),
                      bottom: Sizer.height(80),
                    ),
                    shrinkWrap: true,
                    itemCount: vm.storeList.length,
                    separatorBuilder: (_, __) => YBox(24),
                    itemBuilder: (_, i) {
                      final item = vm.storeList[i];
                      return InkWell(
                        onTap: () {
                          if (selectedStores.contains(item)) {
                            selectedStores.remove(item);
                            setState(() {});
                          } else {
                            selectedStores.add(item);
                            setState(() {});
                          }
                          // Navigator.pop(context, item);
                        },
                        child: Row(
                          children: [
                            CustomCheckbox(
                              isSelected: selectedStores.contains(item),
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
              if (selectedStores.isEmpty) {
                FlushBarToast.fLSnackBar(message: "Select at least one Store");
              } else {
                Navigator.pop(context, selectedStores);
              }
            },
            text: "Add Store(s)",
          ),
          YBox(32),
        ],
      ),
    );
  }
}
