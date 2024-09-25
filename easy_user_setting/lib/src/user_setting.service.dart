import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserSettingService {
  static UserSettingService? _instance;
  static UserSettingService get instance => _instance ??= UserSettingService._();
  UserSettingService._();

  final FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference get ref => database.ref().child('user-settings');

  String get uid => FirebaseAuth.instance.currentUser!.uid;

  Future update(String k, dynamic v) async {
    await ref.child(uid).child(k).update(v);
  }

  Future<dynamic> get(String k) async {
    final snapshot = await ref.child(uid).child(k).get();
    return snapshot.value;
  }
}
