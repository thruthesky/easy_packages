import 'package:easy_locale/easy_locale.dart';

final localeTexts = <String, Map<String, dynamic>>{};

applyUserLocales() async {
  lo.merge(localeTexts);
}
