import 'package:easy_task/src/task.user_group.dart';
import 'package:flutter/material.dart';

class TaskUserGroupDoc extends StatelessWidget {
  const TaskUserGroupDoc({
    super.key,
    required this.userGroup,
    required this.builder,
    this.sync = false,
  });

  final TaskUserGroup userGroup;
  final bool sync;
  final Widget Function(TaskUserGroup) builder;

  @override
  Widget build(BuildContext context) {
    if (sync) {
      return StreamBuilder(
        initialData: userGroup,
        stream: userGroup.ref.snapshots().map(
              (snapshot) => TaskUserGroup.fromSnapshot(snapshot),
            ),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.hasData == false) {
            return const SizedBox.shrink();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return builder(snapshot.data!);
        },
      );
    }

    return FutureBuilder(
      initialData: userGroup,
      future: TaskUserGroup.get(userGroup.id),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return builder(snapshot.data!);
      },
    );
  }
}
