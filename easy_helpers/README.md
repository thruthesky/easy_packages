# Easy Helpers

* `easy_helpers` is a library tool that helps developers to quickly start their app.
* It provides many helpful functions, extensions, classes that you will love to use in your daily flutter coding.




# DateTime Extensions

This package provides some DateTime related handy extension method.

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
- `yMd`: Returns the date in a localized month/day/year format. It is merely a short for `DateTime.yMd().format(this)`.
- `jm`: Returns the time in a localized hour/minute format. It is merely a short for `DateTime.jm().format(this)`.

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
- `isAlphabet`: Checks if string consist only Alphabet. (No Whitespace)
- `isAlphanumeric`: Check if string is Alphanumeric
- `isBool`: Check if string is a boolean
- `isInt`: Check if string is an integer
- `isNumeric`: Check if string is numeric
- `hasUrl`: Return true if the string contains the url.
- `isURL`: Check if string is URL

### String Manipulation Methods

- `isEmpty`: Returns true if the String is null or empty.
Example:
```dart
String? test;
expect(test.isEmpty, equals(true));
expect('test'.isEmpty, equals(false));
```
- `or(String value)`: Returns the given value if the string is empty.
Example:
```dart
String? test;
expect(test.or('default'), equals('default'));
expect(''.or('default'), equals('default'));
expect('test'.or('default'), equals('test'));
```


- `cut(int length, {String suffix = ''})`: Remove `\r\n\t` and cuts the string into the length. Optionally adds a suffix.

- `replace(Map<String, String> map)`: Replaces all occurrences of keys with their corresponding values.

### URL Related Method

- `hasUrl`: Returns true if the string contains a URL.

### Date and Time Methods

- `isValidDateTime`: Returns true if the string can be parsed as DateTime. Or if the string is in date time format.
- `dateTime`: Converts the string to a DateTime object.

### Text Formatting Method

- `capitalizeFirstLetter()`: Capitalizes the first letter of the string.
- `ucFirst`: Alias for `capitalizeFirstLetter()`.

## Nullable String Extension

An additional extension is provided for nullable strings:

- `isEmpty`: Returns true if the string is null or empty.
- `or(newString)`: Returns the newString if the string is null or empty.


## Regular Expression


### hasMatch

Check if this string matches a regular expression (regex)

```dart
void main() {
  // Define a string containing "hello" and "world"
  const input = 'hello world';
  
  // Check if the string contains the word "world"
  final hasWorld = input.hasMatch('world');
  print(hasWorld); // prints: true
  
  // Check if the string contains the word "universe"
  final hasUniverse = input.hasMatch('universe');
  print(hasUniverse); // prints: false
}
```


# Dart Extensions for Iterable and List

This package offers several extension methods for `Iterable` to help speed up Flutter app development.


## `Iterable<List<T>> chunks(int chunkSize)`

This method splits a large iterable into smaller sublists of a specified size.

### Example:
```dart
import 'your_extension_file.dart';

void main() {
  var list = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  var chunked = list.chunks(2);
  print(chunked); // => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
}
```

## `List<List<T>> chunks(int chunkSize)`

This method splits a large list into smaller sublists of a specified size.

### Example:
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

## Alert

Provides functions to display alert dialogs.

### Example:
```dart
alert(
    context,
    title: Text('Alert'),
    content: Text('This is an alert dialog'),
    onOkPressed: () {
        print('OK pressed');
    },
);
```

## Confirm

Provides functions to display confirmation dialogs.

 Example:
```dart
final re = await confirm(
  context: context,
  title: Text('Delete'.t),
  message: Text('Are you sure you wanted to delete this post?'.t),
);
if (re == false) return;
```

You can optionally give a subtitle widget. It's a widget, not a text string.

Example:
```dart
confirm(
  context: context,
  title: Text('title'),
  subtitle: const CircleAvatar(
    child: Text('yo'),
  ),
  message: Text('message'),
);
```



## Error

Provides functions to display error dialogs.

### Example:
```dart
error(context: context, title: 'title', message: 'message');
```

## Input

Provides functions to display input dialogs.

### Example:
```dart

```


## platform

Provides functions to handle platform-specific code.


Here are some examples of how you can use the code:

Example 1: Printing the platform name
```dart
print(platformName()); // prints "web" if running on web, otherwise prints "android" or "ios"
```

Example 2: Using platform-specific logic
```dart
void main() {
  if (platformName() == 'ios') {
    print('This is an iOS device');
  } else if (platformName() == 'android') {
    print('This is an Android device');
  }
}
```

Example 3: Checking for specific platforms
```dart
void main() {
  if (isIos) {
    print('This is an iOS device');
  }

  if (isAndroid) {
    print('This is an Android device');
  }
}
```



## Toast

Provides functions to display toast messages.

```dart
final re = await my?.block(chat.room.otherUserUid!);
toast(
  context: context,
  title: Text(re == true ? 'Blocked' : 'Unblocked'),
  message: Text(re == true ? 'You have blocked this user' : 'You have unblocked this user'),
);
```



# String Funcntion


## sanitizeFilename

A utility function to sanitize filenames by replacing illegal characters and reserved names.

This function takes an input string and replaces characters that are not safe for use in filenames. It also removes reserved names on Unix-based systems and Windows.

```dart
const unsafeUserInput = "~/.\u0000ssh/authorized_keys";

// "~.sshauthorized_keys"
sanitizeFilename(unsafeUserInput);

// "~-.-ssh-authorized_keys"
sanitizeFilename(unsafeUserInput, replacement: "-");
```

Parameters:

`input`: The input string to be sanitized.

`replacement`: An optional parameter that specifies the character or string to replace illegal characters with. Defaults to an empty string.

# Platform

To detect in which platform the app is running:

```dart
final isMacOS = context.platform.isMacOS
```

All the parameters available are:

- isAndroid
- isWeb
- isMacOS
- isWindows
- isFuchsia
- isIOS
- isLinux

To detect the target platform (e.g. the app is running on Web but from an iOS device):

```dart
final isIOS = context.targetPlatform.isIOS;
```

- isAndroid
- isFuchsia
- isIOS
- isLinux
- isMacOS
- isWindows



# Log

- `dog`: Prints debug log message.
```dart
dog('this is a log message with dog emoji 🐶');
```

- `.dog()`: Prints debug log message on any Object
```dart
({'a': 'apple', 'b': 'banana'} as Map).dog();
```
