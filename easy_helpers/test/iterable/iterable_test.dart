import 'package:easy_helpers/easy_helpers.dart';
import 'package:test/test.dart';

main() {
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

    /// Test chunk method with a list of 10 elements and chunk size of 3
    test('chunks 10 / 3', () {
      expect([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].chunks(3), [
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9],
        [10]
      ]);
    });

    /// Test chunk method with a list of 100 elements and chunk size of 41
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
