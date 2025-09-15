import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class EditInventoryModal extends ConsumerStatefulWidget {
  const EditInventoryModal({super.key});

  @override
  ConsumerState<EditInventoryModal> createState() => _EditInventoryModalState();
}

class _EditInventoryModalState extends ConsumerState<EditInventoryModal> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchFormRoles();
    });
  }

  _fetchFormRoles() async {
    final vm = ref.read(roleVm);
    if (vm.roles.isEmpty) {
      await vm.getAvailableRoles();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = ref.watch(roleVm);
    return Container(
      height: Sizer.screenHeight * 0.70,
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
                            "Golden Cement (10kg)",
                            style: textTheme.text14?.medium.copyWith(
                              color: AppColors.black23,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OrderStatus(status: "Low Stock")
                  ],
                ),
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
                            "Golden Cement (10kg)",
                            style: textTheme.text14?.medium.copyWith(
                              color: AppColors.black23,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OrderStatus(status: "Low Stock")
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
