import 'package:easy_locale/easy_locale.dart';

final localeTexts = <String, Map<String, String>>{
  'project': {
    'en': 'Project',
    'ko': '프로젝트',
  },
  'is this a project?': {
    'en': 'Want to create a project?',
    'ko': '프로젝트를 만들까요?',
  },
  'task list is empty': {
    'en': 'There is no task. Create one to get started.',
    'ko': '할 일이 없습니다. 할 일을 만들어 보세요.',
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
    'ko': '완료 됨',
  },
  'task description': {
    'en': 'Task Description',
    'ko': '할 일 설명',
  },
  'create task': {
    'en': 'Create Task',
    'ko': '할 일 생성',
  },
  'completed tasks': {
    'en': 'Completed Tasks',
    'ko': '완료된 일',
  },
  'complete': {
    'en': 'Complete',
    'ko': '완료',
  },
  'to complete': {
    'en': 'Complete',
    'ko': '완료하기',
  },
  'update task': {
    'en': 'Update',
    'ko': '업데이트',
  },
  'created at': {
    'en': 'Created At',
    'ko': '생성',
  },
  'updated at': {
    'en': 'Updated At',
    'ko': '수정',
  },
  'task updated message': {
    'en': 'Task updated',
    'ko': '할 일이 업데이트 되었습니다',
  },
};

void addTaskLocaleTexts() async {
  lo.merge(localeTexts);

  // final locale = await currentLocale;
  // if (locale == null) return;

  // for (var entry in localeTexts.entries) {
  //   if (lo.get(key: entry.key, locale: locale) != null) continue;
  //   lo.set(key: entry.key, locale: locale, value: entry.value[locale]);
  // }
  // TaskService.instance.setLocaleTexts?.call();
}
