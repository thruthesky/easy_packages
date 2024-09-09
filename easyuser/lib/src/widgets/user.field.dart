import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// Listens the change of the field of user data in Realtime Database and
/// rebuild the widget
///
class UserField extends StatelessWidget {
  const UserField({
    super.key,
    required this.uid,
    this.initialData,
    required this.field,
    required this.builder,
    this.sync = true,
  });

  final String uid;
  final dynamic initialData;
  final String field;
  final Widget Function(dynamic, DatabaseReference) builder;
  final bool sync;

  @override
  Widget build(BuildContext context) {
    if (sync) {
      return Value(
        ref: UserService.instance.mirrorUsersRef.child(uid).child(field),
        initialData: initialData,
        builder: (value, ref) {
          return builder(value, ref);
        },
      );
    } else {
      return Value.once(
        ref: UserService.instance.mirrorUsersRef.child(uid).child(field),
        initialData: initialData,
        builder: (value, ref) {
          return builder(value, ref);
        },
      );
    }
  }
}
