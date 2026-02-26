import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class BusinessCategoryTypeModal extends ConsumerStatefulWidget {
  const BusinessCategoryTypeModal({super.key, this.isCategory = true});

  final bool isCategory;

  @override
  ConsumerState<BusinessCategoryTypeModal> createState() =>
      _BusinessCategoryTypeModalState();
}

class _BusinessCategoryTypeModalState
    extends ConsumerState<BusinessCategoryTypeModal> {
  final searchC = TextEditingController();
  final searchF = FocusNode();

  List<BusinessCategoryTypeModel> selectedCategories = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSetup();
    });
  }

  void _initSetup() async {
    await ref.read(onboardVmodel).getBusinessCategoryType(widget.isCategory);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    final onboardVm = ref.watch(onboardVmodel);
    return SafeArea(
      child: Container(
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
                Text(
                    "Select Business ${widget.isCategory ? 'Category' : 'Type'}",
                    style: textTheme.text16?.medium),
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
                isBusy: onboardVm.busy(categoryTypeState),
                items: widget.isCategory
                    ? onboardVm.businessCategories
                    : onboardVm.businessTypes,
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
                  return Center(
                    child: Text(
                      "No ${widget.isCategory ? 'Category' : 'Type'} found",
                      style: textTheme.text14?.medium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                  );
                },
                contentBuilder: (context) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      _initSetup();
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.only(
                        top: Sizer.height(10),
                        bottom: Sizer.height(80),
                      ),
                      shrinkWrap: true,
                      itemCount: widget.isCategory
                          ? onboardVm.businessCategories.length
                          : onboardVm.businessTypes.length,
                      separatorBuilder: (_, __) => YBox(24),
                      itemBuilder: (_, i) {
                        final item = widget.isCategory
                            ? onboardVm.businessCategories[i]
                            : onboardVm.businessTypes[i];
                        return InkWell(
                          onTap: () {
                            if (widget.isCategory) {
                              selectedCategories
                                      .where((item) =>
                                          item.id ==
                                          (widget.isCategory
                                              ? onboardVm
                                                  .businessCategories[i].id
                                              : onboardVm.businessTypes[i].id))
                                      .isNotEmpty
                                  ? selectedCategories.remove(widget.isCategory
                                      ? onboardVm.businessCategories[i]
                                      : onboardVm.businessTypes[i])
                                  : selectedCategories.add(widget.isCategory
                                      ? onboardVm.businessCategories[i]
                                      : onboardVm.businessTypes[i]);
                              setState(() {});
                            } else {
                              Navigator.pop(context, item);
                            }
                          },
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.name ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textTheme.text14,
                                ),
                              ),
                              if (selectedCategories
                                  .where((item) =>
                                      item.id ==
                                      (widget.isCategory
                                          ? onboardVm.businessCategories[i].id
                                          : onboardVm.businessTypes[i].id))
                                  .isNotEmpty)
                                Icon(
                                  Icons.check,
                                  color: AppColors.primaryBlue,
                                  size: Sizer.radius(16),
                                )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            YBox(20),
            if (widget.isCategory)
              Row(
                children: [
                  Expanded(
                    child: CustomBtn.solid(
                      text: "Close",
                      height: 42,
                      isOutline: true,
                      outlineColor: AppColors.neutral5,
                      textStyle: textTheme.text16,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  XBox(16),
                  Expanded(
                    child: CustomBtn.solid(
                      text: "Done",
                      height: 42,
                      onTap: () {
                        Navigator.pop(
                            context, {'categories': selectedCategories});
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
