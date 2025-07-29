import 'package:builders_konnect/core/core.dart';

class StoreOptionModal extends ConsumerStatefulWidget {
  const StoreOptionModal({
    super.key,
  });

  @override
  ConsumerState<StoreOptionModal> createState() => _StoreOptionModalState();
}

class _StoreOptionModalState extends ConsumerState<StoreOptionModal> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          YBox(6),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(AppSvgs.modalHLine),
          ),
          YBox(16),
          Row(
            children: [
              Text(
                "Choose an option",
                style: textTheme.text16?.medium,
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.close,
                  size: Sizer.width(24),
                ),
              )
            ],
          ),
          YBox(24),
          _buildOptions(
            colorScheme,
            textTheme,
            title: "View store details",
            onTap: () {
              Navigator.pushNamed(context, RoutePath.viewStoreScreen);
            },
          ),
          YBox(16),
          _buildOptions(
            colorScheme,
            textTheme,
            title: "Store sales overview",
            onTap: () {},
          ),
          YBox(16),
          _buildOptions(
            colorScheme,
            textTheme,
            title: "Store products/inventory list",
            onTap: () {},
          ),
          YBox(50),
        ],
      ),
    );
  }

  Widget _buildOptions(
    ColorScheme colorScheme,
    TextTheme textTheme, {
    required String title,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Sizer.width(14),
          vertical: Sizer.height(10),
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.text6,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: textTheme.text14,
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: colorScheme.black85,
              size: Sizer.width(16),
            )
          ],
        ),
      ),
    );
  }
}
