import 'package:intl/intl.dart';

/// String extension methods
///
///
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

  /// If the string is empty, return the newString.
  ///
  /// example
  /// ```dart
  /// String gender = user.gender.or(null);
  /// ```
  String or(String newString) => isEmpty ? newString : this;

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

  /// Check if string is a valid date
  bool get isValidDateTime => DateTime.tryParse(this) != null;

  /// Converts a string to a DateTime object.
  ///
  /// If the string is not in a valid date format and cannot be parsed,
  /// it returns the begining date time of unix time stamp which is 1970.
  ///
  /// 예) '2021-01-01' -> 2021-01-01 00:00:00.000
  ///
  ///
  DateTime get dateTime {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return DateTime(1970);
    }
  }

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

  /// Check if this string matches a regular expression (regex)
  ///
  ///
  bool hasMatch(String pattern) => RegExp(pattern).hasMatch(this);

  /// Checks if string consist only Alphabet. (No Whitespace)
  bool get isAlphabet => hasMatch(r'^[a-zA-Z]+$');

  /// Check if string is Alphanumeric
  bool get isAlphanumeric => hasMatch(r'^[a-zA-Z0-9]+$');

  /// Check if string is a boolean
  bool get isBool => this == 'true' || this == 'false';

  /// Check if string is an integer
  bool get isInt => int.tryParse(this) != null;

  /// Check if string is numeric
  bool get isNumeric => double.tryParse(this) != null;

  /// Return true if the string contains the url.
  bool get hasUrl =>
      contains('http://') || contains('https://') || contains('www.');

  /// Check if string is URL
  bool get isURL => hasMatch(r'^http(s)?://([\w-]+.)+[\w-]+(/[\w- ./?%&=])?$');
}

/// String Extension to check if a string is null or empty
///
/// Checks if a String? is null or not in the extends clause.
extension EasyHelperNullableStringExtension on String? {
  /// Returns true if the string is null or empty
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Alias of [isNullOrEmpty]
  bool get isEmpty => isNullOrEmpty;

  /// If the string is null or empty, then it will return the newString
  String or(String newString) => isNullOrEmpty ? newString : this!;
}
