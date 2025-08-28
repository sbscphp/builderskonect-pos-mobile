import 'package:builders_konnect/core/core.dart';

class SelectSourceModal extends ConsumerStatefulWidget {
  const SelectSourceModal({super.key});

  @override
  ConsumerState<SelectSourceModal> createState() => _SelectSourceModalState();
}

class _SelectSourceModalState extends ConsumerState<SelectSourceModal> {
  final _sources = [
    'Website',
    'Referral',
    'Social Media',
    'Walk-in',
  ];
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizer.width(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YBox(20),
          Row(
            children: [
              Text("Select Source", style: textTheme.text16?.medium),
              Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  color: AppColors.black,
                  size: Sizer.radius(24),
                ),
              )
            ],
          ),
          YBox(24),
          ListView.separated(
            shrinkWrap: true,
            itemCount: _sources.length,
            padding: EdgeInsets.only(
              bottom: Sizer.height(50),
            ),
            separatorBuilder: (_, __) => YBox(12),
            itemBuilder: (ctx, i) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context, _sources[i]);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizer.width(12),
                    vertical: Sizer.height(4),
                  ),
                  child: Text(
                    _sources[i],
                    style: textTheme.text16,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
