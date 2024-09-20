import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// TODO: move it to realtime database
class Setting extends StatelessWidget {
  const Setting({
    super.key,
    required this.id,
    required this.builder,
  });

  final String id;
  final Widget Function(dynamic value, DatabaseReference ref) builder;

  @override
  Widget build(BuildContext context) {
    return Value(
      ref: FirebaseDatabase.instance.ref().child('settings').child(id),
      builder: (v, r) {
        return builder(v, r);
      },
    );
  }
}
