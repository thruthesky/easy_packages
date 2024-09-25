import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class UserSetting extends StatelessWidget {
  const UserSetting({
    super.key,
    required this.id,
    required this.builder,
    this.sync = true,
    this.onLoading,
  });

  final String id;
  final Widget Function(dynamic value, DatabaseReference ref) builder;
  final bool sync;
  final Widget? onLoading;

  @override
  Widget build(BuildContext context) {
    return Value(
      ref: FirebaseDatabase.instance.ref().child('settings').child(id),
      builder: (v, r) {
        return builder(v, r);
      },
      sync: sync,
      onLoading: onLoading,
    );
  }
}
