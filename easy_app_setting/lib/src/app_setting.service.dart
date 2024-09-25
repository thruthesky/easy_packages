import 'package:firebase_database/firebase_database.dart';

class AppSettingService {
  static AppSettingService? _instance;
  static AppSettingService get instance => _instance ??= AppSettingService._();
  AppSettingService._();

  final FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference get ref => database.ref().child('app-settings');

  Future update(String k, dynamic v) async {
    await ref.child(k).update(v);
  }

  Future<dynamic> get(String k) async {
    final snapshot = await ref.child(k).get();
    return snapshot.value;
  }
}
