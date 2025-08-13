import 'package:builders_konnect/core/core.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? endDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool isRangeSelection;
  final Function(DateTime, DateTime?) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    this.endDate,
    this.minDate,
    this.maxDate,
    this.isRangeSelection = false,
    required this.onDateSelected,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;
  DateTime? _endDate;
  late DateTime _currentMonth;
  late PageController _pageController;
  final TextEditingController _dateController = TextEditingController();
  bool _isEditingDate = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _endDate = widget.endDate;
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
    _pageController = PageController(initialPage: 0);
    _dateController.text = _formatSelectedDate();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _selectDate(DateTime date) {
    if (widget.isRangeSelection &&
        _endDate == null &&
        date.isAfter(_selectedDate)) {
      // Selecting end date in range mode
      setState(() {
        _endDate = date;
      });
    } else {
      // Selecting start date
      setState(() {
        _selectedDate = date;
        if (widget.isRangeSelection) {
          _endDate = null; // Reset end date when start date changes
        }
      });
    }
  }

  bool _isDateSelectable(DateTime date) {
    if (widget.minDate != null && date.isBefore(widget.minDate!)) {
      return false;
    }
    if (widget.maxDate != null && date.isAfter(widget.maxDate!)) {
      return false;
    }
    return true;
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _showMonthYearPicker() async {
    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) => _MonthYearPickerDialog(
        currentDate: _currentMonth,
        minDate: widget.minDate,
        maxDate: widget.maxDate,
      ),
    );

    if (result != null) {
      setState(() {
        _currentMonth = DateTime(result.year, result.month, 1);
      });
    }
  }

  void _applyEditedDate() {
    try {
      // Try to parse the entered date
      final parts = _dateController.text.split(', ');
      if (parts.length == 2) {
        // We don't need the weekday part for parsing
        final datePart = parts[1]; // e.g., "Aug 17"

        final dateParts = datePart.split(' ');
        if (dateParts.length == 2) {
          final month = dateParts[0]; // e.g., "Aug"
          final day = int.parse(dateParts[1]); // e.g., 17

          final months = [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec'
          ];
          final monthIndex = months.indexOf(month);

          if (monthIndex >= 0 && day > 0 && day <= 31) {
            final newDate = DateTime(_currentMonth.year, monthIndex + 1, day);
            if (_isDateSelectable(newDate)) {
              setState(() {
                _selectedDate = newDate;
                _isEditingDate = false;
              });
              return;
            }
          }
        }
      }

      // If parsing fails, revert to the original date
      _dateController.text = _formatSelectedDate();
      setState(() {
        _isEditingDate = false;
      });
    } catch (e) {
      // If any error occurs, revert to the original date
      _dateController.text = _formatSelectedDate();
      setState(() {
        _isEditingDate = false;
      });
    }
  }

  String _formatSelectedDate() {
    final List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final weekday =
        weekdays[_selectedDate.weekday - 1]; // weekday is 1-7 where 1 is Monday
    final month = months[_selectedDate.month - 1]; // month is 1-12
    final day = _selectedDate.day;

    return '$weekday, $month $day';
  }

  String _formatDateRange() {
    if (!widget.isRangeSelection || _endDate == null) {
      return _formatSelectedDate();
    }

    return '${_formatSelectedDate()} - ${_formatDate(_endDate!)}';
  }

  String _formatDate(DateTime date) {
    final List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    final List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final weekday =
        weekdays[date.weekday - 1]; // weekday is 1-7 where 1 is Monday
    final month = months[date.month - 1]; // month is 1-12
    final day = date.day;

    return '$weekday, $month $day';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizer.radius(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(Sizer.width(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select date',
                  style: textTheme.text16?.medium.copyWith(
                    color: AppColors.black.withValues(alpha: 0.6),
                  ),
                ),
                YBox(8), // Reduced spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _isEditingDate
                        ? Expanded(
                            child: TextField(
                              controller: _dateController,
                              style: textTheme.text14?.bold,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Mon, Aug 17',
                                hintStyle: textTheme.text14?.bold.copyWith(
                                  color:
                                      AppColors.gray500.withValues(alpha: 0.5),
                                ),
                              ),
                              onSubmitted: (_) => _applyEditedDate(),
                            ),
                          )
                        : Text(
                            widget.isRangeSelection && _endDate != null
                                ? _formatDateRange()
                                : _formatSelectedDate(),
                            style: textTheme.text14?.bold, // Reduced text size
                          ),
                    IconButton(
                      onPressed: () {
                        if (_isEditingDate) {
                          _applyEditedDate();
                        } else {
                          setState(() {
                            _isEditingDate = true;
                            _dateController.text = _formatSelectedDate();
                          });
                        }
                      },
                      icon: Icon(
                        _isEditingDate ? Icons.check : Icons.edit,
                        color: AppColors.gray500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.neutral4,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Sizer.width(16),
              vertical: Sizer.height(8), // Reduced padding
            ),
            child: Column(
              children: [
                // Month selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _showMonthYearPicker,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizer.width(8),
                          vertical: Sizer.height(4),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Sizer.radius(4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateFormat('MMMM yyyy').format(_currentMonth),
                              style: textTheme.text14?.medium,
                            ),
                            XBox(4),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.gray500,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _previousMonth,
                          icon: Icon(
                            Icons.chevron_left,
                            color: AppColors.gray500,
                          ),
                          padding: EdgeInsets.zero, // Reduced padding
                          constraints: BoxConstraints(), // Remove constraints
                          visualDensity:
                              VisualDensity.compact, // Compact layout
                        ),
                        IconButton(
                          onPressed: _nextMonth,
                          icon: Icon(
                            Icons.chevron_right,
                            color: AppColors.gray500,
                          ),
                          padding: EdgeInsets.zero, // Reduced padding
                          constraints: BoxConstraints(), // Remove constraints
                          visualDensity:
                              VisualDensity.compact, // Compact layout
                        ),
                      ],
                    ),
                  ],
                ),
                YBox(8), // Reduced spacing
                // Calendar grid
                _buildCalendarGrid(),
                YBox(8), // Reduced spacing
                // Range selection info
                if (widget.isRangeSelection)
                  Padding(
                    padding: EdgeInsets.only(bottom: Sizer.height(8)),
                    child: Text(
                      _endDate == null
                          ? 'Select end date'
                          : 'Date range selected',
                      style: textTheme.text12?.medium.copyWith(
                        color: AppColors.gray500,
                      ),
                    ),
                  ),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizer.width(8),
                          vertical: Sizer.height(4),
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: Text(
                        'Cancel',
                        style: textTheme.text14?.medium.copyWith(
                          color: AppColors.red,
                        ),
                      ),
                    ),
                    XBox(16),
                    TextButton(
                      onPressed: () {
                        widget.onDateSelected(_selectedDate, _endDate);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizer.width(8),
                          vertical: Sizer.height(4),
                        ),
                        minimumSize: Size.zero,
                      ),
                      child: Text(
                        'OK',
                        style: textTheme.text14?.medium.copyWith(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // Get the first day of the month
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);

    // Calculate the day of week (0 is Sunday, 1 is Monday, etc.)
    int firstDayOfWeek = firstDay.weekday; // 1-7 (Monday-Sunday)

    // Adjust for Sunday as first day of week if needed
    if (firstDayOfWeek == 7) firstDayOfWeek = 0;

    // Get the number of days in the month
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _WeekdayHeader('S'),
            _WeekdayHeader('M'),
            _WeekdayHeader('T'),
            _WeekdayHeader('W'),
            _WeekdayHeader('T'),
            _WeekdayHeader('F'),
            _WeekdayHeader('S'),
          ],
        ),
        YBox(8), // Reduced spacing
        // Calendar days
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1.2, // Adjusted for more compact layout
          ),
          itemCount: 42, // 6 rows of 7 days
          itemBuilder: (context, index) {
            // Calculate the day to display
            int day = index - firstDayOfWeek + 1;

            // Check if the day is within the current month
            if (day < 1 || day > daysInMonth) {
              return const SizedBox();
            }

            // Create a DateTime for this day
            final date = DateTime(_currentMonth.year, _currentMonth.month, day);

            // Check if this day is selectable (within min/max range)
            final isSelectable = _isDateSelectable(date);

            // Check if this day is selected
            final isSelected = _selectedDate.year == date.year &&
                _selectedDate.month == date.month &&
                _selectedDate.day == date.day;

            // Check if this day is in the selected range
            final isInRange = widget.isRangeSelection &&
                _endDate != null &&
                date.isAfter(_selectedDate) &&
                (date.isBefore(_endDate!) || date.isAtSameMomentAs(_endDate!));

            // Check if this day is the end date
            final isEndDate = _endDate != null &&
                _endDate!.year == date.year &&
                _endDate!.month == date.month &&
                _endDate!.day == date.day;

            // Check if this day is today
            final isToday = DateTime.now().year == date.year &&
                DateTime.now().month == date.month &&
                DateTime.now().day == date.day;

            return _CalendarDay(
              day: day,
              isSelected: isSelected,
              isEndDate: isEndDate,
              isInRange: isInRange,
              isToday: isToday,
              isSelectable: isSelectable,
              onTap: isSelectable ? () => _selectDate(date) : null,
            );
          },
        ),
      ],
    );
  }
}

