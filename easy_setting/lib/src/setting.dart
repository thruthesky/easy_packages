import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class Setting {
  final String id;
  DocumentReference get ref =>
      FirebaseFirestore.instance.collection('settings').doc(id);
  Map<String, dynamic> data;
  Setting({
    required this.id,
    this.data = const {},
  });

  factory Setting.fromSnapshot(DocumentSnapshot snapshot) {
    return Setting.fromJson(
      snapshot.data() as Map<String, dynamic>,
      snapshot.id,
    );
  }

  factory Setting.fromJson(Map<String, dynamic> json, String id) {
    return Setting(
      id: id,
      data: json,
    );
  }

  Map<String, dynamic> toJson() {
    return data;
  }

  Object get(String key) {
    return data[key];
  }

  Future set(String key, Object value) async {
    data[key] = value;
    await ref.set(data);
  }

  /// Setting subscription
  ///
  /// This is used to listen the setting document changes.
  ///
  /// The reason why it is not in the service is because each setting can
  /// have its own listener for realtime update.
  /// For instance, an app can have a system setting, and a user setting, and
  /// a chat setting at the same time. It can support multiple setting
  /// subscriptions.
  ///
  StreamSubscription? settingSubscription;
  BehaviorSubject<Setting?> changes = BehaviorSubject.seeded(null);

  listen() {
    settingSubscription?.cancel();
    changes.add(this);
    settingSubscription = ref.snapshots().listen((snapshot) {
      if (!snapshot.exists) {
        data = {};
        changes.add(null);
        return;
      }
      data = snapshot.data() as Map<String, dynamic>;
      changes.add(this);
    });
  }

  dispose() {
    settingSubscription?.cancel();
  }

  StreamBuilder<Setting?> builder(Widget Function(Setting setting) builder) {
    return StreamBuilder<Setting?>(
      initialData: changes.value,
      stream: changes.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          debugPrint("Error: ${snapshot.error}");
          return Text("Error: ${snapshot.error}");
        }
        return builder(snapshot.data!);
      },
    );
  }
}
