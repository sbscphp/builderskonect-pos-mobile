import 'package:flutter/material.dart';

enum DatePickerMode {
  single,
  range,
}

class CustomDatePickerDialog extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DatePickerMode mode;
  final String? title;
  final String? cancelText;
  final String? confirmText;
  final TextStyle? headerTextStyle;
  final Color? primaryColor;
  final Color? backgroundColor;

  const CustomDatePickerDialog({
    super.key,
    this.initialDate,
    this.initialStartDate,
    this.initialEndDate,
    this.minDate,
    this.maxDate,
    this.mode = DatePickerMode.single,
    this.title,
    this.cancelText = 'Cancel',
    this.confirmText = 'OK',
    this.headerTextStyle,
    this.primaryColor,
    this.backgroundColor,
  });

  @override
  State<CustomDatePickerDialog> createState() => _CustomDatePickerDialogState();

  // Static method to show single date picker
  static Future<DateTime?> showSingleDatePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? minDate,
    DateTime? maxDate,
    String? title,
    String? cancelText,
    String? confirmText,
    TextStyle? headerTextStyle,
    Color? primaryColor,
    Color? backgroundColor,
  }) async {
    final result = await showDialog<DateTime>(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        initialDate: initialDate,
        minDate: minDate,
        maxDate: maxDate,
        mode: DatePickerMode.single,
        title: title,
        cancelText: cancelText,
        confirmText: confirmText,
        headerTextStyle: headerTextStyle,
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
      ),
    );
    return result;
  }

  // Static method to show date range picker
  static Future<DateTimeRange?> showDateRangePicker({
    required BuildContext context,
    DateTime? initialStartDate,
    DateTime? initialEndDate,
    DateTime? minDate,
    DateTime? maxDate,
    String? title,
    String? cancelText,
    String? confirmText,
    TextStyle? headerTextStyle,
    Color? primaryColor,
    Color? backgroundColor,
  }) async {
    final result = await showDialog<DateTimeRange>(
      context: context,
      builder: (context) => CustomDatePickerDialog(
        initialStartDate: initialStartDate,
        initialEndDate: initialEndDate,
        minDate: minDate,
        maxDate: maxDate,
        mode: DatePickerMode.range,
        title: title,
        cancelText: cancelText,
        confirmText: confirmText,
        headerTextStyle: headerTextStyle,
        primaryColor: primaryColor,
        backgroundColor: backgroundColor,
      ),
    );
    return result;
  }
}

class _CustomDatePickerDialogState extends State<CustomDatePickerDialog> {
  late DateTime _currentMonth;
  DateTime? _selectedDate;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSelectingEndDate = false;

  @override
  void initState() {
    super.initState();

    if (widget.mode == DatePickerMode.single) {
      _selectedDate = widget.initialDate ?? DateTime.now();
      final selectedDate = _selectedDate ?? DateTime.now();
      _currentMonth = DateTime(selectedDate.year, selectedDate.month);
    } else {
      _startDate = widget.initialStartDate;
      _endDate = widget.initialEndDate;
      _currentMonth = DateTime(
        (_startDate ?? DateTime.now()).year,
        (_startDate ?? DateTime.now()).month,
      );
    }
  }

