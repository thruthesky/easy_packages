import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Task filter
///
/// This class contains the filter for the task
class TaskFilter {
  TaskFilter._();

  static get currentUser => FirebaseAuth.instance.currentUser;

  /// Task filter for the task list
  ///
  /// It returns the Query. It does not include 'orderBy`.
  ///
  /// You can use it for query, count, etc.
  ///
  static Query filter(TaskListOptions options) {
    assert(options.menu == 'all' ||
        options.menu == 'task' ||
        options.menu == 'project' ||
        options.menu == 'latest');

    Query q = Task.col;

    if (options.menu == 'all') {
      q = q.where(allMenuFilter);
    } else if (options.menu == 'task') {
      q = q.where(taskMenuFilter);
    } else if (options.menu == 'project') {
      q = q.where(projectMenuFilter);
    } else if (options.menu == 'latest') {
      q = q
          .where('creator', isEqualTo: currentUser!.uid)
          .where('project', isEqualTo: false);
    }

    // if the menu is all or tasks, then apply the completed filter
    if (options.menu != 'project') {
      q = q.where('completed', isEqualTo: options.completed);
    }

    return q;
  }

  static Query query(TaskListOptions options) {
    Query q = filter(options);
    q = q.orderBy('createdAt', descending: true);
    return q;
  }

  static Filter get allMenuFilter {
    return Filter.and(
      Filter(
        'creator',
        isEqualTo: currentUser!.uid,
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
