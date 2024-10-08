import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

/// [iam] and [i] are the simple aliases of UserService.instance
UserService get iam => UserService.instance;

/// [iam] and [i] are the simple aliases of UserService.instance
UserService get i => iam;

/// [my] returns [UserService.instnace.user] as [User].
///
/// Note that, the returned value is not nullable while
/// [UserService.instance.user] is nullable.
///
/// Note that, if [UserService.instance.initialized] is false or
/// [UserService.instance.user] is null, then it throws an exception.
///
User get my {
  if (UserService.instance.initialized == false) {
    throw Exception('UserService is not initialized');
  }
  if (UserService.instance.user == null) {
    throw 'user/not-logged-in UserService.instance.user is null. The user may be in the middle of login process. This may happens when the app booting or hot restarted. Or the user may not logged in. Or the user document does not exist.';
  }
  return iam.user as User;
}

/// [myUid] returns the current user's uid. It can be null.
///
/// Use [myUid] instead of 'my.uid' since 'my.uid' will be ready(loaded) much later than [myUid].
String? get myUid => FirebaseAuth.instance.currentUser?.uid;
