// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class NewRolesPermissionScreen extends ConsumerStatefulWidget {
  const NewRolesPermissionScreen({super.key});

  @override
  ConsumerState<NewRolesPermissionScreen> createState() =>
      _NewRolesPermissionScreenState();
}

class _NewRolesPermissionScreenState
    extends ConsumerState<NewRolesPermissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final roleNameC = TextEditingController();
  final descriptionC = TextEditingController();

  @override
  void dispose() {
    roleNameC.dispose();
    descriptionC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return BusyOverlay(
      show: ref.watch(storeVmodel).busy(createState),
      child: Scaffold(
          appBar: CustomAppbar(
            title: "New Role",
          ),
          body: Container(
            padding: EdgeInsets.all(Sizer.radius(16)),
            margin: EdgeInsets.only(
              left: Sizer.radius(16),
              right: Sizer.radius(16),
              top: Sizer.radius(16),
            ),
            decoration: BoxDecoration(
              color: colorScheme.white,
              borderRadius: BorderRadius.circular(Sizer.radius(4)),
            ),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text("Add New Role", style: textTheme.text16?.medium),
                  Text(
                    "Fill the form below to add a new role",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: roleNameC,
                    isRequired: false,
                    labelText: 'Role Name',
                    hintText: 'Enter role name',
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: descriptionC,
                    isRequired: false,
                    labelText: 'Description',
                    hintText: 'Enter description',
                    showLabelHeader: true,
                    validator: Validators.required(),
                    maxLines: 3,
                    // onTsp: () async {
                    //   final res = await ModalWrapper.bottomSheet(
                    //     context: context,
                    //     widget: GoogleAddressModal(),
                    //   );
                    //   if (res is StateModel) {
                    //     stateC.text = res.name ?? "";
                    //     selectedState = res;
                    //   }
                    // },
                  ),
                  YBox(20),
                  CustomBtn.solid(
                    text: "Save",
                    onTap: () async {
                      if (_formKey.currentState?.validate() == true) {}
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
