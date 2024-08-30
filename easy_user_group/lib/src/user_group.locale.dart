import 'package:easy_locale/easy_locale.dart';

final localeTexts = <String, Map<String, String>>{
  'project': {
    'en': 'Project',
    'ko': '프로젝트',
  },
};

void addUserGroupLocaleTexts() async {
  lo.merge(localeTexts);
}
