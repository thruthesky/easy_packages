import 'package:flutter/material.dart';

extension EasyHelperMediaQueryExtension on BuildContext {
  /// Small screen means if the width is smaller than 600
  /// If the device is a mobile phone and it is rotated in landscape mode,
  /// Then, the width is the longest side.
  /// If the phone is in portrait mode, then the width is shortest side.
  bool get isSmallScreen => (MediaQuery.of(this).size.width < 600);
  bool get isBigWidgetScreen => !isSmallScreen;
}
