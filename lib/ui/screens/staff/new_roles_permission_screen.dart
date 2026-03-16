// ignore_for_file: use_build_context_synchronously

import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';
import 'package:builders_konnect/ui/components/shared/custom_expansion_tile.dart';

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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(roleVm).resetData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(roleVm);
    final isAllSelected = vm.isAllSelected();

    return BusyOverlay(
      show: vm.isBusy,
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
              child: Column(
                children: [
                  Expanded(
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
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.allow(
                          //       RegExp(r'[a-zA-Z]')),
                          // ],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomCheckbox(
                                  isSelected: isAllSelected,
                                  onTap: () {
                                    vm.toggleSelectAll();
                                  },
                                ),
                                XBox(8),
                                Text("Add All Permissions",
                                    style: textTheme.text12?.medium),
                              ],
                            ),
                            SizedBox(
                              width: 16.w,
                            ),
                            Text(
                                '${vm.selectedPermissions}/${vm.totalPermissions}',
                                style: textTheme.text12?.medium
                                    .copyWith(color: colorScheme.black45)),
                          ],
                        ),
                        YBox(20),
                        Builder(builder: (context) {
                          return ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final groupedPermission =
                                  vm.groupedPermissions[index];
                              final label =
                                  groupedPermission.label.replaceAll("_", " ");
                              final children = groupedPermission.items;
                              final isParentChecked =
                                  vm.isParentChecked(parentIndex: index);

                              return CustomExpansionTile(
                                bgColor: Colors.white,
                                primaryChild: Row(
                                  children: [
                                    CustomCheckbox(
                                      isSelected: isParentChecked,
                                      onTap: () {
                                        vm.toggleParent(parentIndex: index);
                                      },
                                    ),
                                    XBox(8),
                                    Text(label.capFirstLetter,
                                        style: textTheme.text12?.medium),
                                  ],
                                ),
                                secondaryChild: ListView.separated(
                                  padding: EdgeInsets.only(left: 12),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, childIndex) {
                                    final child = children[childIndex];
                                    final childId = child.id ?? 0;
                                    final childLabel =
                                        "${child.subModule ?? ''} ${child.name?.split('.').last ?? ''}"
                                            .replaceAll("_", " ");
                                    final isChildChecked =
                                        vm.isChildChecked(childId);

                                    return Row(
                                      children: [
                                        CustomCheckbox(
                                          isSelected: isChildChecked,
                                          onTap: () {
                                            vm.modifyList(id: childId);
                                          },
                                        ),
                                        XBox(8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                childLabel
                                                    .trim()
                                                    .capFirstLetter,
                                                style: textTheme.text12?.bold,
                                              ),
                                              Text(child.description ?? '',
                                                  style: textTheme.text12),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) => YBox(8),
                                  itemCount: children.length,
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => YBox(12),
                            itemCount: vm.groupedPermissions.length,
                          );
                        })
                      ],
                    ),
                  ),
                  CustomBtn.solid(
                    text: "Save",
                    onTap: () async {
                      if (_formKey.currentState?.validate() == true) {
                        if (vm.selectedIds.isEmpty) {
                          showWarningToast("Select at least one Permission!");
                          return;
                        }
                        final response = await vm.createRole(
                            name: roleNameC.text,
                            description: descriptionC.text);

                        handleApiResponse(
                            response: response,
                            onSuccess: () {
                              Navigator.pop(context);
                            });
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
