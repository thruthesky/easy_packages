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
  'no task found': {
    'en': 'No task found',
    'ko': '할 일이 없습니다',
  },
  'all': {
    'en': 'All',
    'ko': '전체',
  },
  'tasks': {
    'en': 'Tasks',
    'ko': '할 일',
  },
  'projects': {
    'en': 'Projects',
    'ko': '프로젝트',
  },
  'task list': {
    'en': 'Task List',
    'ko': '할 일 목록',
  },
  'an error occurred': {
    'en': 'An error occurred;\n{n}',
    'ko': '오류가 발생했습니다;\n{n}',
  },
  'task': {
    'en': 'Task',
    'ko': '할 일',
  },
  'creator': {
    'en': 'Creator',
    'ko': '생성자',
  },
  'completed': {
    'en': 'Completed',
    'ko': '완료',
  },
  'task description': {
    'en': 'Task Description',
    'ko': '할 일 설명',
  },
};

void addPostTranslations() async {
  final locale = await currentLocale;
  if (locale == null) return;

  for (var entry in localeTexts.entries) {
    lo.set(key: entry.key, locale: locale, value: entry.value[locale]);
  }
}
