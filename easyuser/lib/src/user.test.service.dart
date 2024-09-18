import 'dart:async';
import 'dart:math';

import 'package:easyuser/easyuser.dart';

class UserTestService {
  static UserTestService? _instance;
  static UserTestService get instance => _instance ??= UserTestService._();
  UserTestService._();

  Future<String> createTestUser() async {
    /// Create a new user
    await loginOrRegister(
      email: '${Random().nextInt(999999)}@test.com',
      password: '12345a,*',
    );

    /// Check if the data is created in database.
    await waitUntil(
      () async {
        final user = await User.get(UserService.instance.currentUser!.uid);
        return user != null;
      },
      timeout: 5000,
      interval: 800,
    );

    final String uid = UserService.instance.currentUser!.uid;
    print('uid: $uid');

    return uid;
  }
}

/// Wait until the condition is true.
/// The condition is a Future callback-function that returns a boolean.
/// The default timeout is 10 seconds and the default interval is 1 second.
/// If the condition is not met within the timeout, it will throw a TimeoutException.
/// If the Future callback-function throws an error, it will be caught and printed.
waitUntil(Future<bool> Function() condition, {int timeout = 10000, int interval = 1000}) async {
  final int start = DateTime.now().millisecondsSinceEpoch;
  try {
    while (!(await condition())) {
      print('---> waitUntil() return false;');
      if (DateTime.now().millisecondsSinceEpoch - start > timeout) {
        throw TimeoutException('Test failed due to timeout. waitUntil()');
      }
      await Future.delayed(Duration(milliseconds: interval));
    }
  } catch (e) {
    print('---> try/catch error on waitUntil: $e');
  }
}
