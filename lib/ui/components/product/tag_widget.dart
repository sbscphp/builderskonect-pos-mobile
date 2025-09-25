import 'package:builders_konnect/core/core.dart';

class TagWidget extends StatelessWidget {
  const TagWidget({
    super.key,
    required this.tag,
    this.tagColor,
    this.showCloseIcon = false,
    this.onClose,
  });

  final String tag;
  final bool showCloseIcon;
  final TagColor? tagColor;
  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(8),
        vertical: Sizer.height(4),
      ),
      decoration: BoxDecoration(
        color: tagColor?.bgColor ?? AppColors.dayBreakBlue,
        border: Border.all(
          color: tagColor?.borderColor ?? AppColors.dayBreakBlue3,
        ),
        borderRadius: BorderRadius.circular(Sizer.radius(2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: textTheme.text12?.copyWith(
              color: tagColor?.textColor ?? colorScheme.primaryColor,
            ),
          ),
          if (showCloseIcon)
            InkWell(
              onTap: onClose,
              child: Padding(
                padding: EdgeInsets.only(left: Sizer.width(6)),
                child: Icon(
                  Icons.close,
                  size: Sizer.radius(14),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class TagColor {
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  TagColor({
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
  });
}
