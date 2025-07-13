enum StatDataFilterType {
  all,
  today,
  threeDays,
  sevenDays,
  fourteenDays,
  thisMonth,
  threeMonths,
  thisYear,
  customDate,
}

extension StatDataFilterTypeExtension on StatDataFilterType {
  String get label {
    switch (this) {
      case StatDataFilterType.all:
        return "All";
      case StatDataFilterType.today:
        return "Today";
      case StatDataFilterType.threeDays:
        return "3 days";
      case StatDataFilterType.sevenDays:
        return "7 days";
      case StatDataFilterType.fourteenDays:
        return "14 days";
      case StatDataFilterType.thisMonth:
        return "This month";
      case StatDataFilterType.threeMonths:
        return "3 months";
      case StatDataFilterType.thisYear:
        return "This year";
      case StatDataFilterType.customDate:
        return "Custom date";
    }
  }
}

// date_filter: Today, 3 days, 7 days, 14 days, this month, 3 months, this year
