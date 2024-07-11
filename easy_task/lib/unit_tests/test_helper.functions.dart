import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide User;

String testName = '';
int testCount = 0;
int testCountSuccess = 0;
int testCountFailed = 0;

isTrue(bool re, String message) {
  testCount++;
  if (re) {
    testCountSuccess++;
    log(message, name: '🟢');
  } else {
    testCountFailed++;
    log(message, name: '❌');
  }
}

testStart(String name) {
  testName = name;
  testCount = 0;
  testCountSuccess = 0;
  testCountFailed = 0;

  log('-- Test Name : $testName --', name: 'BEGIN');
}

testReport() {
  log('-- Test Name : $testName --', name: '');
  log('Test Count: $testCount', name: '📊');
  log('Test Success: $testCountSuccess', name: '🟢');
  if (testCountFailed > 0) {
    log('Test Failed: $testCountFailed', name: '❌');
  } else {
    log('===== All test passed successfully =====', name: '😃');
  }
}

/// Login or register
///
/// Creates a user account if it's not existing.
///
/// [email] is the email of the user.
///
/// [password] is the password of the user.
///
/// [photoUrl] is the photo url of the user. If it's null, then it will be the default photo url.
///
/// [displayName] is the display name of the user. If it's null, then it will be the same as the email.
/// You can put empty string if you want to save it an empty stirng.
///
/// Logic:
/// Try to login with email and password.
///    -> If it's successful, return the user.
///    -> If it fails, create a new user with email and password.
///        -> If a new account is created, then update the user's display name and photo url.
///        -> And return the user.
///        -> If it's failed (to create a new user), throw an error.
///
/// ```dart
/// final email = "${randomString()}@gmail.com";
/// final randomUser = await Test.loginOrRegister(
///     displayName: email,
///     email: email,
///     password: '123456',
///     photoUrl: 'https://picsum.photos/id/1/200/200'
/// );
/// ```
///
/// Return the user object of firebase auth and whether the user is registered or not.
Future loginOrRegister({
  required String email,
  required String password,
  String? photoUrl,
  String? displayName,
}) async {
  try {
    // login
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } catch (e) {
    // create
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return;
  }
}

Future<String> testLoginAs({
  required String email,
  required String password,
}) async {
  await loginOrRegister(email: email, password: password);
  // return await User.get(FirebaseAuth.instance.currentUser!.uid) as User;
  return FirebaseAuth.instance.currentUser!.uid;
}

Future<void> testLogout() async {
  await signOut();
}

Future<String> loginAsA() async {
  const email = "test-user-a@email.com";
  const password = "12345,*";
  return await testLoginAs(email: email, password: password);
}

Future<String> loginAsB() async {
  const email = "test-user-b@email.com";
  const password = "12345,*";
  return await testLoginAs(email: email, password: password);
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}
