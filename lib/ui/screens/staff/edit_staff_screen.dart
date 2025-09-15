import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class EditStaffScreen extends ConsumerStatefulWidget {
  const EditStaffScreen({super.key});

  @override
  ConsumerState<EditStaffScreen> createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends ConsumerState<EditStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final roleC = TextEditingController();
  final assignStoreC = TextEditingController();
  dynamic roleId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllers();
    });
  }

  _updateControllers() {
    final viewedUser = ref.read(staffVm).viewedStaff;
    fullNameC.text = viewedUser?.name ?? '';
    emailC.text = viewedUser?.email ?? '';
    phoneC.text = viewedUser?.phone ?? '';
    roleC.text = viewedUser?.assignedRoles ?? '';
    assignStoreC.text =
        viewedUser?.store?.firstOrNull ?? ''; //todo ::: handle assigned store
    roleId = ref
        .read(roleVm)
        .roles
        .firstWhere(
          (element) => element.name == viewedUser?.assignedRoles,
        )
        .id;

    setState(() {});
  }

  @override
  void dispose() {
    fullNameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    roleC.dispose();
    assignStoreC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(staffVm);
    return BusyOverlay(
      show: vm.isBusy,
      child: Scaffold(
          appBar: CustomAppbar(
            title: "Edit Staff",
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
                  Text("Edit Staff", style: textTheme.text16?.medium),
                  Text(
                    "Edit staff information below",
                    style: textTheme.text12?.copyWith(
                      color: colorScheme.black45,
                    ),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: fullNameC,
                    isRequired: false,
                    labelText: 'Full Name',
                    hintText: 'Enter full name',
                    enabled: false,
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: emailC,
                    isRequired: false,
                    labelText: 'Email',
                    enabled: false,

                    hintText: 'Enter email',
                    showLabelHeader: true,
                    validator: Validators.email(),
                    // readOnly: true,
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
                  YBox(16),
                  CustomTextField(
                    controller: phoneC,
                    isRequired: false,
                    labelText: 'Phone',
                    // optionalText: "(optional)",
                    hintText: 'Enter phone',
                    showLabelHeader: true,
                    keyboardType: TextInputType.phone,
                    validator: Validators.phoneNumber(),
                    onTap: () async {},
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: roleC,
                    isRequired: false,
                    labelText: 'Role',
                    // optionalText: "(optional)",
                    hintText: 'Enter role',
                    showLabelHeader: true,
                    readOnly: true,
                    showSuffixIcon: true,
                    validator: Validators.required(),
                    onTap: () async {
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: RoleModal(),
                      );
                      if (res is RoleModel) {
                        roleId = res.id;
                        roleC.text = res.name ?? '';
                        setState(() {});
                      }
                    },
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: assignStoreC,
                    isRequired: false,
                    labelText: 'Assign Store',
                    optionalText: "(optional)",
                    hintText: 'Enter assign store',
                    showLabelHeader: true,
                    readOnly: true,
                    showSuffixIcon: true,
                    // validator: Validators.required(),//optional
                    onTap: () async {
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: StateModal(),
                      );
                      if (res is RoleModel) {
                        roleId = res.id;
                        roleC.text = res.name ?? '';
                        setState(() {});
                      }
                    },
                  ),
                  YBox(20),
                  CustomBtn.solid(
                    text: "Save",
                    onTap: () async {
                      if (_formKey.currentState?.validate() == true) {
                        final res = await vm.updateStaff(
                            phone: phoneC.text, roleId: roleId);

                        handleApiResponse(
                          response: res,
                          onSuccess: () {
                            Navigator.pop(context);
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
