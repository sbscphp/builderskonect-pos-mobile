import 'package:builders_konnect/core/core.dart';

class FilterHeader extends StatelessWidget {
  const FilterHeader({
    super.key,
    required this.title,
    this.subTitle,
    this.svgIcon,
    this.trailingWidget,
    this.onFilter,
  });

  final String title;
  final String? subTitle;
  final String? svgIcon;
  final Widget? trailingWidget;
  final Function()? onFilter;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.text16?.medium),
              if (subTitle != null)
                Text(
                  subTitle!,
                  style: textTheme.text12?.copyWith(
                    color: colorScheme.black45,
                  ),
                ),
            ],
          ),
        ),
        Container(
          child: trailingWidget ??
              (onFilter == null
                  ? SizedBox.shrink()
                  : InkWell(
                      onTap: onFilter,
                      child: SvgPicture.asset(
                        svgIcon ?? AppSvgs.filter,
                        height: Sizer.height(32),
                      ),
                    )),
        )
      ],
    );
  }
}

class NewButtonWidget extends StatelessWidget {
  const NewButtonWidget({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Sizer.width(8),
          vertical: Sizer.height(10),
        ),
        decoration: BoxDecoration(
          color: AppColors.dayBreakBlue,
          borderRadius: BorderRadius.circular(Sizer.radius(8)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(AppSvgs.plusCircle2),
            XBox(8),
            Text(
              "New",
              style: textTheme.text14?.medium.copyWith(
                color: colorScheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
