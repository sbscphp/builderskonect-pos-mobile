import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class AddProductBrandModal extends ConsumerStatefulWidget {
  const AddProductBrandModal({super.key});

  @override
  ConsumerState<AddProductBrandModal> createState() =>
      _AddProductBrandModalState();
}

class _AddProductBrandModalState extends ConsumerState<AddProductBrandModal> {
  final _formKey = GlobalKey<FormState>();
  final brandC = TextEditingController();

  @override
  void dispose() {
    brandC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    final categoryVm = ref.watch(categoryVmodel);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YBox(20),
            Row(
              children: [
                Text("Add Brand", style: textTheme.text16?.medium),
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
            YBox(24),
            CustomTextField(
              controller: brandC,
              isRequired: false,
              showLabelHeader: true,
              labelText: "Brand Name",
              hintText: "Enter brand name.",
              onChanged: (value) {},
              validator: Validators.required(),
            ),
            YBox(50),
            categoryVm.busy(createState)
                ? BtnLoadState()
                : Row(
                    children: [
                      Expanded(
                        child: CustomBtn(
                          isOutline: true,
                          textColor: AppColors.black,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          text: "Cancel",
                        ),
                      ),
                      XBox(10),
                      Expanded(
                        child: CustomBtn(
                          onTap: () async {
                            if (_formKey.currentState?.validate() == true) {
                              final res = await categoryVm.createBrands(
                                  brandName: brandC.text);

                              printty("res: $res");
                              printty("res data: ${res.data}");
                              final BrandModel? brand = res.data;
                              handleApiResponse(
                                response: res,
                                onSuccess: () {
                                  Navigator.pop(context, brand);
                                },
                              );
                            }
                          },
                          text: "Add Brand",
                        ),
                      ),
                    ],
                  ),
            YBox(40)
          ],
        ),
      ),
    );
  }
}
