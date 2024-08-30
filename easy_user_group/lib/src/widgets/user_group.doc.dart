import 'package:easy_user_group/src/user_group.dart';
import 'package:flutter/material.dart';

class UserGroupDoc extends StatelessWidget {
  const UserGroupDoc({
    super.key,
    required this.userGroup,
    required this.builder,
    this.sync = false,
  });

  final UserGroup userGroup;
  final bool sync;
  final Widget Function(UserGroup) builder;

  @override
  Widget build(BuildContext context) {
    if (sync) {
      return StreamBuilder(
        initialData: userGroup,
        stream: userGroup.ref.snapshots().map(
              (snapshot) => UserGroup.fromSnapshot(snapshot),
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
      future: UserGroup.get(userGroup.id),
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
