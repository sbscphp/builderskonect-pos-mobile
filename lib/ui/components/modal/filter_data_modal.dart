import 'package:builders_konnect/core/core.dart';
import 'package:builders_konnect/ui/components/components.dart';

class SelectorGroup {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final String key; // Unique identifier for this group

  const SelectorGroup({
    required this.title,
    required this.options,
    required this.key,
    this.selectedValue,
  });
}

class FilterDataModal extends ConsumerStatefulWidget {
  final String? title;
  final String? subtitle;
  final String? dateTitle;
  final List<String>? selectors; // Deprecated - use selectorGroups instead
  final String? selectorsTitle; // Deprecated - use selectorGroups instead
  final List<SelectorGroup>? selectorGroups; // New: Multiple selector groups
  final bool showPriceRange;
  final String? priceRangeTitle;
  final String? priceFromLabel;
  final String? priceToLabel;
  final Function(Map<String, dynamic>)? onFilter;
  final VoidCallback? onReset;
  final String? selectedSelector; // Deprecated - use selectorGroups instead

  const FilterDataModal({
    super.key,
    this.title = "Filter Data",
    this.subtitle = "Filter by the following options.",
    this.dateTitle = "Date Added",
    this.selectors,
    this.selectorsTitle,
    this.selectorGroups,
    this.showPriceRange = false,
    this.priceRangeTitle = "Price Range",
    this.priceFromLabel = "From",
    this.priceToLabel = "To",
    this.onFilter,
    this.onReset,
    this.selectedSelector,
  });

  @override
  ConsumerState<FilterDataModal> createState() => _FilterDataModalState();
}

class _FilterDataModalState extends ConsumerState<FilterDataModal> {
  String? selectedLabel;
  DateTime? selectedDate;
  DateTime? endDate;
  bool isCustomdate = false;
  String? selectedSelectorValue;
  Map<String, String> selectedSelectorValues =
      {}; // For multiple selector groups

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _priceFromController = TextEditingController();
  final TextEditingController _priceToController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedSelectorValue = widget.selectedSelector;

    // Initialize selector groups with their default values
    if (widget.selectorGroups != null) {
      for (final group in widget.selectorGroups!) {
        if (group.selectedValue != null) {
          selectedSelectorValues[group.key] = group.selectedValue!;
        }
      }
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _priceFromController.dispose();
    _priceToController.dispose();
    super.dispose();
  }

