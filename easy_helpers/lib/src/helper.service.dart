import 'package:flutter/material.dart';

class HelperService {
  static HelperService? _instance;
  static HelperService get instance => _instance ??= HelperService._();

  HelperService._();

  /// Global context allows you to have access context when theres a case that the
  /// widget have direct access to `BuildContext` or the current BuildContext sudenly
  /// dispose of unmounted from the widget tree but the instance still need for a build
  /// context. use HelperService.instance.globalContext;
  ///
  /// ```dart
  ///
  /// final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();
  /// BuildContext get globalContext => globalNavigatorKey.currentContext!;
  /// ....
  /// ....
  ///
  /// HelperService.instance.init(
  ///   globalContext: () => globalContext;
  /// )
  /// ```
  ///
  BuildContext Function()? _globalContext;
  BuildContext? get globalContext => _globalContext?.call();

  init({
    BuildContext Function()? globalContext,
  }) {
    _globalContext = globalContext;
  }
}
