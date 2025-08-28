import 'package:builders_konnect/core/core.dart';

class StoreListOptions extends ConsumerStatefulWidget {
  const StoreListOptions({super.key});

  @override
  ConsumerState<StoreListOptions> createState() => _StoreListOptionsState();
}

class _StoreListOptionsState extends ConsumerState<StoreListOptions> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: Sizer.screenHeight * 0.70,
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
              Text("Select City", style: textTheme.text16?.medium),
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
          YBox(16),
          Divider(color: AppColors.neutral4, height: 1),
          YBox(24),
        ],
      ),
    );
  }
}
