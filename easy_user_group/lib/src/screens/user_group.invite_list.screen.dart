import 'package:easy_locale/easy_locale.dart';
import 'package:easy_user_group/easy_user_group.dart';
import 'package:easy_user_group/src/widgets/user_group.invitation.list_tile.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class UserGroupInviteListScreen extends StatelessWidget {
  const UserGroupInviteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task User group invite list'.t),
      ),
      body: myUid == null
          ? Center(child: Text('sign-in first'.t))
          : FirestoreListView(
              query: UserGroup.col
                  .where('invitedUsers', arrayContains: myUid)
                  .orderBy('updatedAt', descending: true),
              itemBuilder: (context, doc) {
                return UserGroupInvitationListTile(
                  userGroup: UserGroup.fromSnapshot(doc),
                );
              },
              emptyBuilder: (context) => Center(
                child: Text('Task user group invite list is empty'.t),
              ),
            ),
    );
  }
}
