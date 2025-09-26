import 'package:builders_konnect/core/core.dart';

class UnitModalOption {
  final String title;
  final String? desc;
  final String? example;

  final VoidCallback onTap;
  final Color? textColor;
  final bool showTrailing;

  const UnitModalOption({
    required this.title,
    this.desc,
    this.example,
    required this.onTap,
    this.textColor,
    this.showTrailing = true,
  });
}

class UnitModal extends ConsumerStatefulWidget {
  const UnitModal({
    super.key,
    required this.options,
    this.title = "Selling Units",
  });

  final List<UnitModalOption> options;
  final String title;

  @override
  ConsumerState<UnitModal> createState() => _UnitModalState();
}

class _UnitModalState extends ConsumerState<UnitModal> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: Sizer.screenHeight * 0.5,
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
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                bottom: Sizer.height(40),
              ),
              itemCount: widget.options.length,
              separatorBuilder: (context, index) => YBox(16),
              itemBuilder: (context, index) {
                final option = widget.options[index];
                return _buildOptions(
                  colorScheme,
                  textTheme,
                  title: option.title,
                  desc: option.desc,
                  example: option.example,
                  onTap: option.onTap,
                  textColor: option.textColor,
                  showTrailing: option.showTrailing,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions(
    ColorScheme colorScheme,
    TextTheme textTheme, {
    required String title,
    String? desc,
    String? example,
    required bool showTrailing,
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
        // decoration: BoxDecoration(
        //   border: Border.all(
        //     color: colorScheme.text6,
        //   ),
        //   borderRadius: BorderRadius.circular(8),
        // ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: textTheme.text14?.copyWith(
                        color: textColor ?? colorScheme.black85,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Sizer.height(4)),
                      child: Text(
                        example ?? "",
                        style: textTheme.text12?.copyWith(
                          color: colorScheme.black45,
                        ),
                      ),
                    ),
                  ],
                ),
                if (desc != null)
                  Padding(
                    padding: EdgeInsets.only(
                      top: Sizer.height(4),
                    ),
                    child: Text(
                      desc,
                      style: textTheme.text14?.copyWith(
                        color: colorScheme.black45,
                      ),
                    ),
                  ),
              ],
            ),
            if (showTrailing) Spacer(),
            if (showTrailing)
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
