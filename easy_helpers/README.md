# Easy Helpers


* Helper classes, functions, and extensions for FireFlutter

# TODO

Collect all the extensions from the open source code and make it available from this package;

- https://pub.dev/packages/awesome_extensions
- https://pub.dev/packages/awesome_flutter_extensions



# DateTime Extensions


## Usage

Once imported, you can use these extension methods on any `DateTime` object:

```dart
final now = DateTime.now();
print(now.short);  // Outputs date in short format
print(now.isToday);  // true
print(now.isSameWeek(now.add(Duration(days: 2))));  // Checks if two dates are in the same week
```

## Available Methods

### Formatting Methods
- `short`: Returns a string in "HH:mm" format for today's date, or "yy.MM.dd" for other dates.
- `yMd`: Returns the date in a localized month/day/year format.
- `jm`: Returns the time in a localized hour/minute format.

### Date Comparison Methods
- `isToday`: Returns true if the date is today.
- `isYesterday`: Returns true if the date was yesterday.
- `isTomorrow`: Returns true if the date is tomorrow.
- `isPast`: Returns true if the date is in the past.
- `isFuture`: Returns true if the date is in the future.
- `isSameDay(DateTime other)`: Returns true if the date is the same as the other date.
- `isSameMonth(DateTime other)`: Returns true if the date is in the same month as the other date.
- `isSameYear(DateTime other)`: Returns true if the date is in the same year as the other date.
- `isSameWeek(DateTime other)`: Returns true if the date is in the same week as the other date (weeks start on Sunday).

### Date Navigation Methods
- `nextDay`: Returns the day after this DateTime.
- `previousDay`: Returns the day before this DateTime.
- `firstDayOfMonth`: Returns the first day of the month for this DateTime.
- `lastDayOfMonth`: Returns the last day of the month for this DateTime.
- `previousMonth`: Returns the previous month of the current date.
- `nextMonth`: Returns the next month of the current date.
- `previousWeek`: Returns the DateTime of the previous week from the current date.
- `nextWeek`: Returns the DateTime of the next week from the current date.

### Boolean Checks
- `isFirstDayOfMonth`: Returns true if the date is the first day of the month.
- `isLastDayOfMonth`: Returns true if the date is the last day of the month.

## Detailed Examples

### Formatting Methods

```dart
void main() {
  final now = DateTime.now();
  final futureDate = DateTime(2024, 7, 24);

  print('Short format (today): ${now.short}');
  print('Short format (future date): ${futureDate.short}');
  print('yMd format: ${now.yMd}');
  print('jm format: ${now.jm}');
}

// Output (assuming current date is 2023-07-24):
// Short format (today): 14:30
// Short format (future date): 24.07.24
// yMd format: 7/24/2023
// jm format: 2:30 PM
```

### Date Comparison Methods

```dart
void main() {
  final now = DateTime.now();
  final yesterday = now.subtract(Duration(days: 1));
  final tomorrow = now.add(Duration(days: 1));
  final lastWeek = now.subtract(Duration(days: 7));
  final nextWeek = now.add(Duration(days: 7));

  print('Is today: ${now.isToday}');
  print('Is yesterday: ${yesterday.isYesterday}');
  print('Is tomorrow: ${tomorrow.isTomorrow}');
  print('Is in the past: ${yesterday.isPast}');
  print('Is in the future: ${tomorrow.isFuture}');
  print('Is same day: ${now.isSameDay(now)}');
  print('Is same month: ${now.isSameMonth(lastWeek)}');
  print('Is same year: ${now.isSameYear(nextWeek)}');
  print('Is same week: ${now.isSameWeek(tomorrow)}');
  print('Is same week (next week): ${now.isSameWeek(nextWeek)}');
}

// Output:
// Is today: true
// Is yesterday: true
// Is tomorrow: true
// Is in the past: true
// Is in the future: true
// Is same day: true
// Is same month: true
// Is same year: true
// Is same week: true
// Is same week (next week): false
```

### Date Navigation Methods

```dart
void main() {
  final now = DateTime(2023, 7, 24);  // A Monday

  print('Next day: ${now.nextDay}');
  print('Previous day: ${now.previousDay}');
  print('First day of month: ${now.firstDayOfMonth}');
  print('Last day of month: ${now.lastDayOfMonth}');
  print('Previous month: ${now.previousMonth}');
  print('Next month: ${now.nextMonth}');
  print('Previous week: ${now.previousWeek}');
  print('Next week: ${now.nextWeek}');
}

// Output:
// Next day: 2023-07-25 00:00:00.000
// Previous day: 2023-07-23 00:00:00.000
// First day of month: 2023-07-01 00:00:00.000
// Last day of month: 2023-07-31 00:00:00.000
// Previous month: 2023-06-01 00:00:00.000
// Next month: 2023-08-01 00:00:00.000
// Previous week: 2023-07-17 00:00:00.000
// Next week: 2023-07-31 00:00:00.000
```

### Boolean Checks

```dart
void main() {
  final firstDay = DateTime(2023, 7, 1);
  final lastDay = DateTime(2023, 7, 31);
  final middleDay = DateTime(2023, 7, 15);

  print('Is first day of month: ${firstDay.isFirstDayOfMonth}');
  print('Is last day of month: ${lastDay.isLastDayOfMonth}');
  print('Middle day - Is first day of month: ${middleDay.isFirstDayOfMonth}');
  print('Middle day - Is last day of month: ${middleDay.isLastDayOfMonth}');
}

// Output:
// Is first day of month: true
// Is last day of month: true
// Middle day - Is first day of month: false
// Middle day - Is last day of month: false
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




# Dart Extensions for Iterable and List

This README provides documentation and examples for the custom Dart extensions on `Iterable` and `List`. These extensions include methods for splitting collections into chunks.

## Extensions

### `IterableExtension<T>`

#### `Iterable<List<T>> chunks(int chunkSize)`

This method splits a large iterable into smaller sublists of a specified size.

#### Example:
```dart
import 'your_extension_file.dart';

