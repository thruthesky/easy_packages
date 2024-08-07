import 'package:flutter/material.dart';

extension EasyHelperMediaQueryExtension on BuildContext {
  Size get mediaQuerySize => MediaQuery.sizeOf(this);

  /// Small screen means if the width is smaller than 600
  /// If the device is a mobile phone and it is rotated in landscape mode,
  /// Then, the width is the longest side.
  /// If the phone is in portrait mode, then the width is shortest side.
  bool get isSmallScreen => (mediaQuerySize.width < 400);
  bool get isMediumScreen => (mediaQuerySize.width < 800);
  bool get isBigScreen => !isSmallScreen && !isMediumScreen;
}
