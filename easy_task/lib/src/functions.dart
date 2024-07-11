import 'dart:developer';

import 'package:flutter/foundation.dart';

void dog(String msg, {int level = 0}) {
  if (kReleaseMode) return;
  log('--> $msg', time: DateTime.now(), name: '🐶', level: level);
}
