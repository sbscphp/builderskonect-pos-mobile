import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class AddAttributeModal extends ConsumerStatefulWidget {
  const AddAttributeModal({super.key, this.isCategory = true});

  final bool isCategory;

  @override
  ConsumerState<AddAttributeModal> createState() => _AddAttributeModalState();
}

class _AddAttributeModalState extends ConsumerState<AddAttributeModal> {
  final searchC = TextEditingController();
  final searchF = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    searchC.dispose();
    searchF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productInventoryVmodel);
    // attributeList = vm.productAttributes.map((e) => e.attribute ?? 'N/A').toList();
    return Container(
      height: Sizer.screenHeight * 0.7,
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YBox(20),
          Row(
            children: [
              Text(
                "Add Attributes",
                style: textTheme.text16?.medium,
              ),
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
          YBox(30),
          Text(
            "Select the attributes you want to add.",
            style: textTheme.text14,
          ),
          CustomTextField(
            controller: searchC,
            isRequired: false,
            showLabelHeader: false,
            hintText: "Search attributes",
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
          YBox(16),
          HDivider(verticalPadding: 0),
          YBox(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  if (vm.selectedAttributeList.isNotEmpty) {
                    vm.selectedAttributeList.clear();
                  }
                  setState(() {});
                },
                child: Text(
                  "Deselect all",
                  style: textTheme.text16?.medium.copyWith(
                    color: colorScheme.black25,
                  ),
                ),
              ),
              XBox(24),
              InkWell(
                onTap: () {
                  if (vm.selectedAttributeList.isNotEmpty) {
                    vm.selectedAttributeList.clear();
                  } else {
                    vm.selectedAttributeList.addAll(vm.productAttributes);
                  }
                  vm.updateUI();
                },
                child: Text(
                  "Select all",
                  style: textTheme.text16?.medium.copyWith(
                    color: colorScheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          YBox(16),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.only(
                top: Sizer.height(10),
                bottom: Sizer.height(80),
              ),
              shrinkWrap: true,
              itemCount: vm.productAttributes.length,
              separatorBuilder: (_, __) => YBox(24),
              itemBuilder: (_, i) {
                final item = vm.productAttributes[i];
                return InkWell(
                  onTap: () {
                    if (vm.selectedAttributeList.contains(item)) {
                      vm.selectedAttributeList.remove(item);
                    } else {
                      vm.selectedAttributeList.add(item);
                    }
                    vm.updateUI();
                  },
                  child: Row(
                    children: [
                      CustomCheckbox(
                        isSelected: vm.selectedAttributeList.contains(item),
                      ),
                      XBox(8),
                      Text(
                        item.attribute ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.text14,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          YBox(32),
          CustomBtn.solid(
            online: vm.selectedAttributeList.isNotEmpty,
            text: "Save",
            onTap: () {
              if (vm.selectedAttributeList.isNotEmpty) {
                Navigator.pop(context, vm.selectedAttributeList);
              }
            },
          ),
          YBox(30),
        ],
      ),
    );
  }
}
