import 'package:builders_konnect/core/core.dart';

class SelectReasonModal extends ConsumerStatefulWidget {
  const SelectReasonModal({super.key});

  @override
  ConsumerState<SelectReasonModal> createState() => _SelectReasonModalState();
}

class _SelectReasonModalState extends ConsumerState<SelectReasonModal> {
  final List<String> reasons = [
    'Damaged goods',
    'Excess quantity',
    'Island Store',
    'Others',
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
          YBox(6),
          Align(
            alignment: Alignment.center,
            child: SvgPicture.asset(AppSvgs.modalHLine),
          ),
          YBox(20),
          Row(
            children: [
              Text("Select Reason", style: textTheme.text16?.medium),
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
          YBox(20),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: Sizer.height(50),
            ),
            itemCount: reasons.length,
            separatorBuilder: (context, index) => YBox(16),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pop(context, reasons[index]);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizer.width(12),
                    vertical: Sizer.height(6),
                  ),
                  child: Text(reasons[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
