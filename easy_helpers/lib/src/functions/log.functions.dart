import 'dart:developer' show log;

import 'package:flutter/foundation.dart' show kReleaseMode;

/// Print log message with emoji 🐶
void dog(dynamic msg, {int level = 0}) {
  if (kReleaseMode) return;
  log('--> ${msg.toString()}', time: DateTime.now(), name: '🐶', level: level);
}

/// Print log message with emoji 🐶 on any Object.
extension EasyHelperDogExtension on Object {
  void dog({int level = 0}) {
    if (kReleaseMode) return;
    log('--> ${toString()}', time: DateTime.now(), name: '🐶', level: level);
  }
}
