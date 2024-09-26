import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// UserSetting builds (or rebuilds) widget based on the user setting.
///
/// [field] is the field in the user setting. If null, it will build the widget
/// based on the user setting. If not null, it will build the widget based on the
/// field in the user setting.
///
class UserSetting extends StatelessWidget {
  const UserSetting({
    super.key,
    this.field,
    required this.builder,
    this.sync = true,
    this.onLoading,
  });

  final String? field;
  final Widget Function(dynamic value, DatabaseReference ref) builder;
  final bool sync;
  final Widget? onLoading;

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('user_settings').child(
          FirebaseAuth.instance.currentUser!.uid,
        );
    if (field != null) {
      ref = ref.child(field!);
    }
    return Value(
      ref: ref,
      builder: (v, r) {
        return builder(v, r);
      },
      sync: sync,
      onLoading: onLoading,
    );
  }
}
