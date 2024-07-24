import 'package:intl/intl.dart';

/// DateTime extension
///
///
extension EasyExtensionDateTimeExtension on DateTime {
  /// Returns a string of "yyyy-MM-dd"
  String get short {
    final dt = this;

    /// Returns a string of "yyyy-MM-dd" or "HH:mm:ss"
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return DateFormat.jm().format(dt);
    } else {
      return DateFormat('yy.MM.dd').format(dt);
    }
  }

  /// Returns a string of "yyyy-MM-dd"
  String get yMd {
    return DateFormat.yMd().format(this);
  }

  /// Returns a string of "yyyy-MM-dd HH:mm:ss"
  String get jm {
    return DateFormat.jm().format(this);
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

  /// Returns a string of "yy-MM-dd"
  bool isSameYear(DateTime other) {
    return year == other.year;
  }
}