class _MonthYearPickerDialog extends StatefulWidget {
  final DateTime currentDate;
  final DateTime? minDate;
  final DateTime? maxDate;

  const _MonthYearPickerDialog({
    required this.currentDate,
    this.minDate,
    this.maxDate,
  });

  @override
  State<_MonthYearPickerDialog> createState() => _MonthYearPickerDialogState();
}

class _MonthYearPickerDialogState extends State<_MonthYearPickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;
  late ScrollController _yearScrollController;
  late ScrollController _monthScrollController;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.currentDate.year;
    _selectedMonth = widget.currentDate.month;

    // Initialize scroll controllers
    _yearScrollController = ScrollController();
    _monthScrollController = ScrollController();

    // Scroll to current selections after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedYear();
      _scrollToSelectedMonth();
    });
  }

  @override
  void dispose() {
    _yearScrollController.dispose();
    _monthScrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedYear() {
    final currentYear = DateTime.now().year;
    final yearIndex = _selectedYear - (currentYear - 50);
    if (yearIndex >= 0 && yearIndex < 101) {
      _yearScrollController.animateTo(
        yearIndex * 48.0, // Approximate item height
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToSelectedMonth() {
    _monthScrollController.animateTo(
      (_selectedMonth - 1) * 48.0, // Approximate item height
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _isMonthYearSelectable(int year, int month) {
    final testDate = DateTime(year, month, 1);

    if (widget.minDate != null) {
      final minMonthYear =
          DateTime(widget.minDate!.year, widget.minDate!.month, 1);
      if (testDate.isBefore(minMonthYear)) return false;
    }

    if (widget.maxDate != null) {
      final maxMonthYear =
          DateTime(widget.maxDate!.year, widget.maxDate!.month, 1);
      if (testDate.isAfter(maxMonthYear)) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currentYear = DateTime.now().year;

    // Generate year range (current year ± 50 years)
    final years = List.generate(101, (index) => currentYear - 50 + index);

    // Month names
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Sizer.radius(16)),
      ),
      child: Container(
        width: Sizer.width(300),
        height: Sizer.height(400),
        padding: EdgeInsets.all(Sizer.width(16)),
        child: Column(
          children: [
            // Title
            Text(
              'Select Month & Year',
              style: textTheme.text18?.medium,
            ),
            YBox(16),
            // Month and Year pickers
            Expanded(
              child: Row(
                children: [
                  // Month picker
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Month',
                          style: textTheme.text14?.medium.copyWith(
                            color: AppColors.gray500,
                          ),
                        ),
                        YBox(8),
                        Expanded(
                          child: ListView.builder(
                            controller: _monthScrollController,
                            itemCount: months.length,
                            itemBuilder: (context, index) {
                              final month = index + 1;
                              final isSelected = month == _selectedMonth;
                              final isSelectable =
                                  _isMonthYearSelectable(_selectedYear, month);

                              return GestureDetector(
                                onTap: isSelectable
                                    ? () {
                                        setState(() {
                                          _selectedMonth = month;
                                        });
                                      }
                                    : null,
                                child: Container(
                                  height: 48,
                                  margin: EdgeInsets.symmetric(
                                    vertical: Sizer.height(2),
                                    horizontal: Sizer.width(4),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.circular(Sizer.radius(8)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      months[index],
                                      style: textTheme.text14?.medium.copyWith(
                                        color: !isSelectable
                                            ? AppColors.gray500
                                                .withValues(alpha: 0.5)
                                            : isSelected
                                                ? Colors.white
                                                : AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  XBox(16),
                  // Year picker
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Year',
                          style: textTheme.text14?.medium.copyWith(
                            color: AppColors.gray500,
                          ),
                        ),
                        YBox(8),
                        Expanded(
                          child: ListView.builder(
                            controller: _yearScrollController,
                            itemCount: years.length,
                            itemBuilder: (context, index) {
                              final year = years[index];
                              final isSelected = year == _selectedYear;
                              final isSelectable =
                                  _isMonthYearSelectable(year, _selectedMonth);

                              return GestureDetector(
                                onTap: isSelectable
                                    ? () {
                                        setState(() {
                                          _selectedYear = year;
                                        });
                                      }
                                    : null,
                                child: Container(
                                  height: 48,
                                  margin: EdgeInsets.symmetric(
                                    vertical: Sizer.height(2),
                                    horizontal: Sizer.width(4),
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primaryBlue
                                        : Colors.transparent,
                                    borderRadius:
                                        BorderRadius.circular(Sizer.radius(8)),
                                  ),
                                  child: Center(
                                    child: Text(
                                      year.toString(),
                                      style: textTheme.text14?.medium.copyWith(
                                        color: !isSelectable
                                            ? AppColors.gray500
                                                .withValues(alpha: 0.5)
                                            : isSelected
                                                ? Colors.white
                                                : AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            YBox(16),
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: textTheme.text14?.medium.copyWith(
                      color: AppColors.red22,
                    ),
                  ),
                ),
                XBox(16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(DateTime(_selectedYear, _selectedMonth, 1));
                  },
                  child: Text(
                    'OK',
                    style: textTheme.text14?.medium.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekdayHeader extends StatelessWidget {
  final String text;

  const _WeekdayHeader(this.text);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: Sizer.width(20),
      height: Sizer.height(20),
      child: Center(
        child: Text(
          text,
          style: textTheme.text12?.medium,
        ),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  final int day;
  final bool isSelected;
  final bool isEndDate;
  final bool isInRange;
  final bool isToday;
  final bool isSelectable;
  final VoidCallback? onTap;

  const _CalendarDay({
    required this.day,
    required this.isSelected,
    this.isEndDate = false,
    this.isInRange = false,
    required this.isToday,
    this.isSelectable = true,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: isSelectable ? onTap : null,
      borderRadius: BorderRadius.circular(Sizer.radius(20)),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getBackgroundColor(),
          border: _getBorder(),
        ),
        child: Center(
          child: Text(
            day.toString(),
            style: textTheme.text14?.medium.copyWith(
              color: _getTextColor(),
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isSelected || isEndDate) {
      return AppColors.primaryBlue;
    } else if (isInRange) {
      return AppColors.primaryBlue.withValues(alpha: 0.2);
    } else if (isToday) {
      return AppColors.primaryBlue.withValues(alpha: 0.1);
    } else {
      return Colors.transparent;
    }
  }

  BoxBorder? _getBorder() {
    if ((isToday && !isSelected && !isEndDate && !isInRange) ||
        (isInRange && !isSelected && !isEndDate)) {
      return Border.all(color: AppColors.primaryBlue);
    }
    return null;
  }

  Color _getTextColor() {
    if (!isSelectable) {
      return AppColors.gray500.withValues(alpha: 0.5);
    } else if (isSelected || isEndDate) {
      return Colors.white;
    } else if (isInRange || isToday) {
      return AppColors.primaryBlue;
    } else {
      return AppColors.black;
    }
  }
}
