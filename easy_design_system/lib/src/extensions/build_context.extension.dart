import 'package:flutter/material.dart';

extension SocialKitContext on BuildContext {
  /// Narrow mobile screen like iPhone SE.
  ///
  /// Returns true if the screen width is less than or equal to 375
  bool get isNarrow {
    return MediaQuery.of(this).size.width <= 375;
  }

  /// Wide mobile screen like Table, iPad.
  bool get isWide {
    return MediaQuery.of(this).size.width > 767;
  }
}
