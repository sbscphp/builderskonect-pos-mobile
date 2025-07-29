import 'package:builders_konnect/core/core.dart';

class FilterHeader extends StatelessWidget {
  const FilterHeader({
    super.key,
    required this.title,
    required this.subTitle,
    this.svgIcon,
    this.onFilter,
  });

  final String title;
  final String subTitle;
  final String? svgIcon;
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
              Text(
                subTitle,
                style: textTheme.text12?.copyWith(
                  color: colorScheme.black45,
                ),
              ),
            ],
          ),
        ),
        if (onFilter != null)
          InkWell(
            onTap: onFilter,
            child: SvgPicture.asset(
              svgIcon ?? AppSvgs.filter,
              height: Sizer.height(32),
            ),
          )
      ],
    );
  }
}
