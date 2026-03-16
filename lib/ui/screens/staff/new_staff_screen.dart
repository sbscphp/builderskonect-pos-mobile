// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class NewStaffScreen extends ConsumerStatefulWidget {
  const NewStaffScreen({super.key});

  @override
  ConsumerState<NewStaffScreen> createState() => _NewStaffScreenState();
}

class _NewStaffScreenState extends ConsumerState<NewStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final roleC = TextEditingController();
  final assignStoreC = TextEditingController();
  dynamic roleId;
  List<StoreModel> selectedStores = [];

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
            title: "New Staff",
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
                  Text("Add New Staff", style: textTheme.text16?.medium),
                  Text(
                    "Fill the form below to add a new staff",
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
                    showLabelHeader: true,
                    validator: Validators.required(),
                  ),
                  YBox(16),
                  CustomTextField(
                    controller: emailC,
                    isRequired: false,
                    labelText: 'Email',
                    // optionalText: "(optional)",
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
                      //todo:: handle store bit here
                      final res = await ModalWrapper.bottomSheet(
                        context: context,
                        widget: StoresSelectionModal(),
                      );
                      if (res is List<StoreModel>) {
                        selectedStores.clear();
                        assignStoreC.clear();
                        selectedStores = res;
                        var ctrlText = "";
                        for (var element in res) {
                          ctrlText = "$ctrlText${element.name ?? ""}, ";
                        }
                        assignStoreC.text = ctrlText.replaceRange(
                            (ctrlText.length - 2), null, '');
                        setState(() {});
                      }
                    },
                  ),
                  YBox(20),
                  CustomBtn.solid(
                    text: "Save",
                    onTap: () async {
                      if (_formKey.currentState?.validate() == true) {
                        final res = await vm.addNewStaff(
                            fullName: fullNameC.text,
                            email: emailC.text,
                            phone: phoneC.text,
                            selectedStores: selectedStores,
                            roleId: roleId);

                        handleApiResponse(
                          response: res,
                          onSuccess: () async {
                            await vm.getDashboardStats(
                                busyObjectName: firstState);
                            ModalWrapper.bottomSheet(
                              context: context,
                              canDismiss: false,
                              widget: ConfirmationModal(
                                modalConfirmationArg: ModalConfirmationArg(
                                  iconPath: AppSvgs.checkIcon,
                                  title: "Staff Invite Sent Successfully",
                                  description:
                                      "An invite has been sent to this user to join Builder’sKonnect. The user will be required to create their own password to Login.",
                                  solidBtnText: "Okay, Good",
                                  onSolidBtnOnTap: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
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
