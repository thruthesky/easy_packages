import 'package:easy_task/easy_task.dart';
import 'package:easy_task/unit_tests/test_helper.functions.dart';

Future<Task> createTask() async {
  return await Task.get(
    (await Task.create(title: 'task - ${DateTime.now()}')).id,
  ) as Task;
}

void testAllTask() async {
  testStart('Task CRUD Test');

  /// Task crud
  await testTaskCreate();
  await testTaskUpdate();

  /// Assign crud
  await testTaskAssign();

  /// Task delete
  await testTaskDeleteWithoutAssign();
  await testTaskDeleteWithAssign();
  await testTaskDeleteComplicated();

  /// Change the status;
  ///
  await testTaskStatus();

  // await testDeleteField();
  // await testCreateWithPriority();

  await testReport();
}

void testTaskCrud() async {
  testStart('Task CRUD Test');

  await testTaskCreate();
  await testTaskUpdate();

  testReport();
}

Future testTaskAssign() async {
  final task = await createTask();
  final createdRef =
      await Assign.create(taskId: task.id, uid: currentUser!.uid);
  final createdAssign = await Assign.get(createdRef.id) as Assign;
  isTrue(createdAssign.taskId == task.id, 'Task id is not correct');
  isTrue(createdAssign.uid == currentUser?.uid, 'User id is not correct');

  final updatedTask = await Task.get(task.id) as Task;

  isTrue(
    updatedTask.assignTo.contains(currentUser!.uid),
    'Expect: success on task assign',
  );
}

Future testTaskUnassign() async {
  final task = await createTask();
  final createdRef =
      await Assign.create(taskId: task.id, uid: currentUser!.uid);
  final createdAssign = await Assign.get(createdRef.id) as Assign;
  isTrue(createdAssign.taskId == task.id, 'Task id is not correct');
  isTrue(createdAssign.uid == currentUser!.uid, 'User id is not correct');

  final updatedTask = await Task.get(task.id) as Task;

  isTrue(
    updatedTask.assignTo.contains(currentUser!.uid),
    'Expect: success on task assign',
  );

  await createdAssign.delete();

  final updatedAssign = await Assign.get(createdAssign.id);
  isTrue(updatedAssign == null, 'Expect: success on assign delete.');

  final updatedTask2 = await Task.get(task.id) as Task;

  isTrue(
    !updatedTask2.assignTo.contains(currentUser!.uid),
    'Expect: success on task unassign (remove from assign list)',
  );
}

Future testTaskCreate() async {
  final ref = await Task.create(title: 'fisrt task');
  final created = await Task.get(ref.id) as Task;
  isTrue(created.title == 'fisrt task', 'title is not correct');
}

Future testTaskUpdate() async {
  final String title = 'task - ${DateTime.now()}';
  final ref = await Task.create(title: title);
  final created = await Task.get(ref.id) as Task;
  isTrue(created.title == title, 'title is not correct');

  await created.update(title: 'new title');
  final updated = await Task.get(ref.id) as Task;
  isTrue(updated.title == 'new title', 'Expect: success on title update.');
}

Future testTaskDeleteWithoutAssign() async {
  final ref = await Task.create(title: 'task - ${DateTime.now()}');
  final created = await Task.get(ref.id) as Task;

  await created.delete();
  final deleted = await Task.get(ref.id);
  isTrue(deleted == null, 'Expect: success on task delete.');
}

Future testTaskDeleteWithAssign() async {
  final ref = await Task.create(title: 'task - ${DateTime.now()}');
  final created = await Task.get(ref.id) as Task;

  final assignRef =
      await Assign.create(taskId: created.id, uid: currentUser!.uid);

  await created.delete();
  final deleted = await Task.get(ref.id);
  isTrue(deleted == null, 'Expect: success on task delete.');

  final deletedAssign = await Assign.get(assignRef.id);
  isTrue(deletedAssign == null, 'Expect: success on assign delete.');
}

/// Complicated Test
///
///
Future testTaskDeleteComplicated() async {
  /// Create 2 tasks
  final taskA = await createTask();
  final taskB = await createTask();

  /// assign taskA to 3 users
  await Assign.create(taskId: taskA.id, uid: currentUser!.uid);
  await Assign.create(taskId: taskA.id, uid: 'abc');
  await Assign.create(taskId: taskA.id, uid: 'def');

  /// assign taskB to 2 users
  await Assign.create(taskId: taskB.id, uid: '1');
  await Assign.create(taskId: taskB.id, uid: '2');

  /// Check if taskA has 3 assigns
  final List<Assign> assigns1 = await TaskService.instance.getAssigns(taskA.id);
  isTrue(assigns1.length == 3, 'Expect: success on assign create.');

  /// Delete taskA
  await taskA.delete();

  /// Check if taskA has 0 assigns
  final List<Assign> assigns1AfterDelete =
      await TaskService.instance.getAssigns(taskA.id);
  isTrue(assigns1AfterDelete.isEmpty, 'Expect: success on assign delete.');

  /// Check if taskB is not affected.
  final List<Assign> assigns2 = await TaskService.instance.getAssigns(taskB.id);
  isTrue(assigns2.length == 2, 'Expect: success on assign create.');
}

