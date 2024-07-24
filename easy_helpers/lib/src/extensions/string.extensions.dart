import 'package:intl/intl.dart';

/// String extension methods
extension EasyHelperStringExtension on String {
  /// Converts a string to an integer
  ///
  /// Returns 0 if the conversion fails.
  int tryInt() {
    return int.tryParse(this) ?? 0;
  }

  /// Converts a string to a double
  ///
  /// Returns 0.0 if the conversion fails.
  double? tryDouble() {
    return double.parse(this);
  }

  /// Returns true if the string is an email address
  bool get isEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  /// Return value if the current string is empty.
  ///
  /// example
  /// ```dart
  /// ''.ifEmpty('This is empty!') // result: 'This is empty!'
  /// String? uid; uid?.ifEmpty('UID is empty!') // result: null
  ///
  /// ```
  String ifEmpty(String value) => isEmpty ? value : this;

  /// If the string is empty, return the value.
  ///
  /// example
  /// ```dart
  /// String gender = user.gender.or(null);
  /// ```
  String or(String value) => isEmpty ? value : this;

  /// If the string is empty, return tnull
  dynamic get orNull => isEmpty ? null : this;

  String upTo(int len) => length <= len ? this : substring(0, len);

  /// Cut the string
  ///
  /// [suffix] is the string to be added at the end of the string. You may want
  /// to add '...' at the end of the string.
  ///
  /// ```dart
  /// Text( comment.content.cut(56, suffix: '...') );
  /// ```
  String cut(int length, {String suffix = ''}) {
    String temp = this;
    temp = temp.trim();
    temp = temp.replaceAll('\n', ' ');
    temp = temp.replaceAll('\r', ' ');
    temp = temp.replaceAll('\t', ' ');
    return temp.length > length ? '${temp.substring(0, length)}$suffix' : temp;
  }

  /// Replace all the string of the map.
  String replace(Map<String, String> map) {
    String s = this;
    map.forEach((key, value) {
      s = s.replaceAll(key, value);
    });
    return s;
  }

  /// Return true if the string contains the url.
  bool get hasUrl =>
      contains('http://') || contains('https://') || contains('www.');

  // /// 해당 문자열이 빈 문자열이면, 익명 프로필 사진 URL 을 반환한다.
  // String get orAnonymousUrl => isEmpty ? anonymousUrl : this;

  // /// 해당 문자열이 빈 문자열이면, 검은색 사진 URL 을 반환한다.
  // String get orBlackUrl => isEmpty ? blackUrl : this;

  // /// 해당 문자열이 빈 문자열이면, 흰색 사진 URL 을 반환한다.
  // String get orWhiteUrl => isEmpty ? whiteUrl : this;

  // /// 각종 특수 문자를 없앤다.
  // String get sanitize => trim().replaceAll(RegExp(r'[\r\n\t]'), " ");

  // /// 내가 [uid] 사용자를 차단했으면, [message] 를 리턴한다. 아니면, 현재 문자열을 리턴한다.
  // String orBlocked(String uid, String message) {
  //   if (notLoggedIn) return this;
  //   return iHave.blocked(uid) ? message : this;
  // }

  /// Converts a string to a DateTime object. If the string is not in a valid date format and cannot be parsed,
  /// it returns the current time instead of null.
  ///
  /// 예) '2021-01-01' -> 2021-01-01 00:00:00.000
  DateTime get dateTime {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return DateTime.now();
    }
  }

  int get year => dateTime.year;
  int get month => dateTime.month;
  int get day => dateTime.day;

  bool get isToday {
    final nowDate = DateTime.now();
    return year == nowDate.year && month == nowDate.month && day == nowDate.day;
  }

  /// Converts a string to a DateTime object and returns it in YYYY-MM-DD format.
  /// If the string is not in a valid date format and cannot be parsed, it returns the current date.
  ///
  ///
  String get yMd {
    return DateFormat.yMd().format(dateTime);
  }

  /// Converts a string to a DateTime object and returns it in YYYY-MM-DD HH:mm:ss format.
  ///
  /// See also: https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
  String get yMdjm {
    return DateFormat.yM().add_jm().format(dateTime);
  }

  /// Converts a string to a DateTime object and returns it in MM-DD format.
  ///
  /// See also: https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
  String get md {
    return DateFormat.Md().format(dateTime);
  }

  String get jm {
    return DateFormat.jm().format(dateTime);
  }

  /// Returns in the format of 'jms' (e.g. 5:08:37 PM)
  ///
  /// See also: https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
  String get jms {
    return DateFormat.jms().format(dateTime);
  }

  /// Returns date if the date is today, otherwise returns time
  ///
  String get shortDateTime {
    return isToday ? jm : md;
  }

  /// Alias of [shortDateTime]
  String get short => shortDateTime;

  /// Returns string with capitalized first letter
  ///
  /// Example:
  /// ```dart
  /// assert('test'.capitalizeFirstLetter(), 'Test');
  /// ```
  ///
  /// From: https://github.com/ScerIO/packages.dart/tree/master/packages
  String capitalizeFirstLetter() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;

  /// Alias of [capitalizeFirstLetter]
  String get ucFirst => capitalizeFirstLetter();
}

/// String Extension to check if a string is null or empty
///
/// Checks if a String? is null or not in the extends clause.
extension EasyHelperNullableStringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
