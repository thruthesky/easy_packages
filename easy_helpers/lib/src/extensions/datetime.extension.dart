import 'package:intl/intl.dart';

/// DateTime extension
///
///
extension EasyExtensionDateTimeExtension on DateTime {
  /// Returns a string of "yyyy-MM-dd"
  String get short => shortDateTime;

  /// Returns date if the date is today, otherwise returns time
  ///
  String get shortDateTime {
    return isToday ? jm : md;
  }

  /// Returns a string of "yyyy-MM-dd"
  String get yMd {
    return DateFormat.yMd().format(this);
  }

  /// Converts a string to a DateTime object and returns it in YYYY-MM-DD HH:mm:ss format.
  ///
  /// See also: https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
  String get yMdjm {
    return DateFormat.yM().add_jm().format(this);
  }

  /// Converts a string to a DateTime object and returns it in MM-DD format.
  ///
  /// See also: https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
  String get md {
    return DateFormat.Md().format(this);
  }

  /// Returns a string of "yyyy-MM-dd HH:mm:ss"
  String get jm {
    return DateFormat.jm().format(this);
  }

  /// Returns in the format of 'jms' (e.g. 5:08:37 PM)
  ///
  /// See also: https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
  String get jms {
    return DateFormat.jms().format(this);
  }

  /// Returns a string of "yy-MM-dd"
  ///
  /// from: https://github.com/jayeshpansheriya/awesome_extensions/blob/main/lib/date_extensions/date_extension.dart
  bool get isToday {
    final nowDate = DateTime.now();
    return year == nowDate.year && month == nowDate.month && day == nowDate.day;
  }

  /// Returns a string of "yy-MM-dd"
  ///
  /// from: https://github.com/jayeshpansheriya/awesome_extensions/blob/main/lib/date_extensions/date_extension.dart
  bool get isYesterday {
    final nowDate = DateTime.now();
    const oneDay = Duration(days: 1);
    return nowDate.subtract(oneDay).isSameDay(this);
  }

  /// Returns true if the date is tomorrow
  bool get isTomorrow {
    final nowDate = DateTime.now();
    return year == nowDate.year &&
        month == nowDate.month &&
        day == nowDate.day + 1;
  }

  /// Returns true if the date is past.
  ///
  /// It returns true even if it is today but the time is past.
  ///
  /// It is a simple alias of `isBefore(DateTime.now())`.
  bool get isPast {
    final nowDate = DateTime.now();
    return isBefore(nowDate);
  }

  /// Returns true if the date is future.
  ///
  /// It returns true even if it is today but the time is future.
  ///
  /// It is a simple alias of `isAfter(DateTime.now())`.
  ///
  /// See also: https://api.flutter.dev/flutter/dart-core/DateTime/isBefore.html
  /// See also: https://api.flutter.dev/flutter/dart-core/DateTime/compareTo.html
  bool get isFuture {
    final nowDate = DateTime.now();
    return isAfter(nowDate);
  }

  /// Returns a string of "yy-MM-dd"
  ///
  /// from: https://github.com/jayeshpansheriya/awesome_extensions/blob/main/lib/date_extensions/date_extension.dart
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Returns a string of "yy-MM-dd"
  ///
  /// from: https://github.com/jayeshpansheriya/awesome_extensions/blob/main/lib/date_extensions/date_extension.dart
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Returns a string of "yy-MM-dd"
  bool isSameYear(DateTime other) {
    return year == other.year;
  }

  /// The day after this [DateTime]
  DateTime get nextDay => add(const Duration(days: 1));

  /// The day previous this [DateTime]
  DateTime get previousDay => subtract(const Duration(days: 1));

  DateTime get firstDayOfMonth => DateTime(year, month);

  /// The last day of a given month
  DateTime get lastDayOfMonth {
    var beginningNextMonth =
        (month < 12) ? DateTime(year, month + 1, 1) : DateTime(year + 1, 1, 1);
    return beginningNextMonth.subtract(const Duration(days: 1));
  }

  /// Returns true if the date is the first day of the month
  bool get isFirstDayOfMonth => isSameDay(firstDayOfMonth);

  /// Returns true if the date is the last day of the month
  bool get isLastDayOfMonth => isSameDay(lastDayOfMonth);

  /// Returns the previous month of the current date
  ///
  ///
  DateTime get previousMonth {
    var year = this.year;
    var month = this.month;
    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }
    return DateTime(year, month);
  }

  /// Returns the next month of the current date
  DateTime get nextMonth {
    var year = this.year;
    var month = this.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }
    return DateTime(year, month);
  }

  /// Returns the DateTime of the previous week  from current date
  DateTime get previousWeek => subtract(const Duration(days: 7));

  /// Returns the DateTime of the next week from current date
  DateTime get nextWeek => add(const Duration(days: 7));

  /// Returns true if the given date [other] is in the same week as this date.
  /// Weeks are considered to start on Sunday and end on Saturday.
  bool isSameWeek(DateTime other) {
    // Step 1: Normalize both dates to the start of their respective days (midnight UTC)
    final thisDate = DateTime.utc(year, month, day);
    final otherDate = DateTime.utc(other.year, other.month, other.day);

    // Step 2: Find the most recent Sunday for both dates
    // Note: weekday is 7 for Sunday, so we use (weekday % 7) to treat Sunday as 0
    final thisSunday = thisDate.subtract(Duration(days: thisDate.weekday % 7));
    final otherSunday =
        otherDate.subtract(Duration(days: otherDate.weekday % 7));

    // Step 3: Compare the two Sundays
    return thisSunday == otherSunday;
  }
}