Future testTaskStatus() async {
  // uidB is the Assignee of the task
  final uidB = await loginAsB();

  // uidA is Creator of the task
  await loginAsA();

  // uidA created a task and assigned it to uidB
  final task = await createTask();
  final createdAssignRef = await Assign.create(uid: uidB, taskId: task.id);
  final createdAssign = await Assign.get(createdAssignRef.id);

  isTrue(createdAssign!.status == AssignStatus.waiting,
      'Expect: Assign status must be waiting.');

  // uidB change the status to progress
  await loginAsB();
  await createdAssign.changeStatus(AssignStatus.progress);
  final updatedAssignToProgress = await Assign.get(createdAssignRef.id);
  isTrue(updatedAssignToProgress!.status == AssignStatus.progress,
      'Expect: Success on task status change. Must be `progress`.');

  // uidA change the status to finished
  await loginAsA();
  await createdAssign.changeStatus(AssignStatus.finished);
  final updatedAssignToFinished = await Assign.get(createdAssignRef.id);
  isTrue(updatedAssignToFinished!.status == AssignStatus.finished,
      'Expect: success on task status change. Must be `finished`.');
}

/// Additional steps
///
/// Simulates the normal flow of assignments
Future testTaskFlow() async {
  // uidB is the Assignee of the task
  final uidB = await loginAsB();

  // uidA is Creator of the task
  await loginAsA();

  // uidA created a task and assigned it to uidB
  final task = await createTask();
  final createdAssignRef = await Assign.create(uid: uidB, taskId: task.id);
  final createdAssign = await Assign.get(createdAssignRef.id);

  isTrue(createdAssign!.status == AssignStatus.waiting,
      'Expect: Assign status must be waiting.');

  // uidB change the status to progress
  await loginAsB();
  await createdAssign.changeStatus(AssignStatus.progress);
  final updatedAssignToProgress = await Assign.get(createdAssignRef.id);
  isTrue(updatedAssignToProgress!.status == AssignStatus.progress,
      'Expect: Success on task status change. Must be `progress`.');

  // uidB tried to do the task. uidB change the status to review
  await loginAsB();
  await createdAssign.changeStatus(AssignStatus.progress);
  final updatedAssignToReview = await Assign.get(createdAssignRef.id);
  isTrue(updatedAssignToReview!.status == AssignStatus.review,
      'Expect: Success on task status change. Must be `review`.');

  // uidA rejected. Therefore, uidA set status to waiting
  await loginAsA();
  await createdAssign.changeStatus(AssignStatus.waiting);
  final updatedAssignRejected = await Assign.get(createdAssignRef.id);
  isTrue(updatedAssignRejected!.status == AssignStatus.waiting,
      'Expect: success on task status change. Must be `waiting`.');

  // uidB received the task as waiting again. Therefore, uidB can change the status to progress.
  await loginAsB();
  await createdAssign.changeStatus(AssignStatus.progress);
  final updatedAssignToProgress2 = await Assign.get(createdAssignRef.id);
  isTrue(updatedAssignToProgress2!.status == AssignStatus.progress,
      'Expect: Success on task status change. Must be `progress`.');

  // uid be addded enhancement to task. Therefore, uidB change the status to review
  await loginAsB();
  await createdAssign.changeStatus(AssignStatus.progress);
  final updatedAssignToReview2 = await Assign.get(createdAssignRef.id);
  isTrue(updatedAssignToReview2!.status == AssignStatus.review,
      'Expect: Success on task status change. Must be `review`.');

  // uidA accepted. Therefore, uidA change the status to finished
  await loginAsA();
  await createdAssign.changeStatus(AssignStatus.finished);
  final updatedAssignToFinished = await Assign.get(createdAssignRef.id);
  isTrue(updatedAssignToFinished!.status == AssignStatus.finished,
      'Expect: success on task status change.');
}

// Future testDeleteField() async {
//   final created = await createTask();
//   isTrue(created.startAt == null, "Expect: startAt must begin as null");
//   final DateTime startAtEntry = DateTime.now();
//   await created.update(startAt: startAtEntry);
//   final updatedStartAt = await Task.get(created.id) as Task;
//   isTrue(updatedStartAt.startAt == startAtEntry,
//       'Expect: success on startAt update.');
// }

// Future testCreateWithPriority() async {
//   final taskId = (await Task.create(
//     title: 'task - ${DateTime.now()}',
//     priority: 1,
//   ))
//       .id;

//   final created = await Task.get(taskId) as Task;
//   isTrue(
//     created.priority == 1,
//     'Expect: success on task with priority create.',
//   );
// }

Future testAssignRetrieveMyDocFromTaskID() async {
  // uidB is the Assignee of the task
  final uidB = await loginAsB();

  // uidA is Creator of the task
  await loginAsA();

  // uidA created a task and assigned it to uidB
  final task = await createTask();
  final createdAssignRef = await Assign.create(uid: uidB, taskId: task.id);
  await Assign.get(createdAssignRef.id);

  final retrieveAssignOfA = await TaskService.instance.getMyAssign(task.id);

  isTrue(retrieveAssignOfA == null,
      "Expect: assign must be null for A because it is not assigned to A");

  await loginAsB();

  final retrieveAssignOfB = await TaskService.instance.getMyAssign(task.id);

  isTrue(retrieveAssignOfB?.uid == uidB, "Expect: assign.uid must be uidB");
}