void main() {
  var list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  var chunked = list.chunks(2);
  print(chunked); // => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
}
```

### `ListExtension<T>`

#### `List<List<T>> chunks(int chunkSize)`

This method splits a large list into smaller sublists of a specified size.

#### Example:
```dart
import 'your_extension_file.dart';

void main() {
  var list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  var chunked = list.chunks(2);
  print(chunked); // => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
}
```

## Unit Tests

The following unit tests ensure the correctness of the `chunks` method for both `Iterable` and `List` extensions.

### Test Cases

#### Test `chunks` with a list of 9 elements and chunk size of 2:
```dart
import 'package:test/test.dart';
import 'your_extension_file.dart';

void main() {
  group('Iterable extension tests', () {
    test('chunks 9 / 2', () {
      expect([1, 2, 3, 4, 5, 6, 7, 8, 9].chunks(2), [
        [1, 2],
        [3, 4],
        [5, 6],
        [7, 8],
        [9]
      ]);
    });
  });
}
```

#### Test `chunks` with a list of 10 elements and chunk size of 3:
```dart
import 'package:test/test.dart';
import 'your_extension_file.dart';

void main() {
  group('Iterable extension tests', () {
    test('chunks 10 / 3', () {
      expect([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].chunks(3), [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
        [10]
      ]);
    });
  });
}
```

#### Test `chunks` with a list of 100 elements and chunk size of 41:
```dart
import 'package:test/test.dart';
import 'your_extension_file.dart';

void main() {
  group('Iterable extension tests', () {
    test('chunk 100 / 41', () {
      final list = List.generate(100, (index) => index);
      final chunked = list.chunks(41);
      expect(chunked.length, 3);
      expect(chunked[0].length, 41);
      expect(chunked[1].length, 41);
      expect(chunked[2].length, 18);
    });
  });
}
```

## Usage

To use these extensions, include the extension file in your Dart project and import it where needed. The methods can then be called on any `Iterable` or `List` instance.

```dart
import 'your_extension_file.dart';

void main() {
  var list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  var chunked = list.chunks(2);
  print(chunked); // => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
}
```

These extensions provide a convenient way to handle large collections by breaking them into smaller, more manageable pieces.





# Flutter Functions

This package contains a collection of utility functions for Flutter development. These functions provide helpful utilities for displaying dialogs, logging, handling strings, and more.

## Files

1. [Alert](#alert)
2. [confirm_dialog.function.dart](#confirm_dialogfunctiondart)
3. [error_dialog.function.dart](#error_dialogfunctiondart)
4. [input_dialog.function.dart](#input_dialogfunctiondart)
5. [log.functions.dart](#logfunctionsdart)
6. [platform.functions.dart](#platformfunctionsdart)
7. [string.functions.dart](#stringfunctionsdart)
8. [toast.function.dart](#toastfunctiondart)

## Functions

### Alert

Provides functions to display alert dialogs.

#### Example:
```dart
alert(
    context,
    title: 'Alert',
    content: 'This is an alert dialog',
    onOkPressed: () {
        print('OK pressed');
    },
);
```

### confirm_dialog.function.dart

Provides functions to display confirmation dialogs.

#### Example:
```dart
import 'confirm_dialog.function.dart';

void showConfirm(BuildContext context) {
  showConfirmDialog(
    context,
    title: 'Confirm',
    content: 'Are you sure?',
    onConfirmed: () {
      print('Confirmed');
    },
  );
}
```

### error_dialog.function.dart

Provides functions to display error dialogs.

#### Example:
```dart
import 'error_dialog.function.dart';

void showError(BuildContext context) {
  showErrorDialog(
    context,
    title: 'Error',
    content: 'An error has occurred',
  );
}
```

### input_dialog.function.dart

Provides functions to display input dialogs.

#### Example:
```dart
import 'input_dialog.function.dart';

void showInput(BuildContext context) {
  showInputDialog(
    context,
    title: 'Input',
    labelText: 'Enter something',
    onSubmitted: (value) {
      print('Input: $value');
    },
  );
}
```

### log.functions.dart

Provides logging functions.

#### Example:
```dart
import 'log.functions.dart';

void logExample() {
  logInfo('This is an info message');
  logWarning('This is a warning message');
  logError('This is an error message');
}
```

### platform.functions.dart

Provides functions to handle platform-specific code.

#### Example:
```dart
import 'platform.functions.dart';

void checkPlatform() {
  if (isAndroid) {
    print('Running on Android');
  } else if (isIOS) {
    print('Running on iOS');
  }
}
```

### string.functions.dart

Provides string utility functions.

#### Example:
```dart
import 'string.functions.dart';

void stringExample() {
  String text = 'hello world';
  print(text.capitalize()); // Output: Hello world
}
```

### toast.function.dart

Provides functions to display toast messages.

#### Example:
```dart
import 'toast.function.dart';

void showToast(BuildContext context) {
  showToastMessage(context, 'This is a toast message');
}
```

## Usage

To use these functions, include the respective Dart files in your Flutter project and import them where needed. You can then call the functions as demonstrated in the examples above.

```dart
import 'package:your_project/functions/Alert';
import 'package:your_project/functions/confirm_dialog.function.dart';
// Import other functions as needed
```

These utility functions can help streamline your Flutter development by providing ready-to-use solutions for common tasks.
