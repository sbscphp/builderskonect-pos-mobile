import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class FilterDataModal extends ConsumerStatefulWidget {
  const FilterDataModal({
    super.key,
  });

  @override
  ConsumerState<FilterDataModal> createState() => _FilterDataModalState();
}

class _FilterDataModalState extends ConsumerState<FilterDataModal> {
  String? selectedLabel;
  DateTime? selectedDate;
  DateTime? endDate;
  bool isCustomdate = false;
  
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _showStartDatePicker() {
    CustomCupertinoDatePicker(
      context: context,
      initialDateTime: selectedDate ?? DateTime.now(),
      maximumDate: endDate ?? DateTime.now().add(const Duration(days: 365)),
      onDateTimeChanged: (DateTime date) {
        setState(() {
          selectedDate = date;
        });
      },
      onDone: () {
        if (selectedDate != null) {
          _startDateController.text = AppUtils.dayWithSuffixMonthAndYear(selectedDate!);
        }
        Navigator.of(context).pop();
      },
    ).show();
  }

  void _showEndDatePicker() {
    CustomCupertinoDatePicker(
      context: context,
      initialDateTime: endDate ?? DateTime.now(),
      minimumDate: selectedDate ?? DateTime(2020),
      maximumDate: DateTime.now().add(const Duration(days: 365)),
      onDateTimeChanged: (DateTime date) {
        setState(() {
          endDate = date;
        });
      },
      onDone: () {
        if (endDate != null) {
          _endDateController.text = AppUtils.dayWithSuffixMonthAndYear(endDate!);
        }
        Navigator.of(context).pop();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    // final deliveryVm = ref.watch(deliveryVmodel);
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        YBox(20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Filter Data", style: textTheme.text16?.medium),
                    YBox(4),
                    Text(
                      "Filter by the following options.",
                      style: textTheme.text12?.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                  size: Sizer.width(26),
                ),
              )
            ],
          ),
        ),
        YBox(16),
        Divider(color: AppColors.neutral4, height: 1),
        YBox(20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Date Added", style: textTheme.text16?.medium),
              YBox(8),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _startDateController,
                      labelText: 'Start Date',
                      hintText: 'Enter Date',
                      showLabelHeader: true,
                      isRequired: false,
                      readOnly: true,
                      onTsp: _showStartDatePicker,
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(
                          right: Sizer.radius(10),
                          left: Sizer.radius(4),
                        ),
                        child: SvgPicture.asset(AppSvgs.inputSuffix),
                      ),
                    ),
                  ),
                  XBox(16),
                  Expanded(
                    child: CustomTextField(
                      controller: _endDateController,
                      labelText: 'End Date',
                      hintText: 'Enter Date',
                      showLabelHeader: true,
                      isRequired: false,
                      readOnly: true,
                      onTsp: _showEndDatePicker,
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(
                          right: Sizer.radius(10),
                          left: Sizer.radius(4),
                        ),
                        child: SvgPicture.asset(AppSvgs.inputSuffix),
                      ),
                    ),
                  ),
                ],
              ),
              YBox(24),
              Text("Status", style: textTheme.text16?.medium),
              YBox(8),
              ListTileSelector(
                title: "All",
                isSelected: false,
                onTap: () {},
              ),
              YBox(16),
              ListTileSelector(
                title: "Processing",
                isSelected: false,
                onTap: () {},
              ),
              YBox(16),
              ListTileSelector(
                title: "Cancelled",
                isSelected: false,
                onTap: () {},
              ),
              YBox(16),
              ListTileSelector(
                title: "Completed",
                isSelected: false,
                onTap: () {},
              ),
              YBox(24),
              Text("Price Range", style: textTheme.text16?.medium),
              YBox(8),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      labelText: 'From',
                      hintText: 'Enter Amount',
                      showLabelHeader: true,
                      isRequired: false,
                      readOnly: true,
                    ),
                  ),
                  XBox(16),
                  Expanded(
                    child: CustomTextField(
                      labelText: 'To',
                      hintText: 'Enter Amount',
                      showLabelHeader: true,
                      isRequired: false,
                      readOnly: true,
                    ),
                  ),
                ],
              ),
              YBox(24),
              Row(
                children: [
                  Expanded(
                    child: CustomBtn.solid(
                      text: "Reset",
                      height: 42,
                      isOutline: true,
                      outlineColor: AppColors.neutral5,
                      textStyle: textTheme.text16,
                      onTap: () {
                        printty("Login");
                        Navigator.of(context).pushNamed(
                          RoutePath.loginScreen,
                          // arguments: "login",
                        );
                      },
                    ),
                  ),
                  XBox(16),
                  Expanded(
                    child: CustomBtn.solid(
                      text: "Filter",
                      height: 42,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          RoutePath.pricingPlansScreen,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        YBox(40),
      ],
    );
  }
}
