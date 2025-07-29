import 'package:builders_konnect/core/core.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.bgColor,
    this.trailingWidget,
    this.leadingWidget,
    this.onBack,
  });

  final String title;
  final Color? bgColor;
  final Widget? trailingWidget;
  final Widget? leadingWidget;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return PreferredSize(
      preferredSize: Size.fromHeight(Sizer.height(50)),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor ?? AppColors.gray50,
          border: Border(
            bottom: BorderSide(
              color: bgColor ?? AppColors.grayF2,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: Sizer.width(16),
          vertical: Sizer.height(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: leadingWidget ??
                      InkWell(
                        onTap: onBack ??
                            () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                        child: SvgPicture.asset(AppSvgs.circleBack),
                      ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: Sizer.height(trailingWidget != null ? 0 : 20)),
                  child: Text(
                    title,
                    style: textTheme.text14?.medium,
                  ),
                ),
                Container(child: trailingWidget)
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(Sizer.height(50));
}
