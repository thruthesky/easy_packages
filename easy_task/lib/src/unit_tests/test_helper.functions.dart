import 'dart:developer';

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

// Future<String> testLoginAs({
//   required String email,
//   required String password,
// }) async {
//   await loginOrRegister(email: email, password: password);
//   // return await User.get(FirebaseAuth.instance.currentUser!.uid) as User;
//   return FirebaseAuth.instance.currentUser!.uid;
// }

// Future<void> testLogout() async {
//   await UserService.instance.signOut();
// }

// Future<String> loginAsA() async {
//   const email = "test-user-a@email.com";
//   const password = "12345,*";
//   return await testLoginAs(email: email, password: password);
// }

// Future<String> loginAsB() async {
//   const email = "test-user-b@email.com";
//   const password = "12345,*";
//   return await testLoginAs(email: email, password: password);
// }
