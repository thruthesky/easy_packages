# Easy Helpers


Helper classes, functions, and extensions for FireFlutter


# DateTime Extension Methods

## Usage

Once imported, you can use these extension methods on any `DateTime` object:

```dart
void main() {
  final now = DateTime.now();
  print(now.toShort);  // Outputs date in short format
  print(now.isToday);  // true

  final yesterday = now.subtract(Duration(days: 1));
  print(yesterday.isYesterday);  // true
}
```

## Available Methods

### Formatting Methods

- `toShort`: Returns a string in "yyyy-MM-dd" format for dates not today, or "HH:mm:ss" for today's date.
- `yMd`: Returns the date in a localized month/day/year format.
- `jm`: Returns the time in a localized hour/minute format.

### Date Comparison Methods

- `isToday`: Returns true if the date is today.
- `isYesterday`: Returns true if the date was yesterday.
- `isSameDate(DateTime other)`: Returns true if the date is the same as the other date.
- `isSameMonth(DateTime other)`: Returns true if the date is in the same month as the other date.
- `isSameYear(DateTime other)`: Returns true if the date is in the same year as the other date.

### Detailed Method Descriptions

#### `toShort`

Returns a formatted string representation of the date:
- If the date is today, it returns the time in "HH:mm:ss" format.
- Otherwise, it returns the date in "yy.MM.dd" format.

```dart
final now = DateTime.now();
print(now.toShort);  // Outputs something like "14:30:00" if it's today
```

#### `yMd`

Returns the date in a localized month/day/year format.

```dart
final date = DateTime(2023, 5, 15);
print(date.yMd);  // Outputs "5/15/2023" in US locale
```

#### `jm`

Returns the time in a localized hour/minute format.

```dart
final time = DateTime(2023, 5, 15, 14, 30);
print(time.jm);  // Outputs "2:30 PM" in US locale
```

#### `isToday`, `isYesterday`, `isSameDate`, `isSameMonth`, `isSameYear`

These methods provide easy ways to compare dates:

```dart
final now = DateTime.now();
final yesterday = now.subtract(Duration(days: 1));

print(now.isToday);  // true
print(yesterday.isYesterday);  // true
print(now.isSameDate(now));  // true
print(now.isSameMonth(yesterday));  // true (assuming it's not the first day of the month)
print(now.isSameYear(DateTime(now.year, 1, 1)));  // true
```



# String Extension Methods

This package provides a set of useful extension methods on the `String` class to enhance development productivity in Dart and Flutter projects.

## Usage

Once imported, you can use these extension methods on any `String` object:

```dart
void main() {
  String email = 'user@example.com';
  print(email.isEmail);  // true

  String number = '42';
  print(number.tryInt());  // 42

  String longText = 'This is a very long text that needs to be cut';
  print(longText.cut(20, suffix: '...'));  // "This is a very long..."
}
```

## Available Methods

### Conversion Methods

- `tryInt()`: Converts a string to an integer. Returns 0 if conversion fails.
- `tryDouble()`: Converts a string to a double. Returns 0.0 if conversion fails.

### Validation Methods

- `isEmail`: Returns true if the string is a valid email address.

### String Manipulation Methods

- `ifEmpty(String value)`: Returns the given value if the string is empty.
- `or(String value)`: Returns the given value if the string is empty.
- `orNull`: Returns null if the string is empty.
- `upTo(int len)`: Cuts the string to the specified length.
- `cut(int length, {String suffix = ''})`: Cuts the string and adds a suffix.
- `replace(Map<String, String> map)`: Replaces all occurrences of keys with their corresponding values.

### URL Related Method

- `hasUrl`: Returns true if the string contains a URL.

### Date and Time Methods

- `dateTime`: Converts the string to a DateTime object.
- `year`: Returns the year of the date string.
- `month`: Returns the month of the date string.
- `day`: Returns the day of the date string.
- `isToday`: Returns true if the date string represents today's date.
- `yMd`: Returns the date in YYYY-MM-DD format.
- `yMdjm`: Returns the date and time in YYYY-MM-DD HH:mm:ss format.
- `md`: Returns the date in MM-DD format.
- `jm`: Returns the time in HH:mm format.
- `jms`: Returns the time in HH:mm:ss format.
- `shortDateTime`: Returns date if it's not today, otherwise returns time.
- `short`: Alias for `shortDateTime`.

### Text Formatting Method

- `capitalizeFirstLetter()`: Capitalizes the first letter of the string.
- `ucFirst`: Alias for `capitalizeFirstLetter()`.

## Nullable String Extension

An additional extension is provided for nullable strings:

- `isNullOrEmpty`: Returns true if the string is null or empty.

Usage:

```dart
String? nullableString;
print(nullableString.isNullOrEmpty);  // true

nullableString = '';
print(nullableString.isNullOrEmpty);  // true

nullableString = 'Not empty';
print(nullableString.isNullOrEmpty);  // false
```
