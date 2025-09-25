import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CommonAttributesSection extends ConsumerWidget {
  const CommonAttributesSection({
    super.key,
    required this.attributeControllers,
    required this.productHasVariant,
    required this.configureVariantArg,
    required this.onConfigureVariantChanged,
    required this.onEnsureControllers,
  });

  final List<TextEditingController> attributeControllers;
  final bool productHasVariant;
  final ConfigureVariantArg? configureVariantArg;
  final Function(ConfigureVariantArg?) onConfigureVariantChanged;
  final Function(int) onEnsureControllers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productInventoryVmodel);

    if (vm.selectedAttributeList.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(Sizer.radius(16)),
      decoration: BoxDecoration(
        color: colorScheme.white,
        borderRadius: BorderRadius.circular(Sizer.radius(6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${productHasVariant == true ? 'Common' : 'Product'} Attributes",
            style: textTheme.text16?.medium,
          ),
          HDivider(),
          RichText(
            text: TextSpan(
              style: textTheme.text14,
              children: [
                TextSpan(
                  text: "All asterisk (",
                ),
                TextSpan(
                  text: "*",
                  style: textTheme.text14?.medium.copyWith(
                    color: Colors.red,
                  ),
                ),
                TextSpan(
                  text: ") are required fields",
                ),
              ],
            ),
          ),
          YBox(16),
          // Common Attributes list (filtered to exclude variant attributes)
          Builder(
            builder: (context) {
              // Filter out attributes that are selected as variant attributes
              final variantAttributeIds = configureVariantArg
                      ?.selectedVariantList
                      .map((attr) => attr.id)
                      .toSet() ??
                  <String>{};

              final commonAttributes = vm.selectedAttributeList
                  .where((attr) => !variantAttributeIds.contains(attr.id))
                  .toList();

              // Ensure we have the right number of controllers for common attributes only
              onEnsureControllers(commonAttributes.length);

              if (commonAttributes.isEmpty) {
                return Text(
                  productHasVariant
                      ? "No common attributes. All selected attributes are configured as variant attributes."
                      : "No attributes selected.",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  final attribute = commonAttributes[index];

                  return CustomTextField(
                    controller: attributeControllers[index],
                    labelText: attribute.attribute ?? '',
                    hintText: 'Select option',
                    showLabelHeader: true,
                    showSuffixIcon: true,
                    readOnly: true,
                    onTap: () async {
                      await ModalWrapper.bottomSheet(
                        context: context,
                        widget: StoreOptionModal(
                          options: attribute.possibleValues
                                  ?.map((e) => ModalOption(
                                      title: e,
                                      onTap: () {
                                        attributeControllers[index].text = e;
                                        Navigator.pop(context);
                                      }))
                                  .toList() ??
                              [],
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (__, _) => YBox(16),
                itemCount: commonAttributes.length,
              );
            },
          ),
          YBox(20),
          //!!OBSCURE VARIENT FLOW!!
          if (productHasVariant == true)
            CustomBtn.withChild(
              width: Sizer.screenWidth * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    color: colorScheme.white,
                  ),
                  XBox(10),
                  Text(
                    "Add Varying Attributes",
                    style: textTheme.text16?.medium.copyWith(
                      color: colorScheme.white,
                    ),
                  ),
                ],
              ),
              onTap: () async {
                final res = await ModalWrapper.bottomSheet(
                  context: context,
                  widget: ConfigureVariantModal(arg: configureVariantArg),
                );
                if (res is ConfigureVariantArg) {
                  onConfigureVariantChanged(res);
                }
              },
            ),
        ],
      ),
    );
  }
}
