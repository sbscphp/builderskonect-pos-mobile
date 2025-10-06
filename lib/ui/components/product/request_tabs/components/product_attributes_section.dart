import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class ProductAttributesSection extends ConsumerStatefulWidget {
  const ProductAttributesSection({
    super.key,
    // required this.attributeControllers,
    required this.productHasVariant,
    required this.onProductHasVariantChanged,
    required this.configureVariantArg,
    required this.onConfigureVariantChanged,
    required this.onEnsureControllers,
  });

  // final List<TextEditingController> attributeControllers;
  final bool productHasVariant;
  final Function(bool) onProductHasVariantChanged;
  final ConfigureVariantArg? configureVariantArg;
  final Function(ConfigureVariantArg?) onConfigureVariantChanged;
  final Function(int) onEnsureControllers;

  @override
  ConsumerState<ProductAttributesSection> createState() =>
      _ProductAttributesSectionState();
}

class _ProductAttributesSectionState
    extends ConsumerState<ProductAttributesSection> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productInventoryVmodel);

    return Container(
      padding: EdgeInsets.all(Sizer.radius(16)),
      decoration: BoxDecoration(
        color: colorScheme.white,
        borderRadius: BorderRadius.circular(Sizer.radius(6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterHeader(
            title: "Product Attributes",
            subTitle: "Select attributes you want to add to this product",
          ),
          YBox(40),
          CustomBtn(
            text: "Add attributes",
            isOutline: true,
            textColor: colorScheme.black85,
            onTap: () async {
              ModalWrapper.bottomSheet(
                context: context,
                widget: AddAttributeModal(),
              );
            },
          ),
          YBox(16),
          vm.selectedAttributeList.isNotEmpty
              ? Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: vm.selectedAttributeList
                      .map(
                        (e) => TagWidget(
                          tag: e.attribute ?? '',
                          onClose: () {
                            vm.selectedAttributeList.remove(e);
                            vm.reBuildUI();
                          },
                          showCloseIcon: true,
                          tagColor: TagColor(
                            bgColor: AppColors.greenED,
                            borderColor: AppColors.green8F,
                            textColor: AppColors.green1A,
                          ),
                        ),
                      )
                      .toList(),
                )
              : SizedBox.shrink(),
          if (vm.selectedAttributeList.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HDivider(),
                YBox(8),
                Text(
                  "Does this product have variants?",
                  style: textTheme.text14?.medium,
                ),
                YBox(10),
                Row(
                  children: [
                    Row(
                      children: [
                        CustomRadioBtn(
                          isSelected: widget.productHasVariant == true,
                          onTap: () {
                            widget.onProductHasVariantChanged(true);
                          },
                        ),
                        XBox(8),
                        Text(
                          "Yes",
                          style: textTheme.text14?.medium,
                        ),
                      ],
                    ),
                    XBox(40),
                    Row(
                      children: [
                        CustomRadioBtn(
                          isSelected: widget.productHasVariant == false,
                          onTap: () {
                            widget.onProductHasVariantChanged(false);
                          },
                        ),
                        XBox(8),
                        Text(
                          "No",
                          style: textTheme.text14?.medium,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }
}
