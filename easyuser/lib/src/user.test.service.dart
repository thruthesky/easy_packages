import 'dart:math';

import 'package:easyuser/easyuser.dart';

class UserTestService {
  static UserTestService? _instance;
  static UserTestService get instance => _instance ??= UserTestService._();
  UserTestService._();

  Future<String> createTestUser() async {
    await loginOrRegister(
      email: '${Random().nextInt(999999)}@test.com',
      password: '12345a,*',
    );

    final String uid = UserService.instance.currentUser!.uid;
    print('uid: $uid');

    return uid;
  }
}
