import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class CustomerDetailsStep extends ConsumerStatefulWidget {
  const CustomerDetailsStep({
    super.key,
    this.onNext,
  });

  final VoidCallback? onNext;

  @override
  ConsumerState<CustomerDetailsStep> createState() =>
      _CustomerDetailsStepState();
}

class _CustomerDetailsStepState extends ConsumerState<CustomerDetailsStep> {
  final formKey = GlobalKey<FormState>();

  final searchC = TextEditingController();

  @override
  void dispose() {
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return ListView(
      padding: EdgeInsets.only(
        top: Sizer.height(16),
        bottom: Sizer.height(60),
        left: Sizer.width(16),
        right: Sizer.width(16),
      ),
      children: [
        Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(Sizer.radius(16)),
            decoration: BoxDecoration(
              color: colorScheme.white,
              borderRadius: BorderRadius.circular(Sizer.radius(6)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Customer Details", style: textTheme.text16?.medium),
                YBox(8),
                CustomTextField(
                  controller: searchC,
                  isRequired: false,
                  showLabelHeader: false,
                  hintText: "Search customer name, id",
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
                          decoration: BoxDecoration(),
                          child: SvgPicture.asset(AppSvgs.search),
                        ),
                      ),
                    ],
                  ),
                ),
                HDivider(verticalPadding: 24),
                YBox(10),
                CustomTextField(
                  readOnly: true,
                  isRequired: false,
                  labelText: 'Name',
                  hintText: 'Name',
                  showLabelHeader: true,
                  fillColor: AppColors.neutral3,
                  validator: Validators.required(),
                ),
                YBox(10),
                CustomTextField(
                  readOnly: true,
                  isRequired: false,
                  labelText: 'Phone Number',
                  hintText: '0902344333',
                  showLabelHeader: true,
                  fillColor: AppColors.neutral3,
                  validator: Validators.required(),
                ),
                YBox(10),
                CustomTextField(
                  readOnly: true,
                  isRequired: false,
                  labelText: 'Email Address',
                  hintText: 'email@example.com',
                  showLabelHeader: true,
                  fillColor: AppColors.neutral3,
                  validator: Validators.required(),
                ),
                YBox(10),
                CustomTextField(
                  readOnly: true,
                  isRequired: false,
                  labelText: 'Source',
                  optionalText: "(How did they get to know about you?)",
                  hintText: 'facebook',
                  showLabelHeader: true,
                  fillColor: AppColors.neutral3,
                  validator: Validators.required(),
                ),
                YBox(16),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppSvgs.trashOutline,
                        height: Sizer.height(14),
                      ),
                      XBox(10),
                      Text(
                        "Remove Customer",
                        style: textTheme.text14?.copyWith(
                          color: AppColors.red2D,
                        ),
                      ),
                    ],
                  ),
                ),
                YBox(20),
                CustomBtn.solid(
                  text: "Next",
                  onTap: widget.onNext,
                ),
                YBox(10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
