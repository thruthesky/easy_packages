import 'dart:io';

import 'package:flutter/foundation.dart';

/// 플랫폼 이름을 반환한다.
///
/// 가능하면, isIos 또는 isAndroid, kIsWeb 을 사용하도록 한다.
/// It returns one of 'web', 'android', 'fuchsia', 'ios', 'linux', 'macos', 'windows'.
String platformName() {
  if (kIsWeb) {
    return 'web';
  } else {
    return defaultTargetPlatform.name.toLowerCase();
  }
}

bool get isIos => Platform.isIOS;
bool get isAndroid => Platform.isAndroid;
