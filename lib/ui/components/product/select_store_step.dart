import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SelectStoreStep extends ConsumerStatefulWidget {
  const SelectStoreStep({
    super.key,
    this.onNext,
  });

  final Function()? onNext;

  @override
  ConsumerState<SelectStoreStep> createState() => _SelectStoreStepState();
}

class _SelectStoreStepState extends ConsumerState<SelectStoreStep> {
  final storeC = TextEditingController();
  final storeF = FocusNode();


  @override
  void dispose() {
    storeC.dispose();
    storeF.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(productTransferVm);
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
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              FilterHeader(
                title: "Select Store",
                subTitle: "Select the store you want to send this request to",
              ),
              YBox(16),
              CustomTextField(
                controller: storeC,
                isRequired: false,
                labelText: 'Send Request To',
                // optionalText: "(optional)",
                hintText: 'Select store',
                showLabelHeader: true,
                readOnly: true,
                showSuffixIcon: true,
                validator: Validators.required(),
                onTap: () async {
                  final res = await ModalWrapper.bottomSheet(
                    context: context,
                    widget: StoreModal(),
                  );
                  if (res is StoreModel) {
                    vm.selectedStore = res;
                    storeC.text = res.name ?? '';
                    setState(() {});
                  }
                },
              ),
              YBox(300),
              CustomBtn(
                text: "Next",
                online: vm.selectedStore != null && storeC.text.isNotEmpty,
                onTap: () {
                  widget.onNext?.call();
                },
              ),
              YBox(30),
            ]),
          )
        ]);
  }
}
