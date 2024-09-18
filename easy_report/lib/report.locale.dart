import 'package:easy_locale/easy_locale.dart';

final localeTexts = <String, Map<String, dynamic>>{
  'you already have reported this': {
    'en': 'You already have reported this.',
    'ko': "이미 이것을 신고하셨습니다.",
  },
  'you are not signed in': {
    'en': 'You are not signed in.',
    'ko': '로그인이 필요합니다.',
  },
  'you cannot report yourself': {
    'en': 'You cannot report yourself.',
    'ko': '자신을 신고할 수 없습니다.',
  }
};

applyReportLocales() async {
  lo.merge(localeTexts);
}
