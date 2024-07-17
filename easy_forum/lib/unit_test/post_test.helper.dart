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

// use this to check if the code will return un exception
// if return an exception it is consider  a success
Future<void> isException(Future<void> Function() action) async {
  testCount++;

  try {
    await action();
    // If no exception, log success (optional)
    testCountFailed++;
    log('No exception occurred', name: '❌');
  } catch (e) {
    testCountSuccess++;
    log('Exception: $e', name: '🟢');
  }
  return;
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
