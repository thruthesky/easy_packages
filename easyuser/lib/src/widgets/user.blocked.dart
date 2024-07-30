import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class UserBlocked extends StatelessWidget {
  const UserBlocked({
    super.key,
    required this.otherUid,
    required this.builder,
  });

  final String otherUid;
  final Widget Function(bool blocked) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: UserService.instance.blocks,
      stream: UserService.instance.blockChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }

        /// Got data from database
        Map<String, dynamic> blocks = snapshot.data as Map<String, dynamic>;

        return builder(blocks.containsKey(otherUid));
      },
    );
  }
}
