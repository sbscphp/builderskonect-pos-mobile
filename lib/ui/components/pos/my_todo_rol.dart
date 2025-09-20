import 'package:builders_konnect/core/core.dart';

class MyTodoRol extends StatelessWidget {
  const MyTodoRol({
    super.key,
    required this.leadiconPath,
    this.isDone = false,
    required this.title,
    this.onTap,
  });

  final bool isDone;
  final String leadiconPath;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: Sizer.width(8)),
        padding: EdgeInsets.symmetric(
          horizontal: Sizer.width(12),
          vertical: Sizer.height(12),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.text6),
          borderRadius: BorderRadius.circular(Sizer.radius(4)),
        ),
        child: Row(
          children: [
            SvgPicture.asset(leadiconPath),
            XBox(4),
            Text(
              title,
              style: textTheme.text14?.copyWith(
                color: AppColors.neutral9,
              ),
            ),
            XBox(16),
            SvgPicture.asset(
                isDone ? AppSvgs.checkCircle : AppSvgs.chevronRight),
          ],
        ),
      ),
    );
  }
}
