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
