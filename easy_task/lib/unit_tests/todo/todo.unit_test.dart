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

  // Invitation CRUD
  await testInvitationCreateAndRetrieve();
  // No need for update invitation because it is not needed for now.
  await testInvitationDelete();

  // Group CRUD
  await testGroupCreateAndRetrieve();
  await testGroupUpdate();
  await testGroupAddMember();
  await testGroupRemoveMember();
  await testDeleteGroup();

  // Invite accept and Decline
  await testAcceptGroupInvitation();
  await testDeclineGroupInvitation();

  // Group invites
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
  final createdRef = await Assign.create(taskId: task.id, uid: myUid!);
  final createdAssign = await Assign.get(createdRef.id) as Assign;
  isTrue(createdAssign.taskId == task.id, 'Task id is not correct');
  isTrue(createdAssign.uid == myUid, 'User id is not correct');

  final updatedTask = await Task.get(task.id) as Task;

  isTrue(
    updatedTask.assignTo.contains(myUid!),
    'Expect: success on task assign',
  );
}

Future testTaskUnassign() async {
  final task = await createTask();
  final createdRef = await Assign.create(taskId: task.id, uid: myUid!);
  final createdAssign = await Assign.get(createdRef.id) as Assign;
  isTrue(createdAssign.taskId == task.id, 'Task id is not correct');
  isTrue(createdAssign.uid == myUid!, 'User id is not correct');

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

  final assignRef = await Assign.create(taskId: created.id, uid: myUid!);

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
  await Assign.create(taskId: taskA.id, uid: myUid!);
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

  final retrieveAssignOfA = await TaskService.instance.getMyAssignFrom(task.id);

  isTrue(retrieveAssignOfA == null,
      "Expect: assign must be null for A because it is not assigned to A");

  await loginAsB();

  final retrieveAssignOfB = await TaskService.instance.getMyAssignFrom(task.id);

  isTrue(retrieveAssignOfB?.uid == uidB, "Expect: assign.uid must be uidB");
}

Future testInvitationCRUD() async {
  testStart('Invitation CRUD Test');
  await testInvitationCreateAndRetrieve();
  // No need for update because it is not needed for now.
  await testInvitationDelete();
  await testReport();
}

Future testInvitationCreateAndRetrieve() async {
  // uidB is the one going to be invited
  final uidB = await loginAsB();

  // uidA is the one going to invite B
  final uidA = await loginAsA();

  const groupId = 'group-1';

  // A invite B
  final invitationRef = await Invitation.create(uid: uidB, groupId: groupId);

  final invitation = await Invitation.get(invitationRef.id);

  isTrue(
    invitation!.groupId == groupId,
    'Expect: Created Invitation must have same group id',
  );

  isTrue(
    invitation.invitedBy == uidA,
    'Expect: Invitation must be automatically be made by FirebaseAuth user',
  );

  isTrue(
    invitation.uid == uidB,
    'Expect: Created Invitation uid must be the uid of the invited user',
  );
}

Future testInvitationDelete() async {
  // uidB is the one going to be invited
  final uidB = await loginAsB();

  // uidA is the one going to invite B
  await loginAsA();

  const groupId = 'group-1';

  // A invite B
  final invitationRef = await Invitation.create(uid: uidB, groupId: groupId);

  final invitation = await Invitation.get(invitationRef.id);

  await invitation!.delete();

  final deleted = await Invitation.get(invitationRef.id);
  isTrue(deleted == null,
      'Expect: Invitation.get() must return null after delete');
}

Future testGroupCRUD() async {
  testStart('Group CRUD Test');

  await testGroupCreateAndRetrieve();
  await testGroupUpdate();
  await testGroupAddMember();
  await testGroupRemoveMember();
  await testDeleteGroup();

  await testReport();
}

Future testGroupCreateAndRetrieve() async {
  // uidA is the one going to create a group
  final uidA = await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await Group.create(name: groupName);

  final group = await Group.get(groupRef.id);

  isTrue(
    group!.name == groupName,
    'Expect: Created Group must have same name',
  );

  isTrue(
    group.moderatorUid == uidA,
    'Expect: The moderator of the Group must be automatically be the FirebaseAuth user',
  );

  isTrue(
    group.members.isEmpty,
    'Expect: The newly created group must have no members',
  );
}

Future testGroupUpdate() async {
  // uidA is the one going to create a group
  final uidA = await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await Group.create(name: groupName);

  final group = await Group.get(groupRef.id);

  const groupNameUpdated = 'No Longer the Best Group';

  await group!.update(name: groupNameUpdated);

  final updatedGroup = await Group.get(groupRef.id);

  isTrue(
    updatedGroup!.name == groupNameUpdated,
    'Expect: Updated Group must have same name',
  );

  isTrue(
    group.moderatorUid == uidA,
    'Expect: The moderator of the Group should not be affected',
  );
}

