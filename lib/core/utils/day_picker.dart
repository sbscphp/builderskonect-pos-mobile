import '../core.dart';

class DayPicker extends StatefulWidget {
  /// The days to display in the picker
  final List<DateTime> availableDays;

  /// Callback when a day is selected
  final Function(DateTime) onDaySelected;

  /// Selected day
  final DateTime? selectedDay;

  /// Primary color for the selected date
  final Color selectedColor;

  /// Text color for the selected date
  final Color selectedTextColor;

  /// Background color for unselected dates
  final Color unselectedColor;

  /// Text color for unselected dates
  final Color unselectedTextColor;

  const DayPicker({
    super.key,
    required this.availableDays,
    required this.onDaySelected,
    this.selectedDay,
    this.selectedColor = Colors.black,
    this.selectedTextColor = Colors.white,
    this.unselectedColor = Colors.white,
    this.unselectedTextColor = Colors.black,
  });

  @override
  State<DayPicker> createState() => _DayPickerState();
}

class _DayPickerState extends State<DayPicker> {
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.selectedDay;
  }

  @override
  void didUpdateWidget(DayPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedDay != oldWidget.selectedDay) {
      _selectedDay = widget.selectedDay;
    }
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);

    if (checkDate.isAtSameMomentAs(today)) {
      return 'TODAY';
    }

    switch (date.weekday) {
      case 1:
        return 'MON';
      case 2:
        return 'TUE';
      case 3:
        return 'WED';
      case 4:
        return 'THU';
      case 5:
        return 'FRI';
      case 6:
        return 'SAT';
      case 7:
        return 'SUN';
      default:
        return '';
    }
  }

  // bool _isToday(DateTime date) {
  //   final now = DateTime.now();
  //   return date.year == now.year &&
  //       date.month == now.month &&
  //       date.day == now.day;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Sizer.width(80),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.availableDays.length,
            itemBuilder: (context, index) {
              final day = widget.availableDays[index];
              final isSelected = _selectedDay != null &&
                  _selectedDay!.year == day.year &&
                  _selectedDay!.month == day.month &&
                  _selectedDay!.day == day.day;

              return Padding(
                padding: EdgeInsets.only(
                  left: Sizer.width(16),
                  right: index == widget.availableDays.length - 1
                      ? Sizer.width(16)
                      : 0,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedDay = day;
                    });
                    widget.onDaySelected(day);
                  },
                  child: Container(
                    width: Sizer.width(60),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? widget.selectedColor
                          : widget.unselectedColor,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day.day.toString(),
                          style: TextStyle(
                            fontSize: Sizer.text(16),
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? widget.selectedTextColor
                                : widget.unselectedTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getDayName(day),
                          style: TextStyle(
                            fontSize: Sizer.text(12),
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? widget.selectedTextColor
                                : widget.unselectedTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Example usage:
class DayPickerExample extends StatefulWidget {
  const DayPickerExample({super.key});

  @override
  State<DayPickerExample> createState() => _DayPickerExampleState();
}

class _DayPickerExampleState extends State<DayPickerExample> {
  DateTime? _selectedDay;
  late List<DateTime> _availableDays;

  @override
  void initState() {
    super.initState();
    // Generate 7 days from today
    final now = DateTime.now();
    _availableDays = List.generate(
      7,
      (index) => DateTime(now.year, now.month, now.day + index),
    );
    // Set today as selected by default
    _selectedDay = _availableDays.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Picker Example'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DayPicker(
            availableDays: _availableDays,
            selectedDay: _selectedDay,
            onDaySelected: (date) {
              setState(() {
                _selectedDay = date;
              });
              // Show selected day
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Selected date: ${date.day}/${date.month}/${date.year}'),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Selected date: ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }
}
