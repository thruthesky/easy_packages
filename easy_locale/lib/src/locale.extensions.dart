import 'package:easy_locale/easy_locale.dart';

extension LocaleServiceExtensionMap on String {
  /// Translate the string
  ///
  /// Example:
  /// ```dart
  /// 'version'.t
  /// ```
  String get t => LocaleService.instance.tr(this);

  /// Translate with replacement
  String tr({Map<String, dynamic>? args, int? form}) =>
      LocaleService.instance.tr(
        this,
        args: args,
        form: form,
      );
}
