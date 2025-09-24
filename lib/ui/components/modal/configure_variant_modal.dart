import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ConfigureVariantArg {
  ConfigureVariantArg({
    required this.selectedVariantList,
    required this.numOfVariants,
  });

  final int numOfVariants;
  final List<ProductAttributeModel> selectedVariantList;
}

class ConfigureVariantModal extends ConsumerStatefulWidget {
  const ConfigureVariantModal({super.key, this.arg});

  final ConfigureVariantArg? arg;

  @override
  ConsumerState<ConfigureVariantModal> createState() =>
      _ConfigureVariantModalState();
}

class _ConfigureVariantModalState extends ConsumerState<ConfigureVariantModal> {
  List<ProductAttributeModel> selectedVariantList = [];
  int numOfVariants = 2;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arg = widget.arg;
      if (arg != null) {
        numOfVariants = arg.numOfVariants;
        selectedVariantList = arg.selectedVariantList;

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productInventoryVmodel);

    return Container(
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
                "Configure Variants",
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
          YBox(16),
          Text(
            "Select the which attributes will vary across your product variants",
            style: textTheme.text16?.copyWith(
              color: colorScheme.black45,
            ),
          ),
          YBox(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  if (selectedVariantList.isNotEmpty) {
                    selectedVariantList.clear();
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
                  selectedVariantList.addAll(vm.productAttributes);
                  setState(() {});
                },
                child: Text(
                  "Select all as varying",
                  style: textTheme.text16?.medium.copyWith(
                    color: colorScheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          YBox(30),
          Wrap(
            spacing: Sizer.width(16),
            runSpacing: Sizer.height(24),
            children: vm.productAttributes.map((item) {
              return InkWell(
                onTap: () {
                  if (selectedVariantList.contains(item)) {
                    selectedVariantList.remove(item);
                  } else {
                    selectedVariantList.add(item);
                  }
                  vm.updateUI();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizer.width(12),
                    vertical: Sizer.height(8),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.text6,
                    ),
                    borderRadius: BorderRadius.circular(Sizer.radius(4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomCheckbox(
                        isSelected: selectedVariantList.contains(item),
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
                ),
              );
            }).toList(),
          ),
          YBox(40),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Number of Variants",
                  style: textTheme.text16?.medium,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      if (numOfVariants > 2) {
                        numOfVariants--;
                        setState(() {});
                      }
                    },
                    child: SvgPicture.asset(
                      AppSvgs.borderMinus,
                      height: Sizer.height(32),
                    ),
                  ),
                  XBox(10),
                  Container(
                    height: Sizer.height(32),
                    width: Sizer.width(40),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.neutral5,
                      ),
                      borderRadius: BorderRadius.circular(Sizer.radius(4)),
                    ),
                    child: Center(
                      child: Text(
                        numOfVariants.toString(),
                        style: textTheme.text14?.medium.copyWith(
                          color: colorScheme.black25,
                        ),
                      ),
                    ),
                  ),
                  XBox(10),
                  InkWell(
                    onTap: () {
                      numOfVariants++;
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      AppSvgs.borderPlus,
                      height: Sizer.height(32),
                    ),
                  ),
                ],
              )
            ],
          ),
          YBox(32),
          CustomBtn.solid(
            online: selectedVariantList.isNotEmpty,
            text: "Save",
            onTap: () {
              if (selectedVariantList.isNotEmpty) {
                Navigator.pop(
                  context,
                  ConfigureVariantArg(
                    selectedVariantList: selectedVariantList,
                    numOfVariants: numOfVariants,
                  ),
                );
              }
            },
          ),
          YBox(30),
        ],
      ),
    );
  }
}
