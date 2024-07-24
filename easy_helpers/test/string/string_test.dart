import 'package:easy_helpers/easy_helpers.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

main() {
  test('dateTime', () {
    expect('2021-01-01'.dateTime, equals(DateTime(2021, 1, 1)));
    expect(
        '2021-01-01 01:02:03'.dateTime, equals(DateTime(2021, 1, 1, 1, 2, 3)));
  });
  test('short', () {
    expect('2021-01-02 03:04:05'.short,
        DateFormat.Md().format(DateTime.parse('2021-01-02 03:04:05')));
    expect(DateTime.now().toString().short,
        DateFormat.jm().format(DateTime.now()));
  });
  test('capitalizeFirstLetter', () {
    expect('test'.capitalizeFirstLetter(), equals('Test'));
    expect('Test'.capitalizeFirstLetter(), equals('Test'));
    expect('TEst'.capitalizeFirstLetter(), equals('TEst'));
    expect('TEST'.ucFirst, equals('TEST'));
  });
}
