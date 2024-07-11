import 'package:intl/intl.dart';

extension FireshipDateTimeExtension on DateTime {
  String get toShort {
    final dt = this;

    /// Returns a string of "yyyy-MM-dd" or "HH:mm:ss"

    final now = DateTime.now();
    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return DateFormat.jm().format(dt);
    } else {
      return DateFormat('yy.MM.dd').format(dt);
    }
  }

  String get toYmd {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String get toHis {
    return DateFormat('HH:mm:ss').format(this);
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
    return nowDate.subtract(oneDay).isSameDate(this);
  }

  /// Returns a string of "yy-MM-dd"
  ///
  /// from: https://github.com/jayeshpansheriya/awesome_extensions/blob/main/lib/date_extensions/date_extension.dart
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Returns a string of "yy-MM-dd"
  ///
  /// from: https://github.com/jayeshpansheriya/awesome_extensions/blob/main/lib/date_extensions/date_extension.dart
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool isSameYear(DateTime other) {
    return year == other.year;
  }
}
