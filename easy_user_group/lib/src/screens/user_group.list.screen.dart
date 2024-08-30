import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_user_group/easy_user_group.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

class UserGroupListScreen extends StatefulWidget {
  static const String routeName = '/TaskUserGroupList';
  const UserGroupListScreen({super.key});

  @override
  State<UserGroupListScreen> createState() => _UserGroupListScreenState();
}

class _UserGroupListScreenState extends State<UserGroupListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Group List'.t),
        actions: [
          IconButton(
            onPressed: () {
              UserGroupService.instance.showUserGroupCreateScreen(context);
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
              onPressed: () {
                UserGroupService.instance
                    .showUserGroupInviteListScreen(context);
              },
              icon: const Icon(Icons.list_alt_sharp)),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: FirestoreListView(
        query: UserGroup.col.where(
          'users',
          arrayContains: UserGroupService.instance.currentUser!.uid,
        ),
        itemBuilder: (_, snapshot) {
          final userGroup = UserGroup.fromSnapshot(snapshot);
          return UserGroupListTile(userGroup: userGroup);
        },
        emptyBuilder: (context) => Center(
          child: Text('user group list is empty'.t),
        ),
        errorBuilder: (context, error, stackTrace) {
          dog('error: $error');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('An error occurred;\n$error'),
              ],
            ),
          );
        },
      ),
    );
  }
}
