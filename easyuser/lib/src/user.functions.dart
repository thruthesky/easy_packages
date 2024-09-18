import 'dart:convert';
import 'dart:math';

import 'package:easy_helpers/easy_helpers.dart';
import 'package:easyuser/easyuser.dart';

/// Login or register into Firebase auth
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
/// Note, it waits 3 seconds to update user data
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
    await UserService.instance.auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    /// TODO: This is notw orking. Fix to update user display name and photo url.
    Future.delayed(const Duration(seconds: 3)).then((v) {
      UserService.instance.user?.update(
        displayName: displayName ?? email,
        photoUrl: photoUrl ?? 'https://picsum.photos/id/1/200/200',
      );
    });
  } catch (e) {
    // create
    await UserService.instance.auth.createUserWithEmailAndPassword(email: email, password: password);
    return;
  }
}

/// Generates a random string with a length of [length].
randomString({int length = 10}) {
  final random = Random.secure();
  final values = List<int>.generate(length, (i) => random.nextInt(255));
  return base64Url.encode(values);
}

/// Let the user login as a random email creation.
Future randomLogin() async {
  final email = "${randomString()}@gmail.com";
  dog('msg: $email');
  final randomUser = await loginOrRegister(
    displayName: email,
    email: email,
    password: '12345a',
    photoUrl: 'https://picsum.photos/id/1/200/200',
  );
  return randomUser;
}
