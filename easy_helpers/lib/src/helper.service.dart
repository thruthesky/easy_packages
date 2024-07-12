import 'package:flutter/material.dart';

class HelperService {
  static HelperService? _instance;
  static HelperService get instance => _instance ??= HelperService._();

  HelperService._();
  BuildContext Function()? _globalContext;
  BuildContext? get globalContext => _globalContext?.call();
  init({
    BuildContext Function()? globalContext,
  }) {
    _globalContext = globalContext;
  }
}