  // Show custom date picker dialog
  Future<void> _showCustomDatePicker(BuildContext context) async {
    final result = await showDialog<Map<String, DateTime?>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizer.radius(16)),
          ),
          child: CustomDatePicker(
            initialDate: selectedDate ?? DateTime.now(),
            endDate: endDate,
            minDate: DateTime.now()
                .subtract(const Duration(days: 365)), // 1 year ago
            maxDate: DateTime.now()
                .add(const Duration(days: 365)), // 1 year from now
            onDateSelected: (startDate, rangeEndDate) {
              Navigator.of(context).pop({
                'startDate': startDate,
                'endDate': rangeEndDate,
              });
            },
          ),
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedDate = result['startDate'];
        endDate = result['endDate'];
        isCustomdate = true;
        // Reset the predefined date options when custom date is selected
        selectedLabel = null;

        // Update text controllers
        if (selectedDate != null) {
          _startDateController.text =
              "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}";
        }
        if (endDate != null) {
          _endDateController.text =
              "${endDate!.day}/${endDate!.month}/${endDate!.year}";
        }
      });
    }
  }

  void _handleReset() {
    setState(() {
      selectedLabel = null;
      selectedDate = null;
      endDate = null;
      isCustomdate = false;
      selectedSelectorValue = null;
      selectedSelectorValues.clear();
      _startDateController.clear();
      _endDateController.clear();
      _priceFromController.clear();
      _priceToController.clear();
    });

    if (widget.onReset != null) {
      widget.onReset!();
    }
  }

  void _handleFilter() {
    final filterData = <String, dynamic>{};

    if (selectedDate != null) {
      filterData['startDate'] = selectedDate;
    }
    if (endDate != null) {
      filterData['endDate'] = endDate;
    }

    // Handle legacy single selector
    if (selectedSelectorValue != null) {
      filterData['selectedOption'] = selectedSelectorValue;
    }

    // Handle multiple selector groups
    if (selectedSelectorValues.isNotEmpty) {
      filterData['selectorGroups'] = selectedSelectorValues;
    }

    if (_priceFromController.text.isNotEmpty) {
      filterData['priceFrom'] = _priceFromController.text;
    }
    if (_priceToController.text.isNotEmpty) {
      filterData['priceTo'] = _priceToController.text;
    }

    if (widget.onFilter != null) {
      widget.onFilter!(filterData);
    }

    Navigator.pop(context, filterData);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: Sizer.screenHeight * 0.6,
      child: Column(
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
                      Text(widget.title ?? "Filter Data",
                          style: textTheme.text16?.medium),
                      YBox(4),
                      Text(
                        widget.subtitle ?? "Filter by the following options.",
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
          Expanded(
            child: ListView(
              children: [
                YBox(16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizer.width(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date Section
                      if (widget.dateTitle != null) ...[
                        Text(widget.dateTitle!,
                            style: textTheme.text16?.medium),
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
                                onTsp: () async {
                                  await _showCustomDatePicker(context);
                                },
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
                                onTsp: () async {
                                  await _showCustomDatePicker(context);
                                },
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
                      ],

                      // Legacy Single Selector Section (for backward compatibility)
                      if (widget.selectors != null &&
                          widget.selectors!.isNotEmpty) ...[
                        Text(widget.selectorsTitle ?? "Options",
                            style: textTheme.text16?.medium),
                        YBox(8),
                        ...widget.selectors!.asMap().entries.map((entry) {
                          final index = entry.key;
                          final selector = entry.value;
                          return Column(
                            children: [
                              ListTileSelector(
                                title: selector,
                                isSelected: selectedSelectorValue == selector,
                                onTap: () {
                                  setState(() {
                                    selectedSelectorValue = selector;
                                  });
                                },
                              ),
                              if (index < widget.selectors!.length - 1)
                                YBox(16),
                            ],
                          );
                        }),
                        YBox(24),
                      ],

                      // Multiple Selector Groups Section
                      if (widget.selectorGroups != null &&
                          widget.selectorGroups!.isNotEmpty) ...[
                        ...widget.selectorGroups!
                            .asMap()
                            .entries
                            .map((groupEntry) {
                          final groupIndex = groupEntry.key;
                          final group = groupEntry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(group.title,
                                  style: textTheme.text16?.medium),
                              YBox(8),
                              ...group.options
                                  .asMap()
                                  .entries
                                  .map((optionEntry) {
                                final optionIndex = optionEntry.key;
                                final option = optionEntry.value;
                                return Column(
                                  children: [
                                    ListTileSelector(
                                      title: option,
                                      isSelected:
                                          selectedSelectorValues[group.key] ==
                                              option,
                                      onTap: () {
                                        setState(() {
                                          selectedSelectorValues[group.key] =
                                              option;
                                        });
                                      },
                                    ),
                                    if (optionIndex < group.options.length - 1)
                                      YBox(16),
                                  ],
                                );
                              }),
                              if (groupIndex <
                                  widget.selectorGroups!.length - 1)
                                YBox(24),
                            ],
                          );
                        }),
                        if (widget.selectorGroups!.isNotEmpty) YBox(24),
                      ],

                      // Price Range Section
                      if (widget.showPriceRange) ...[
                        Text(widget.priceRangeTitle ?? "Price Range",
                            style: textTheme.text16?.medium),
                        YBox(8),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _priceFromController,
                                labelText: widget.priceFromLabel ?? 'From',
                                hintText: 'Enter Amount',
                                showLabelHeader: true,
                                isRequired: false,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            XBox(16),
                            Expanded(
                              child: CustomTextField(
                                controller: _priceToController,
                                labelText: widget.priceToLabel ?? 'To',
                                hintText: 'Enter Amount',
                                showLabelHeader: true,
                                isRequired: false,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                        YBox(24),
                      ],

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: CustomBtn.solid(
                              text: "Reset",
                              height: 42,
                              isOutline: true,
                              outlineColor: AppColors.neutral5,
                              textStyle: textTheme.text16,
                              onTap: _handleReset,
                            ),
                          ),
                          XBox(16),
                          Expanded(
                            child: CustomBtn.solid(
                              text: "Filter",
                              height: 42,
                              onTap: _handleFilter,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                YBox(30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
