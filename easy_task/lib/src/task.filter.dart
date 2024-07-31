import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';

/// Task filter
///
/// This class contains the filter for the task
class TaskFilter {
  TaskFilter._();

  /// Task filter for the task list
  ///
  /// It returns the Query. It does not include 'orderBy`.
  ///
  /// You can use it for query, count, etc.
  ///
  static Query filter({
    required String menu,
    required bool completed,
  }) {
    assert(menu == 'all' ||
        menu == 'task' ||
        menu == 'project' ||
        menu == 'latest');

    Query q = Task.col;

    if (menu == 'all') {
      q = q.where(allMenuFilter);
    } else if (menu == 'task') {
      q = q.where(taskMenuFilter);
    } else if (menu == 'project') {
      q = q.where(projectMenuFilter);
    } else if (menu == 'latest') {
      q = q
          .where('creator', isEqualTo: TaskService.instance.currentUser!.uid)
          .where('project', isEqualTo: false);
    }

    // if the menu is all or tasks, then apply the completed filter
    if (menu != 'project') {
      q = q.where('completed', isEqualTo: completed);
    }

    return q;
  }

  static Query query({
    required String menu,
    required bool completed,
  }) {
    Query q = filter(menu: menu, completed: completed);
    q = q.orderBy('createdAt', descending: true);
    return q;
  }

  static Filter get allMenuFilter {
    return Filter.and(
      Filter(
        'creator',
        isEqualTo: TaskService.instance.currentUser!.uid,
      ),
      Filter.or(
        // if project
        Filter('project', isEqualTo: true),
        Filter.and(
          // if not project and not child (that is root level task)
          Filter('project', isEqualTo: false),
          Filter('child', isEqualTo: false),
        ),
      ),
    );
  }

  static Filter get taskMenuFilter {
    return Filter.and(
      Filter(
        'creator',
        isEqualTo: TaskService.instance.currentUser!.uid,
      ),
      Filter('project', isEqualTo: false),
      Filter('child', isEqualTo: false),
    );
  }

  static Filter get projectMenuFilter {
    return Filter.and(
      Filter(
        'creator',
        isEqualTo: TaskService.instance.currentUser!.uid,
      ),
      Filter('project', isEqualTo: true),
    );
  }
}
