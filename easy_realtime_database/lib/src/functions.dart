import 'package:firebase_database/firebase_database.dart';

/// Toogle a node value
///
/// By default, it will set true if the value does not exist. if the value
/// exists, it will remove the value.
///
/// If [value] is given, then it will set it as the node value. or `true`
/// will be set.
///
/// Returns true if the node is created, otherwise false.
Future<bool> toggle(
  DatabaseReference ref, [
  dynamic value,
]) async {
  final snapshot = await ref.get();

  if (snapshot.exists == false) {
    await ref.set(value ?? true);
    return true;
  } else {
    await ref.remove();
    return false;
  }
}
