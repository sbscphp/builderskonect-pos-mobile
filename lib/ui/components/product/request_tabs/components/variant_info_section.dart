import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class VariantInfoSection extends ConsumerStatefulWidget {
  const VariantInfoSection({
    super.key,
    required this.attributeControllers,
    required this.isViewVariantInfo,
    required this.onToggleVariantInfo,
    required this.onEnsureControllers,
  });

  final List<TextEditingController> attributeControllers;
  final bool isViewVariantInfo;
  final VoidCallback onToggleVariantInfo;
  final Function(int) onEnsureControllers;

  @override
  ConsumerState<VariantInfoSection> createState() => _VariantInfoSectionState();
}

class _VariantInfoSectionState extends ConsumerState<VariantInfoSection> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final vm = ref.watch(productInventoryVmodel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Variant
        InkWell(
          onTap: widget.onToggleVariantInfo,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "${vm.variationParams?.name ?? "N/A"} variant 1",
                  style: textTheme.text16?.medium,
                ),
              ),
              Icon(widget.isViewVariantInfo
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down)
            ],
          ),
        ),
        HDivider(),
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: !widget.isViewVariantInfo
              ? YBox(20)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    // Common Attributes list
                    Builder(
                      builder: (context) {
                        // Ensure we have the right number of controllers
                        widget.onEnsureControllers(
                            vm.selectedAttributeList.length);

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            final attribute = vm.selectedAttributeList[index];

                            return CustomTextField(
                              controller: widget.attributeControllers[index],
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
                                                  widget
                                                      .attributeControllers[
                                                          index]
                                                      .text = e;
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
                          itemCount: vm.selectedAttributeList.length,
                        );
                      },
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
