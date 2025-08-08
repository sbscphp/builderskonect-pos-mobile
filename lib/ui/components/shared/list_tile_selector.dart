import 'package:builders_konnect/core/core.dart';

import '../components.dart';

class ListTileSelector extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const ListTileSelector({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Skeleton.replace(
            replacement: Bone.circle(
              size: Sizer.height(16),
            ),
            child: CustomRadioBtn(
              // onTap: onTap,
              isSelected: isSelected,
            ),
          ),
          XBox(10),
          Text(
            title,
            style: textTheme.text14?.copyWith(
              color: colorScheme.black85,
            ),
          ),
        ],
      ),
    );
  }
}
