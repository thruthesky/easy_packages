import 'package:easy_locale/easy_locale.dart';

final localeTexts = <String, Map<String, String>>{
  'project': {
    'en': 'Project',
    'ko': '프로젝트',
  },
  'is this a project?': {
    'en': 'Is this a project?',
    'ko': '프로젝트인가요?',
  },
};

void addPostTranslations() async {
  final locale = await currentLocale;
  if (locale == null) return;

  for (var entry in localeTexts.entries) {
    lo.set(key: entry.key, locale: locale, value: entry.value[locale]);
  }
}
