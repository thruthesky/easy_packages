import 'package:easy_locale/easy_locale.dart';

final localeTexts = <String, Map<String, String>>{
  'youtubu': {
    'en': 'Youtube',
    'ko': '유튜브',
  },
};

void addPostTranslations() async {
  final locale = await currentLocale;
  if (locale == null) return;

  for (var entry in localeTexts.entries) {
    lo.set(key: entry.key, locale: locale, value: entry.value[locale]);
  }
}