  void _onDateTap(DateTime date) {
    if (!_isDateSelectable(date)) return;

    setState(() {
      if (widget.mode == DatePickerMode.single) {
        _selectedDate = date;
      } else {
        if (_startDate == null || _isSelectingEndDate) {
          if (_isSelectingEndDate &&
              _startDate != null &&
              date.isBefore(_startDate!)) {
            _startDate = date;
            _endDate = null;
            _isSelectingEndDate = false;
          } else if (_isSelectingEndDate) {
            _endDate = date;
            _isSelectingEndDate = false;
          } else {
            _startDate = date;
            _endDate = null;
            _isSelectingEndDate = true;
          }
        } else {
          if (date.isBefore(_startDate!)) {
            _startDate = date;
            _endDate = null;
          } else {
            _endDate = date;
          }
          _isSelectingEndDate = false;
        }
      }
    });
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

  bool _isDateInRange(DateTime date) {
    if (widget.mode != DatePickerMode.range) return false;
    if (_startDate == null || _endDate == null) return false;
    return date.isAfter(_startDate!) && date.isBefore(_endDate!) ||
        date.isAtSameMomentAs(_startDate!) ||
        date.isAtSameMomentAs(_endDate!);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  String get _headerText {
    if (widget.mode == DatePickerMode.single && _selectedDate != null) {
      return _formatDate(_selectedDate!);
    } else if (widget.mode == DatePickerMode.range) {
      if (_startDate != null && _endDate != null) {
        return '${_formatDate(_startDate!)} - ${_formatDate(_endDate!)}';
      } else if (_startDate != null) {
        return _formatDate(_startDate!);
      } else {
        return 'Select date range';
      }
    }
    return 'Select date';
  }

  String _formatDate(DateTime date) {
    const months = [
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
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return '${weekdays[date.weekday % 7]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatMonthYear(DateTime date) {
    const months = [
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
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = widget.primaryColor ?? theme.primaryColor;
    final backgroundColor =
        widget.backgroundColor ?? theme.dialogBackgroundColor;

    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null)
                    Text(
                      widget.title ?? '',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    _headerText,
                    style: widget.headerTextStyle ??
                        (theme.textTheme.headlineSmall ?? const TextStyle())
                            .copyWith(
                          color:
                              theme.textTheme.bodyLarge?.color ?? Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),

            const Divider(),

            // Calendar
            _buildCalendar(theme, primaryColor),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    widget.cancelText ?? 'Cancel',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _canConfirm() ? _onConfirm : null,
                  child: Text(
                    widget.confirmText ?? 'OK',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme, Color primaryColor) {
    return Column(
      children: [
        // Month/Year header with navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _previousMonth,
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              _formatMonthYear(_currentMonth),
              style:
                  theme.textTheme.titleMedium ?? const TextStyle(fontSize: 16),
            ),
            IconButton(
              onPressed: _nextMonth,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Weekday headers
        Row(
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: (theme.textTheme.bodySmall ?? const TextStyle())
                            .copyWith(
                          color:
                              (theme.textTheme.bodySmall?.color ?? Colors.black)
                                  .withOpacity(0.6),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),

        const SizedBox(height: 8),

        // Calendar grid
        ..._buildCalendarWeeks(theme, primaryColor),
      ],
    );
  }

  List<Widget> _buildCalendarWeeks(ThemeData theme, Color primaryColor) {
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstDayWeekday = firstDayOfMonth.weekday % 7;

    final weeks = <Widget>[];
    var currentDate = firstDayOfMonth.subtract(Duration(days: firstDayWeekday));

    while (currentDate.isBefore(lastDayOfMonth.add(const Duration(days: 7)))) {
      final weekDays = <Widget>[];

      for (int i = 0; i < 7; i++) {
        final isCurrentMonth = currentDate.month == _currentMonth.month;
        final isSelectable = _isDateSelectable(currentDate);
        final isSelected = _isDateSelected(currentDate);
        final isInRange = _isDateInRange(currentDate);
        final isToday = _isToday(currentDate);

        weekDays.add(
          Expanded(
            child: GestureDetector(
              onTap: isCurrentMonth ? () => _onDateTap(currentDate) : null,
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor
                      : isInRange
                          ? primaryColor.withOpacity(0.2)
                          : Colors.transparent,
                  shape: BoxShape.circle,
                  border: isToday && !isSelected
                      ? Border.all(color: primaryColor, width: 1)
                      : null,
                ),
                child: Center(
                  child: Text(
                    '${currentDate.day}',
                    style: TextStyle(
                      color: !isCurrentMonth
                          ? (theme.textTheme.bodySmall?.color ?? Colors.black)
                              .withOpacity(0.3)
                          : !isSelectable
                              ? (theme.textTheme.bodySmall?.color ??
                                      Colors.black)
                                  .withOpacity(0.4)
                              : isSelected
                                  ? Colors.white
                                  : theme.textTheme.bodyLarge?.color ??
                                      Colors.black,
                      fontWeight: isSelected || isToday
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        currentDate = currentDate.add(const Duration(days: 1));
      }

      weeks.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(children: weekDays),
        ),
      );

      if (currentDate.isAfter(lastDayOfMonth)) break;
    }

    return weeks;
  }

  bool _isDateSelected(DateTime date) {
    if (widget.mode == DatePickerMode.single) {
      return _selectedDate != null && _isSameDay(date, _selectedDate!);
    } else {
      return (_startDate != null && _isSameDay(date, _startDate!)) ||
          (_endDate != null && _isSameDay(date, _endDate!));
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  bool _canConfirm() {
    if (widget.mode == DatePickerMode.single) {
      return _selectedDate != null;
    } else {
      return _startDate != null && _endDate != null;
    }
  }

  void _onConfirm() {
    if (widget.mode == DatePickerMode.single && _selectedDate != null) {
      Navigator.of(context).pop(_selectedDate);
    } else if (widget.mode == DatePickerMode.range &&
        _startDate != null &&
        _endDate != null) {
      Navigator.of(context)
          .pop(DateTimeRange(start: _startDate!, end: _endDate!));
    }
  }
}

// Example usage widget
class DatePickerExample extends StatefulWidget {
  const DatePickerExample({super.key});

  @override
  State<DatePickerExample> createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  DateTime? selectedDate;
  DateTimeRange? selectedRange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Date Picker Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Single date picker
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Single Date Picker',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedDate != null
                          ? 'Selected: ${selectedDate!.toLocal().toString().split(' ')[0]}'
                          : 'No date selected',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final date =
                            await CustomDatePickerDialog.showSingleDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          minDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          maxDate:
                              DateTime.now().add(const Duration(days: 365)),
                          title: 'Select date',
                        );
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      },
                      child: const Text('Select Date'),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Date range picker
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date Range Picker',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedRange != null
                          ? 'Range: ${selectedRange!.start.toLocal().toString().split(' ')[0]} - ${selectedRange!.end.toLocal().toString().split(' ')[0]}'
                          : 'No range selected',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final range =
                            await CustomDatePickerDialog.showDateRangePicker(
                          context: context,
                          initialStartDate: selectedRange?.start,
                          initialEndDate: selectedRange?.end,
                          minDate: DateTime.now()
                              .subtract(const Duration(days: 365)),
                          maxDate:
                              DateTime.now().add(const Duration(days: 365)),
                          title: 'Select date range',
                        );
                        if (range != null) {
                          setState(() {
                            selectedRange = range;
                          });
                        }
                      },
                      child: const Text('Select Date Range'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
