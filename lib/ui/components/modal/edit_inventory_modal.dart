import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class EditInventoryModal extends ConsumerStatefulWidget {
  const EditInventoryModal({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  ConsumerState<EditInventoryModal> createState() => _EditInventoryModalState();
}

class _EditInventoryModalState extends ConsumerState<EditInventoryModal> {
  final _formKey = GlobalKey<FormState>();
  final _stockLevelC = TextEditingController();
  final _reOrderValueC = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _stockLevelC.dispose();
    _reOrderValueC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final inventoryVm = ref.watch(productInventoryVmodel);
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Edit Inventory", style: textTheme.text16?.medium),
                  YBox(4),
                  Text(
                    "Fill the information below to edit this product inventory.",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                ],
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
          Divider(color: AppColors.neutral4, height: 1),
          YBox(20),
          Container(
            padding: EdgeInsets.all(Sizer.radius(16)),
            decoration: BoxDecoration(
              color: AppColors.neutral3,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Product Name",
                            style: textTheme.text12?.copyWith(
                              color: AppColors.grey175,
                            ),
                          ),
                          YBox(4),
                          Text(
                            widget.product.name ?? "N/A",
                            style: textTheme.text14?.medium.copyWith(
                              color: AppColors.black23,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OrderStatus(status: widget.product.status ?? "N/A")
                  ],
                ),
                YBox(16),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Stock Level",
                          style: textTheme.text12?.copyWith(
                            color: AppColors.grey175,
                          ),
                        ),
                        YBox(4),
                        Text(
                          widget.product.quantity?.toString() ?? "N/A",
                          style: textTheme.text14?.medium.copyWith(
                            color: AppColors.black23,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Re-order Level",
                          style: textTheme.text12?.copyWith(
                            color: AppColors.grey175,
                          ),
                        ),
                        YBox(4),
                        Text(
                          widget.product.reorderValue?.toString() ?? "N/A",
                          style: textTheme.text14?.medium.copyWith(
                            color: AppColors.black23,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          YBox(24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  controller: _stockLevelC,
                  isRequired: false,
                  labelText: 'Added Stock Quantity',
                  hintText: 'Enter quantity',
                  showLabelHeader: true,
                  validator: Validators.required(),
                ),
                YBox(16),
                CustomTextField(
                  controller: _reOrderValueC,
                  isRequired: false,
                  labelText: 'New Reorder Level',
                  hintText: 'Enter reorder level',
                  showLabelHeader: true,
                  // validator: Validators.required(),
                ),
                YBox(24),
              ],
            ),
          ),
          inventoryVm.busy(updateState)
              ? BtnLoadState()
              : Row(
                  children: [
                    Expanded(
                      child: CustomBtn.solid(
                        text: "Cancel",
                        isOutline: true,
                        outlineColor: AppColors.neutral5,
                        textStyle: textTheme.text16,
                        onTap: () {},
                      ),
                    ),
                    XBox(16),
                    Expanded(
                      child: CustomBtn.solid(
                        text: "Save",
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            final result = await ModalWrapper.bottomSheet(
                              context: context,
                              widget: ConfirmationModal(
                                modalConfirmationArg: ModalConfirmationArg(
                                  iconPath: AppSvgs.infoCircleRed,
                                  title: "Trigger Reorder",
                                  description:
                                      "Are you sure you want to trigger a reorder of this product? Procurement will be notified of this restock request.",
                                  solidBtnText: "Yes, trigger",
                                  onSolidBtnOnTap: () {
                                    Navigator.pop(context, true);
                                  },
                                  onOutlineBtnOnTap: () {
                                    Navigator.pop(context, false);
                                  },
                                ),
                              ),
                            );
                            if (result == true) {
                              final res = await ref
                                  .read(productInventoryVmodel)
                                  .editInventoryLevel(
                                    productId: widget.product.id ?? "",
                                    quantity: _stockLevelC.text.trim(),
                                    reOrderValue: _reOrderValueC.text.trim(),
                                  );

                              handleApiResponse(
                                response: res,
                                onSuccess: () {
                                  Navigator.pop(
                                      NavKey.appNavKey.currentContext!);
                                  ref
                                      .read(productInventoryVmodel)
                                      .getInventoryProducts();
                                },
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
          YBox(40),
        ],
      ),
    );
  }
}
