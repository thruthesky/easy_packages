import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';
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

  // Group CRUD
  await testGroupCreateAndRetrieve();
  await testGroupUpdate();
  await testDeleteGroup();

  // Invite accept and Decline
  await testAcceptGroupInvitation();
  await testDeclineGroupInvitation();

  // Group invites
  await testGroupInvitation();
  await testAcceptGroupInvitation();
  await testDeclineGroupInvitation();

  // Task assignment to group
  await testTaskAssignmentToGroup();

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
  final createdRef = await Assign.create(task: task, assignTo: myUid!);
  final createdAssign = await Assign.get(createdRef.id) as Assign;
  isTrue(createdAssign.taskId == task.id, 'Task id is not correct');
  isTrue(createdAssign.assignTo == myUid, 'User id is not correct');

  final updatedTask = await Task.get(task.id) as Task;

  isTrue(
    updatedTask.assignTo.contains(myUid!),
    'Expect: success on task assign',
  );
}

Future testTaskUnassign() async {
  final task = await createTask();
  final createdRef = await Assign.create(task: task, assignTo: myUid!);
  final createdAssign = await Assign.get(createdRef.id) as Assign;
  isTrue(createdAssign.taskId == task.id, 'Task id is not correct');
  isTrue(createdAssign.assignTo == myUid!, 'User id is not correct');

  final updatedTask = await Task.get(task.id) as Task;

  isTrue(
    updatedTask.assignTo.contains(myUid!),
    'Expect: success on task assign',
  );

  await createdAssign.delete();

  final updatedAssign = await Assign.get(createdAssign.id);
  isTrue(updatedAssign == null, 'Expect: success on assign delete.');

  final updatedTask2 = await Task.get(task.id) as Task;

  isTrue(
    !updatedTask2.assignTo.contains(myUid!),
    'Expect: success on task unassign (remove from assign list)',
  );
}

Future testTaskCreate() async {
  final ref = await Task.create(title: 'fisrt task');
  final created = await Task.get(ref.id) as Task;
  isTrue(created.title == 'fisrt task', 'succes -> title is correct');
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

  final assignRef = await Assign.create(task: created, assignTo: myUid!);

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
  await Assign.create(task: taskA, assignTo: myUid!);
  await Assign.create(task: taskA, assignTo: 'abc');
  await Assign.create(task: taskA, assignTo: 'def');

  /// assign taskB to 2 users
  await Assign.create(task: taskB, assignTo: '1');
  await Assign.create(task: taskB, assignTo: '2');

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
  final createdAssignRef = await Assign.create(assignTo: uidB, task: task);
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
  final createdAssignRef = await Assign.create(assignTo: uidB, task: task);
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
  final createdAssignRef = await Assign.create(assignTo: uidB, task: task);
  await Assign.get(createdAssignRef.id);

  final retrieveAssignOfA = await TaskService.instance.getMyAssignFrom(task.id);

  isTrue(retrieveAssignOfA == null,
      "Expect: assign must be null for A because it is not assigned to A");

  await loginAsB();

  final retrieveAssignOfB = await TaskService.instance.getMyAssignFrom(task.id);

  isTrue(retrieveAssignOfB?.assignTo == uidB,
      "Expect: assign.assignTo must be uidB");
}

Future testGroupCRUD() async {
  testStart('Group CRUD Test');

  await testGroupCreateAndRetrieve();
  await testGroupUpdate();
  await testDeleteGroup();

  await testReport();
}

Future testGroupCreateAndRetrieve() async {
  // uidA is the one going to create a group
  final uidA = await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await TaskUserGroup.create(name: groupName);

  final group = await TaskUserGroup.get(groupRef.id);

  isTrue(
    group!.name == groupName,
    'Expect: Created Group must have same name',
  );

  isTrue(
    group.moderatorUsers.contains(uidA),
    'Expect: The moderator of the Group must be automatically be the FirebaseAuth user',
  );

  isTrue(
    group.users.isEmpty,
    'Expect: The newly created group must have no members/users',
  );
}

Future testGroupUpdate() async {
  // uidA is the one going to create a group
  final uidA = await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await TaskUserGroup.create(name: groupName);

  final group = await TaskUserGroup.get(groupRef.id);

  const groupNameUpdated = 'No Longer the Best Group';

  await group!.update(name: groupNameUpdated);

  final updatedGroup = await TaskUserGroup.get(groupRef.id);

  isTrue(
    updatedGroup!.name == groupNameUpdated,
    'Expect: Updated Group must have same name',
  );

  isTrue(
    group.moderatorUsers.contains(uidA),
    'Expect: The moderator of the Group should not be affected',
  );
}

