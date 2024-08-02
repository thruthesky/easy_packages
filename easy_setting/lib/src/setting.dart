import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easysetting/easy_setting.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key, required this.id, required this.builder});

  final String id;
  final Widget Function(SettingModel) builder;

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  DocumentReference get ref =>
      FirebaseFirestore.instance.collection('settings').doc(widget.id);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // initialData: changes.value,
      stream: ref.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const CircularProgressIndicator.adaptive();
        }
        if (snapshot.hasError) {
          debugPrint("Error: ${snapshot.error}");
          return Text("Error: ${snapshot.error}");
        }

        return widget.builder(
          SettingModel.fromSnapshot(snapshot.data!),
        );
      },
    );
  }
}
