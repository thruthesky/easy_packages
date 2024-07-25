import 'package:easy_helpers/easy_helpers.dart';
import 'package:test/test.dart';

main() {
  group('DateTime extensions', () {
    test('isSameWeek - failure tests', () {
      expect(DateTime(2017, 3, 4).isSameWeek(DateTime(2017, 3, 5)), false);
    });

    test('isSameWeek - success tests', () {
      /// Compare Jun 30, 2024 (Sunday) and Jul 1, 2024 (Monday)
      expect(
          DateTime(2024, 7, 1)
              .subtract(const Duration(days: 1))
              .isSameWeek(DateTime(2024, 7, 1)),
          true);
      expect(DateTime(2024, 7, 6).isSameWeek(DateTime(2024, 7, 7)), false);
      expect(DateTime(2024, 7, 7).isSameWeek(DateTime(2024, 7, 8)), true);
      expect(DateTime(2017, 3, 4).isSameWeek(DateTime(2017, 3, 5)), false);
      expect(DateTime(2017, 3, 5).isSameWeek(DateTime(2017, 3, 6)), true);
      expect(DateTime(2017, 2, 26).isSameWeek(DateTime(2017, 3, 4)), true);
      expect(DateTime(2017, 3, 4).isSameWeek(DateTime(2017, 3, 10)), false);
      expect(DateTime(2017, 3, 3).isSameWeek(DateTime(2017, 3, 10)), false);
      expect(DateTime(2017, 3, 10).isSameWeek(DateTime(2017, 3, 10)), true);
      expect(DateTime(2018, 3, 29, 12).isSameWeek(DateTime(2018, 3, 22, 12)),
          false);
      expect(DateTime(2018, 3, 6, 12).isSameWeek(DateTime(2018, 3, 13, 12)),
          false);
    });
  });
}
