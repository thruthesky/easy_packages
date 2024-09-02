import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_user_group/easy_user_group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// User group service
///
/// User service is a helper class that will be used to manage and service the management system.
class UserGroupService {
  static UserGroupService? _instance;
  static UserGroupService get instance => _instance ??= UserGroupService._();

  UserGroupService._() {
    dog('UserGroupService is created');
    addUserGroupLocaleTexts();
  }

  CollectionReference col =
      FirebaseFirestore.instance.collection('user-groups');
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Function? setLocaleTexts;

  bool initialized = false;
  init({
    Function? setLocaleTexts,
  }) {
    initialized = true;
    this.setLocaleTexts = setLocaleTexts;
  }

  /// Show the user group list screen.
  showUserGroupListScreen(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return const UserGroupListScreen();
      },
    );
  }

  showUserGroupCreateScreen(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return const UserGroupCreateScreen();
      },
    );
  }

  showUserGroupDetailScreen(BuildContext context, UserGroup userGroup) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, __, ___) {
        return UserGroupDetailScreen(userGroup: userGroup);
      },
    );
  }

  showUserGroupEditScreen(BuildContext context, UserGroup userGroup) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return UserGroupEditScreen(userGroup: userGroup);
      },
    );
  }

  showUserGroupInviteListScreen(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return const UserGroupInviteListScreen();
      },
    );
  }
}