Future testDeleteGroup() async {
  // uidA is the one going to create a group
  await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await TaskUserGroup.create(name: groupName);

  final group = await TaskUserGroup.get(groupRef.id);

  await group!.delete();

  final deleted = await TaskUserGroup.get(groupRef.id);
  isTrue(deleted == null,
      'Expect: TaskUserGroup.get() must return null after delete');
}

Future testGroupInvitation() async {
  final uidB = await loginAsB();

  // uidA is the one going to create a group
  await loginAsA();

  const groupName = 'Invite Test';

  final groupRef = await TaskUserGroup.create(name: groupName);

  final group = await TaskUserGroup.get(groupRef.id);

  await group!.inviteUsers([uidB]);

  final updatedGroup = await TaskUserGroup.get(groupRef.id);

  isTrue(
    updatedGroup!.invitedUsers.contains(uidB),
    "Expect: uidB must be added to invited users",
  );

  isTrue(
    !updatedGroup.users.contains(uidB),
    "Expect: uidB must not be added to users yet",
  );
}

Future testAcceptGroupInvitation() async {
  final uidB = await loginAsB();

  // uidA is the one going to create a group
  await loginAsA();

  const groupName = 'Invite Accept Test';

  final groupRef = await TaskUserGroup.create(name: groupName);

  final group = await TaskUserGroup.get(groupRef.id);

  await group!.inviteUsers([uidB]);

  await loginAsB();

  final updatedGroup = await TaskUserGroup.get(groupRef.id);

  // B accepts the invitation
  await updatedGroup!.accept();

  final updatedGroup2 = await TaskUserGroup.get(groupRef.id);

  isTrue(
    updatedGroup2!.users.contains(uidB),
    "Expect: uidB must be added to users",
  );
  isTrue(
    !updatedGroup2.invitedUsers.contains(uidB),
    "Expect: uidB must be removed from invited users",
  );
  isTrue(
    !updatedGroup2.rejectedUsers.contains(uidB),
    "Expect: uidB must not be in rejected users",
  );
}

Future testDeclineGroupInvitation() async {
  final uidB = await loginAsB();

  // uidA is the one going to create a group
  await loginAsA();

  const groupName = 'Invite Decline Test';

  final groupRef = await TaskUserGroup.create(name: groupName);

  final group = await TaskUserGroup.get(groupRef.id);

  await group!.inviteUsers([uidB]);

  await loginAsB();
  final updatedGroup = await TaskUserGroup.get(groupRef.id);

  // B reject the invitation
  await updatedGroup!.reject();

  final updatedGroup2 = await TaskUserGroup.get(groupRef.id);

  isTrue(
    !updatedGroup2!.users.contains(uidB),
    "Expect: uidB must not be added to users",
  );
  isTrue(
    !updatedGroup2.invitedUsers.contains(uidB),
    "Expect: uidB must not be in invited users",
  );
  isTrue(
    updatedGroup2.rejectedUsers.contains(uidB),
    "Expect: uidB must be in rejected users",
  );
}

Future testTaskAssignmentToGroup() async {
  // uidB is the one going to be invited
  final uidB = await loginAsB();

  // uidC is another one going to be invited
  final uidC = await loginAsC();

  // uidA is the one going to create a group
  await loginAsA();

  // Create Group
  const groupName = 'The Assignment Group';
  final groupRef = await TaskUserGroup.create(name: groupName);

  final group = await TaskUserGroup.get(groupRef.id);

  // Invite B and C
  await group!.inviteUsers([uidB, uidC]);

  // Let B accept the group
  await loginAsB();
  final updatedGroup = await TaskUserGroup.get(groupRef.id);
  // B accepts the invitation
  await updatedGroup!.accept();

  // Let C accept the group
  await loginAsC();
  final updatedGroup2 = await TaskUserGroup.get(groupRef.id);
  // C accepts the invitation
  await updatedGroup2!.accept();

  // uidA will create a task for the group
  await loginAsA();

  final taskRef = await Task.create(title: 'task - ${DateTime.now()}');

  final task = await Task.get(taskRef.id);

  final assignRefs =
      await TaskService.instance.assignGroup(task: task!, groupId: groupRef.id);

  isTrue(assignRefs!.length == 2,
      "Expect: Since there are two member, there must be two assigns");

  final assigns = await TaskService.instance.getAssigns(task.id);

  isTrue(assigns.length == 2,
      "Expect: Since there are two member, there must be two assigns");

  isTrue(
    [uidB, uidC].contains(assigns[0].assignTo),
    "Expect: Uid B or C must be used one of the assigns.",
  );
  isTrue(
    [uidB, uidC].contains(assigns[1].assignTo),
    "Expect: Uid B or C must be used one of the assigns.",
  );
}
