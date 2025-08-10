import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class RolePermissionTab extends ConsumerStatefulWidget {
  const RolePermissionTab({super.key});

  @override
  ConsumerState<RolePermissionTab> createState() => _RolePermissionTabState();
}

class _RolePermissionTabState extends ConsumerState<RolePermissionTab> {
  final searchC = TextEditingController();

  @override
  void dispose() {
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(Sizer.radius(16)),
      decoration: BoxDecoration(
        color: colorScheme.white,
        borderRadius: BorderRadius.circular(Sizer.radius(4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilterHeader(
            title: "Roles and Permissions",
            subTitle: "Manage user roles and permissions ",
            svgIcon: AppSvgs.circleAdd,
            trailingWidget: NewButtonWidget(
              onTap: () {
                Navigator.pushNamed(
                    context, RoutePath.newRolesPermissionScreen);
              },
            ),
          ),
          YBox(16),
          CustomTextField(
            controller: searchC,
            isRequired: false,
            showLabelHeader: false,
            hintText: "Search roles",
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
                    decoration: BoxDecoration(
                        border: Border(
                      left: BorderSide(
                        color: AppColors.neutral5,
                      ),
                    )),
                    child: SvgPicture.asset(AppSvgs.search),
                  ),
                ),
              ],
            ),
          ),
          YBox(16),
          Builder(builder: (context) {
            if (1 + 2 == 2) {
              return SizedBox(
                height: Sizer.height(300),
                child: EmptyListState(
                  text: "No Data",
                ),
              );
            }
            return Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: 10,
                  separatorBuilder: (_, __) => YBox(16),
                  itemBuilder: (ctx, i) {
                    return PermissionListTile();
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class PermissionListTile extends StatelessWidget {
  const PermissionListTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(Sizer.radius(16)),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.neutral5,
        ),
        borderRadius: BorderRadius.circular(Sizer.radius(6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customer Success Rep",
                  style: textTheme.text16?.medium,
                ),
                YBox(8),
                Text(
                  "This role has access to the customer management and sales features.",
                  style: textTheme.text12?.copyWith(
                    color: colorScheme.black45,
                  ),
                ),
              ],
            ),
          ),
          CustomSwitch(
            value: false,
            onChanged: (value) {},
          )
        ],
      ),
    );
  }
}
