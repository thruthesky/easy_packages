import 'package:easy_task/easy_task.dart';
import 'package:easy_task/src/defines.dart';
import 'package:easy_task/unit_tests/test_helper.functions.dart';

Future testCrudExtraData({bool includeReport = false}) async {
  if (includeReport) testStart('Task CRUD Test');

  // Task
  await testTaskCreateAndRetriveWithExtraData();
  await testTaskUpdateWithExtraData();
  await testTaskDeleteWithExtraData();

  // Assign
  await testTaskAssignCreateAndRetrieveWithExtraData();
  await testDeleteAssignWithExtraData();

  // Group
  await testGroupCreateAndRetrieveWithExtraData();
  await testGroupUpdateWithExtraData();
  await testDeleteGroupWithExtraData();

  if (includeReport) testReport();
}

// Task =========================================

Future testTaskCreateAndRetriveWithExtraData() async {
  const customValue = 'custom value';
  final ref = await Task.create(
    title: 'fisrt task',
    extraData: {
      'customField': customValue,
    },
  );
  final created = await Task.get(ref.id) as Task;
  isTrue(
      created.title == 'fisrt task', 'Expect: title is correct and unaffected');
  isTrue(created.data['customField'] == customValue,
      'Expect: customField is correct');
}

Future testTaskUpdateWithExtraData() async {
  const customValue = 'custom value';
  final String title = 'task - ${DateTime.now()}';
  final ref = await Task.create(
    title: title,
    extraData: {
      'customField': customValue,
    },
  );
  final created = await Task.get(ref.id) as Task;
  isTrue(created.title == title, 'Expect: title is correct');

  await created.update(extraData: {
    'customField': 'new value',
  });
  final updated = await Task.get(ref.id) as Task;
  isTrue(updated.title == created.title, 'Expect: title must not be affected.');
  isTrue(
    updated.data['customField'] == 'new value',
    'Expect: customField must be updated.',
  );
}

Future testTaskDeleteWithExtraData() async {
  const customValue = 'custom value';
  final String title = 'task - ${DateTime.now()}';
  final ref = await Task.create(
    title: title,
    extraData: {
      'customField': customValue,
    },
  );
  final created = await Task.get(ref.id) as Task;

  await created.delete();
  final deleted = await Task.get(ref.id);
  isTrue(
    deleted == null,
    'Expect: success on deleting task with extra data as normal.',
  );
}

Future testTaskDeleteWithExtraDataWithAssign() async {
  final ref = await Task.create(
    title: 'task - ${DateTime.now()}',
    extraData: {
      'customField': 'custom value',
    },
  );
  final created = await Task.get(ref.id) as Task;

  final assignRef = await Assign.create(task: created, assignTo: myUid!);

  await created.delete();
  final deleted = await Task.get(ref.id);
  isTrue(
    deleted == null,
    'Expect: success on deleting task with extra data as normal.',
  );

  final deletedAssign = await Assign.get(assignRef.id);
  isTrue(
    deletedAssign == null,
    'Expect: success on deleting assign of task with extra data as normal.',
  );
}

// Assign ======================================

Future testTaskAssignCreateAndRetrieveWithExtraData() async {
  final task = await createTask();
  final createdRef = await Assign.create(
    task: task,
    assignTo: myUid!,
    extraData: {
      'customField': 'custom value',
    },
  );
  final createdAssign = await Assign.get(createdRef.id) as Assign;
  isTrue(createdAssign.taskId == task.id, 'Expect: Task id is correct');
  isTrue(createdAssign.assignTo == myUid, 'Expect: User id is correct');
  isTrue(
    createdAssign.data['customField'] == 'custom value',
    'Expect: customField is correct',
  );
}

Future testDeleteAssignWithExtraData() async {
  final task = await createTask();
  final createdRef = await Assign.create(
    task: task,
    assignTo: myUid!,
    extraData: {
      'customField': 'custom value',
    },
  );
  final createdAssign = await Assign.get(createdRef.id) as Assign;
  isTrue(createdAssign.taskId == task.id, 'Expect: Task id is correct');
  isTrue(createdAssign.assignTo == myUid, 'Expect: User id is correct');

  await createdAssign.delete();

  final tryRetrieveAssign = await Assign.get(createdAssign.id);

  isTrue(
    tryRetrieveAssign == null,
    'Expect: success on deleting assign with extra data as normal.',
  );
}

// Group =======================================

Future testGroupCreateAndRetrieveWithExtraData() async {
  // uidA is the one going to create a group
  final uidA = await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await TaskUserGroup.create(
    name: groupName,
    extraData: {
      'customField': 'custom value',
    },
  );

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

  isTrue(
    group.data['customField'] == 'custom value',
    'Expect: customField is correct',
  );
}

Future testGroupUpdateWithExtraData() async {
  // uidA is the one going to create a group
  final uidA = await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await TaskUserGroup.create(
    name: groupName,
    extraData: {
      'customField': 'custom value',
    },
  );

  final group = await TaskUserGroup.get(groupRef.id);

  const groupNameUpdated = 'No Longer the Best Group';

  await group!.update(
    name: groupNameUpdated,
    extraData: {
      'customField': 'new value',
    },
  );

  final updatedGroup = await TaskUserGroup.get(groupRef.id);

  isTrue(
    updatedGroup!.name == groupNameUpdated,
    'Expect: Updated Group must have same name',
  );

  isTrue(
    group.moderatorUsers.contains(uidA),
    'Expect: The moderator of the Group should not be affected',
  );

  isTrue(
    updatedGroup.data['customField'] == 'new value',
    'Expect: customField is correct',
  );
}

Future testDeleteGroupWithExtraData() async {
  // uidA is the one going to create a group
  await loginAsA();

  const groupName = 'The Best Group';

  final groupRef = await TaskUserGroup.create(
    name: groupName,
    extraData: {
      'customField': 'custom value',
    },
  );

  final group = await TaskUserGroup.get(groupRef.id);

  await group!.delete();

  final deleted = await TaskUserGroup.get(groupRef.id);
  isTrue(deleted == null,
      'Expect: TaskUserGroup.get() must return null after deleting group with extra data as normal.');
}
