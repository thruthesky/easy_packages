import 'package:easy_locale/easy_locale.dart';

final localeTexts = <String, Map<String, String>>{
  'youtube': {
    'en': 'Youtube',
    'ko': '유튜브',
  },
  'post list is empty': {
    'en': 'Post list is empty. Please add a new post.',
    'ko': '글이 없습니다. 새 글을 추가해 주세요.',
  },
};

void addPostTranslations() async {
  final locale = await currentLocale;
  if (locale == null) return;

  for (var entry in localeTexts.entries) {
    if (lo.get(key: entry.key, locale: locale) != null) continue;
    lo.set(key: entry.key, locale: locale, value: entry.value[locale]);
  }
}
