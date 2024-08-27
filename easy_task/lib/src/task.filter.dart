import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_task/easy_task.dart';
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
  static Query filter(String menu) {
    assert(menu == 'all' ||
        menu == 'task' ||
        menu == 'project' ||
        menu == 'complete' ||
        menu == 'latest');

    Query q = Task.col;

    if (menu == 'all') {
      q = q.where(allMenuFilter).where('completed', isEqualTo: false);
    } else if (menu == 'task') {
      q = q.where(taskMenuFilter).where('completed', isEqualTo: false);
    } else if (menu == 'project') {
      q = q.where(projectMenuFilter).where('completed', isEqualTo: false);
    } else if (menu == 'complete') {
      q = q.where(allMenuFilter).where('completed', isEqualTo: true);
    } else if (menu == 'latest') {
      q = q
          .where('creator', isEqualTo: currentUser!.uid)
          .where('project', isEqualTo: false);
    }

    return q;
  }

  static Query query(String menu) {
    Query q = filter(menu);
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
