import 'package:easy_locale/easy_locale.dart';

final localeTexts = <String, Map<String, String>>{
  'chat list is empty': {
    'en': 'You have no chat friends. Start chatting with someone.',
    'ko': '채팅 친구가 없습니다. 누군가와 채팅을 시작하세요.',
  },
};

applyChatLocales() async {
  final locale = await currentLocale;
  if (locale == null) return;

  for (var entry in localeTexts.entries) {
    lo.set(key: entry.key, locale: locale, value: entry.value[locale]);
  }
}
