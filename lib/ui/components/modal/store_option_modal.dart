import 'package:builders_konnect/core/core.dart';

/// A reusable modal widget that displays a list of options.
///
/// Usage example:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   builder: (context) => StoreOptionModal(
///     title: "Store Options", // Optional, defaults to "Choose an option"
///     options: [
///       ModalOption(
///         title: "View store details",
///         onTap: () {
///           Navigator.pushNamed(context, RoutePath.viewStoreScreen, arguments: store);
///         },
///       ),
///       ModalOption(
///         title: "Store sales overview",
///         onTap: () {
///           Navigator.pushNamed(context, RoutePath.storeSalesOverviewScreen, arguments: store);
///         },
///       ),
///       ModalOption(
///         title: "Store products/inventory list",
///         onTap: () {
///           Navigator.pushNamed(context, RoutePath.storeInventoryOverviewScreen, arguments: store);
///         },
///       ),
///     ],
///   ),
/// );
/// ```

class ModalOption {
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const ModalOption({
    required this.title,
    required this.onTap,
    this.textColor,
  });
}

class StoreOptionModal extends ConsumerStatefulWidget {
  const StoreOptionModal({
    super.key,
    required this.options,
    this.title = "Choose an option",
  });

  final List<ModalOption> options;
  final String title;

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
                widget.title,
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
          ...widget.options.map((option) => Column(
                children: [
                  _buildOptions(
                    colorScheme,
                    textTheme,
                    title: option.title,
                    onTap: option.onTap,
                    textColor: option.textColor,
                  ),
                  if (option != widget.options.last) YBox(16),
                ],
              )),
          YBox(50),
        ],
      ),
    );
  }

  Widget _buildOptions(
    ColorScheme colorScheme,
    TextTheme textTheme, {
    required String title,
    Color? textColor,
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
              style: textTheme.text14?.copyWith(
                color: textColor ?? colorScheme.black85,
              ),
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