Future testGroupAddMember() async {
  final uidB = await loginAsB();
  // uidA is the one going to create a group
  final uidA = await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await Group.create(name: groupName);

  final group = await Group.get(groupRef.id);

  await group!.addMember(uidB);

  final updatedGroup = await Group.get(groupRef.id);

  isTrue(updatedGroup!.members.contains(uidB),
      "Expect: uidB must be added to members");

  isTrue(
    group.moderatorUid == uidA,
    'Expect: The moderator of the Group should not be affected',
  );
}

Future testGroupRemoveMember() async {
  final uidB = await loginAsB();

  // uidA is the one going to create a group
  final uidA = await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await Group.create(name: groupName);

  final group = await Group.get(groupRef.id);

  await group!.addMember(uidB);

  final updatedGroup = await Group.get(groupRef.id);

  isTrue(updatedGroup!.members.contains(uidB),
      "Expect: uidB must be added to members");

  await updatedGroup.removeMember(uidB);

  final removedMemberGroup = await Group.get(groupRef.id);

  isTrue(
    !removedMemberGroup!.members.contains(uidB),
    "Expect: uidB must be removed from members",
  );

  isTrue(
    group.moderatorUid == uidA,
    'Expect: The moderator of the Group should not be affected',
  );
}

Future testDeleteGroup() async {
  // uidA is the one going to create a group
  await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await Group.create(name: groupName);

  final group = await Group.get(groupRef.id);

  await group!.delete();

  final deleted = await Group.get(groupRef.id);
  isTrue(deleted == null, 'Expect: Group.get() must return null after delete');
}

Future testAcceptGroupInvitation() async {
  // uidB is the one going to be invited
  final uidB = await loginAsB();

  // uidA is the one going to create a group
  await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await Group.create(name: groupName);

  await Invitation.create(uid: uidB, groupId: groupRef.id);

  await loginAsB();

  await TaskService.instance.acceptGroupInvitation(groupRef.id);

  final group = await Group.get(groupRef.id);

  isTrue(
    group!.members.contains(uidB),
    "Expect: uidB must be added to members",
  );

  final invitationSnapshot = await TaskService.instance.invitationCol
      .where('groupdId', isEqualTo: groupRef.id)
      .where('uid', isEqualTo: myUid!)
      .get();

  isTrue(
    invitationSnapshot.docs.isEmpty,
    "Expect: invitations must be deleted",
  );
}

Future testDeclineGroupInvitation() async {
  // uidB is the one going to be invited
  final uidB = await loginAsB();

  // uidA is the one going to create a group
  await loginAsA();

  // Create Group
  const groupName = 'The Best Group';
  final groupRef = await Group.create(name: groupName);

  // Invite B
  await Invitation.create(uid: uidB, groupId: groupRef.id);

  await loginAsB();
  await TaskService.instance.declineGroupInvitation(groupRef.id);

  final group = await Group.get(groupRef.id);

  isTrue(
    !group!.members.contains(uidB),
    "Expect: uidB must not be added to members",
  );

  final invitationSnapshot = await TaskService.instance.invitationCol
      .where('groupdId', isEqualTo: groupRef.id)
      .where('uid', isEqualTo: myUid!)
      .get();

  isTrue(
    invitationSnapshot.docs.isEmpty,
    "Expect: invitations must be deleted",
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
  final groupRef = await Group.create(name: groupName);

  // Invite B
  await Invitation.create(uid: uidB, groupId: groupRef.id);

  // Invite C
  await Invitation.create(uid: uidC, groupId: groupRef.id);

  // Let B accept the group
  await loginAsB();
  await TaskService.instance.acceptGroupInvitation(groupRef.id);

  // Let C accept the group
  await loginAsC();
  await TaskService.instance.acceptGroupInvitation(groupRef.id);

  // uidA will create a task for the group
  await loginAsA();

  final taskRef = await Task.create(title: 'task - ${DateTime.now()}');

  final task = await Task.get(taskRef.id);

  final assignRefs = await TaskService.instance
      .assignGroup(taskId: task!.id, groupId: groupRef.id);

  isTrue(assignRefs!.length == 2,
      "Expect: Since there are two member, there must be two assigns");

  final assigns = await TaskService.instance.getAssigns(task.id);

  isTrue(assigns.length == 2,
      "Expect: Since there are two member, there must be two assigns");

  isTrue(
    [uidB, uidC].contains(assigns[0].uid),
    "Expect: Uid B or C must be used one of the assigns.",
  );
  isTrue(
    [uidB, uidC].contains(assigns[1].uid),
    "Expect: Uid B or C must be used one of the assigns.",
  );
}
