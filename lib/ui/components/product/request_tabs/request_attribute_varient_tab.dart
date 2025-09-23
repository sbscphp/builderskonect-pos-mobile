import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class RequestAttributeVarientTab extends ConsumerStatefulWidget {
  const RequestAttributeVarientTab({
    super.key,
    this.onNext,
    this.onPrevious,
  });

  final Function()? onNext;
  final Function()? onPrevious;

  @override
  ConsumerState<RequestAttributeVarientTab> createState() =>
      _RequestAttributeVarientTabState();
}

class _RequestAttributeVarientTabState
    extends ConsumerState<RequestAttributeVarientTab> {
  List<String> selectedAttributeList = [];
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.only(
        left: Sizer.width(16),
        right: Sizer.width(16),
        bottom: Sizer.height(50),
      ),
      children: [
        YBox(16),
        Container(
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
                  final attr = await ModalWrapper.bottomSheet(
                    context: context,
                    widget: AddAttributeModal(),
                  );
                  if (attr is List<String>) {
                    selectedAttributeList = attr;
                    setState(() {});
                  }
                },
              ),
              YBox(16),
              selectedAttributeList.isNotEmpty
                  ? Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: selectedAttributeList
                          .map(
                            (e) => TagWidget(
                              tag: e,
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
                        isSelected: true,
                        onTap: () {},
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
                        isSelected: false,
                        onTap: () {},
                      ),
                      XBox(8),
                      Text(
                        "No",
                        style: textTheme.text14?.medium,
                      ),
                    ],
                  ),
                ],
              )
              // CustomBtn.solid(
              //   text: "Next",
              //   onTap: () {},
              // ),
            ],
          ),
        ),
        YBox(16),
        Container(
          padding: EdgeInsets.all(Sizer.radius(16)),
          decoration: BoxDecoration(
            color: colorScheme.white,
            borderRadius: BorderRadius.circular(Sizer.radius(6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Common Attributes",
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
              CustomTextField(
                // controller: brandC,
                labelText: 'Size',
                hintText: 'Select option',
                showLabelHeader: true,
                showSuffixIcon: true,
                readOnly: true,
                onTap: () async {
                  final res = await ModalWrapper.bottomSheet(
                    context: context,
                    widget: ProductBrandModal(),
                  );
                },
              ),
              YBox(16),
              CustomTextField(
                // controller: brandC,
                labelText: 'Colour',
                hintText: 'Enter color',
                showLabelHeader: true,
              ),
              YBox(16),
              CustomTextField(
                // controller: brandC,
                labelText: 'Texture',
                hintText: 'Select option',
                showLabelHeader: true,
                showSuffixIcon: true,
                readOnly: true,
                onTap: () async {
                  final res = await ModalWrapper.bottomSheet(
                    context: context,
                    widget: ProductBrandModal(),
                  );
                },
              ),
              YBox(16),
              CustomTextField(
                // controller: brandC,
                labelText: 'Shape',
                hintText: 'Select option',
                showLabelHeader: true,
                showSuffixIcon: true,
                readOnly: true,
                onTap: () async {
                  final res = await ModalWrapper.bottomSheet(
                    context: context,
                    widget: ProductBrandModal(),
                  );
                },
              ),
              YBox(40),
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
                onTap: () {
                  widget.onNext?.call();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
