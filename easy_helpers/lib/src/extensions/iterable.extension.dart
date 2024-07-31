/// Split one large list to limited sub lists
extension IterableExtension<T> on Iterable<T> {
  /// chunks
  ///
  /// Split one large list to limited sub lists
  ///
  /// ```dart
  /// [1, 2, 3, 4, 5, 6, 7, 8, 9].chunks(2)
  ///    => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
  /// ```
  ///
  /// Note, that this is much similar to the `slices` of collection package
  Iterable<List<T>> chunks(int chunkSize) sync* {
    final len = length;

    for (int i = 0; i < len; i += chunkSize) {
      final start = i > len ? i - len : i;
      yield skip(start).take(chunkSize).toList();
    }
  }
}

/// Split one large list to limited sub lists
extension ListExtension<T> on List<T> {
  /// chunks
  ///
  /// Split one large list to limited sub lists
  /// ```dart
  /// [1, 2, 3, 4, 5, 6, 7, 8, 9].chunks(2)
  ///    => [[1, 2], [3, 4], [5, 6], [7, 8], [9]]
  /// ```
  ///
  /// Note, that this is much similar to the `slices` of collection package
  List<List<T>> chunks(int chunkSize) {
    final chunks = <List<T>>[];
    final len = length;
    for (int i = 0; i < len; i += chunkSize) {
      final size = i + chunkSize;
      chunks.add(sublist(i, size > len ? len : size));
    }
    return chunks;
  }
}
