import 'package:easy_helpers/easy_helpers.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

main() {
  group('String extensions', () {
    test('dateTime', () {
      expect('2021-01-01'.dateTime, equals(DateTime(2021, 1, 1)));
      expect('2021-01-01 01:02:03'.dateTime,
          equals(DateTime(2021, 1, 1, 1, 2, 3)));
    });
    test('short', () {
      expect('2021-01-02 03:04:05'.dateTime.short,
          DateFormat.Md().format(DateTime.parse('2021-01-02 03:04:05')));
      expect(DateTime.now().toString().dateTime.short,
          DateFormat.jm().format(DateTime.now()));
    });
    test('capitalizeFirstLetter', () {
      expect('test'.capitalizeFirstLetter(), equals('Test'));
      expect('Test'.capitalizeFirstLetter(), equals('Test'));
      expect('TEst'.capitalizeFirstLetter(), equals('TEst'));
      expect('TEST'.ucFirst, equals('TEST'));
    });

    test('or', () {
      String? test;
      expect(test.or('default'), equals('default'));
      expect(''.or('default'), equals('default'));
      expect('test'.or('default'), equals('test'));
    });

    test('isEmpty on null String', () {
      String? test;
      expect(test.isEmpty, equals(true));
      expect('test'.isEmpty, equals(false));
    });

    group('.hasMatch()', () {
      test('when pattern is "world" and string contains it, returns true', () {
        const input = "hello world";
        final result = input.hasMatch("world");
        expect(result, equals(true));
      });

      test(
          'when pattern is "world" and string does not contain it, returns false',
          () {
        const input = "hello dart";
        final result = input.hasMatch("world");
        expect(result, equals(false));
      });
    });
  });

  group('.isValidDateTime', () {
    test('when string is a valid date, returns true', () {
      const input = "2021-08-29"; // YYYY-MM-DD format
      final result = input.isValidDateTime;
      expect(result, equals(true));
    });

    test('when string is not a valid date, returns false', () {
      const input = "hello world";

      final result = input.isValidDateTime;
      expect(result, equals(false));
    });
  });
}
