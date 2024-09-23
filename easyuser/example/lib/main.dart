import 'dart:developer';
import 'dart:math' hide log;

import 'package:easy_locale/easy_locale.dart';
import 'package:example/firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
// import 'package:example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easyuser/easyuser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  lo.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String firebaseAppName = '[DEFAULT]';
  @override
  void initState() {
    super.initState();
    UserService.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AuthStateChanges(
              builder: (user) {
                return user == null
                    ? const EmailPasswordLogin()
                    : Column(
                        children: [
                          Text('User UID: ${user.uid}'),
                          ElevatedButton(
                            onPressed: () => UserService.instance.showProfileUpdaeScreen(context),
                            child: const Text('Profile update'),
                          ),
                          ElevatedButton(
                            onPressed: () => i.signOut(),
                            child: const Text('Sign out'),
                          ),
                          UserField<int?>(
                            uid: user.uid,
                            field: 'birthDay',
                            builder: (v) {
                              return ElevatedButton(
                                onPressed: () async {
                                  // log('UserField(birthDay): ${r.path}');
                                  // await r.set((v ?? 0) + 1);
                                  final easyUser = await User.get(user.uid);
                                  log('UserField(birthDay): ${easyUser?.ref.child(User.field.birthDay).path}');
                                  easyUser?.ref.child(User.field.birthDay).set((v ?? 0) + 1);
                                },
                                child: Text('UserField(birthDay): $v'),
                              );
                            },
                          ),
                        ],
                      );
              },
            ),
            ElevatedButton(
              onPressed: () {
                UserService.instance.showSearchDialog(
                  context,
                  exactSearch: true,
                );
              },
              child: const Text('User Search Dialog'),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                await UserService.instance.showProfileUpdaeScreen(context);
              },
              child: const Text("Update Profile"),
            ),
            const Divider(),
            const Text('TESTS'),
            ElevatedButton(
                onPressed: () async {
                  log("Begin Test", name: '❗️');
                  final errors = await UserTestService.instance.test([
                    getDataTest,
                    recordPhoneSignInNumberTest,
                    alreadyRegisteredPhoneNumberTest,
                    anonymousSignInTest,
                    displayNameUpdateTest,
                    nameUpdateTest,
                    yearUpdate,
                    birthMonthUpdate,
                    birthDayUpdate,
                    genderUpdate,
                    photoUrlUpdate,
                    stateMessageUpdate,
                    statePhotoUrlUpdate,
                    userDeletetest,
                    userResigntest,
                  ]);

                  debugPrint(
                    "Errors: ${errors.length}",
                  );
                  for (String e in errors) {
                    log(
                      "Error: $e",
                      name: '❌',
                    );
                  }
                },
                child: const Text('TEST ALL')),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                final refTest = FirebaseDatabase.instance.ref().child("test").child(myUid!);
                await refTest.set({
                  "field1": "val1",
                  "field2": "val2",
                  "field3": "val3",
                });

                debugPrint("==============");
                debugPrint("==============");
                debugPrint("Getting using Get: ");
                final getValue = await refTest.child("field1").get();
                debugPrint("Get Value: ${getValue.value}");
                debugPrint("Getting using Once: ");
                final onceValue = await refTest.child("field1").once();
                debugPrint("Once Value: ${onceValue.snapshot.value}");
                debugPrint("==============");
                debugPrint("Getting null using Get: ");
                final getNullValue = await refTest.child("nullField").get();
                debugPrint("Get Null Value: ${getNullValue.value}");
                debugPrint("Getting null using Once: ");
                final onceNullValue = await refTest.child("nullField").once();
                debugPrint("Once Null Value: ${onceNullValue.snapshot.value}");
              },
              child: const Text("Firebase Get vs Once"),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: recordPhoneSignInNumberTest,
              child: const Text("Record Phone Number Test"),
            ),
            ElevatedButton(
              onPressed: alreadyRegisteredPhoneNumberTest,
              child: const Text("Already Registered Phone Number Test"),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                await UserService.instance.signOut();
                await UserTestService.instance.createTestUser();
              },
              child: const Text('Create a user'),
            ),
            ElevatedButton(
              onPressed: deleteFieldTest,
              child: const Text('Delete Field Test'),
            ),
            ElevatedButton(
              onPressed: anonymousSignInTest,
              child: const Text('Anonymous sign in test'),
            ),
            ElevatedButton(
              onPressed: blockUserTest,
              child: const Text('Block user test'),
            ),
            ElevatedButton(
              onPressed: getDataTest,
              child: const Text('Get data'),
            ),
            ElevatedButton(
              onPressed: getFieldTest,
              child: const Text('Get field'),
            ),
            ElevatedButton(
              onPressed: displayNameUpdateTest,
              child: const Text('Update display name'),
            ),
            ElevatedButton(
              onPressed: displayNameUpdateTest,
              child: const Text('Update name'),
            ),
            ElevatedButton(
              onPressed: yearUpdate,
              child: const Text('Update birthYear'),
            ),
            ElevatedButton(
              onPressed: birthMonthUpdate,
              child: const Text('Update birthMonth'),
            ),
            ElevatedButton(
              onPressed: birthDayUpdate,
              child: const Text('Update birthDay'),
            ),
            ElevatedButton(
              onPressed: genderUpdate,
              child: const Text('Update gender'),
            ),
            ElevatedButton(
              onPressed: photoUrlUpdate,
              child: const Text('Update photoUrl'),
            ),
            ElevatedButton(
              onPressed: stateMessageUpdate,
              child: const Text('Update stateMessage'),
            ),
            ElevatedButton(
              onPressed: statePhotoUrlUpdate,
              child: const Text('Update statePhotoUrl'),
            ),
            ElevatedButton(
              onPressed: statePhotoUrlUpdate,
              child: const Text('Update statePhotoUrl'),
            ),
            ElevatedButton(
              onPressed: userDeletetest,
              child: const Text("Delete user"),
            ),
            ElevatedButton(
              onPressed: userResigntest,
              child: const Text("Resign user"),
            ),
            const SafeArea(
              child: SizedBox(
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const phoneNumber = "+11111111111";
  PhoneAuthCredential? _phoneAuthCredential;

  _logInAs11111111111() async {
    const verificationCode = "111111";

    // Step 1: Sign out any previous session
    await UserService.instance.signOut();

    // Step 2: Start phone number verification
    await FirebaseAuth.instance.verifyPhoneNumber(
      // ignore: invalid_use_of_visible_for_testing_member
      autoRetrievedSmsCodeForTesting: verificationCode,
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification can be handled here
        await FirebaseAuth.instance.signInWithCredential(credential);
        debugPrint('Auto-sign in completed');
      },
      verificationFailed: (FirebaseAuthException error) {
        debugPrint('Verification failed: ${error.message}');
      },
      codeSent: (String verificationId, int? resendToken) async {
        debugPrint('Code sent. Please enter the verification code.');

        // Wait for the code to be sent and verificationId to be set
        // Step 3: Manually sign in using the verification code and verificationId
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: verificationCode,
        );

        // Sign in with the credential
        await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

        debugPrint('Phone number successfully verified and signed in.');

        _phoneAuthCredential = phoneAuthCredential;
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        debugPrint('Auto retrieval timeout. Manual sign-in required.');
        // Wait for the code to be sent and verificationId to be set
        // Step 3: Manually sign in using the verification code and verificationId
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: verificationCode,
        );

        // Sign in with the credential
        await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);

        _phoneAuthCredential = phoneAuthCredential;
      },
      timeout: const Duration(seconds: 120), // Set the timeout duration
    );
  }

  bool checkTimeWithin30Seconds(int timestamp, int timestamp2) {
    final difference = (timestamp - timestamp2).abs();
    // 30 seconds = 30 * 1000 milliseconds
    if (difference <= 30 * 1000) {
      debugPrint("The timestamp is within 30 seconds of the current time.");
      return true;
    } else {
      debugPrint("The timestamp is not within 30 seconds of the current time.");
      return false;
    }
  }

  recordPhoneSignInNumberTest() async {
    await UserService.instance.signOut();

    // To clear the user-phone-sign-in-numbers node
    await UserService.instance.database.ref('user-phone-sign-in-numbers').set(null);

    await _logInAs11111111111();

    await waitUntil(() async => UserService.instance.user != null);
    final timeNow = DateTime.now().millisecondsSinceEpoch;

    debugPrint("Is it recorded? ${await UserService.instance.isPhoneNumberRegistered(phoneNumber)}");

    final checkRecord = await UserService.instance.database
        .ref()
        .child('user-phone-sign-in-numbers')
        .child(phoneNumber)
        .child("lastSignedInAt")
        .get();

    debugPrint("Last Signed in at: ${checkRecord.value}");

    assert(checkRecord.value != null, "recordPhoneSignInNumberTest: The phone sign in was not recorded.");

    final lastSignedInAt = checkRecord.value as int;

    debugPrint("lastSignedInAt $lastSignedInAt");

    assert(
      checkTimeWithin30Seconds(lastSignedInAt, timeNow),
      "recordPhoneSignInNumberTest: It's either delayed, or not recorded with correct time. Difference: ${(lastSignedInAt - timeNow).abs()}",
    );
  }

  alreadyRegisteredPhoneNumberTest() async {
    // There is no linkingAuthToAnonymous in User Service dart.

    Object? error;
    try {
      // SignOut
      await UserService.instance.signOut();

      // Login anonymously
      await UserService.instance.initAnonymousSignIn();

      // Login as 111 and link
      await _logInAs11111111111();

      await waitUntil(() async => UserService.instance.user != null);
      await FirebaseAuth.instance.currentUser?.linkWithCredential(_phoneAuthCredential!);

      // Sign Out
      await UserService.instance.signOut();

      // Login anonymously
      await UserService.instance.initAnonymousSignIn();

      // Login as 111 and link
      await _logInAs11111111111();

      // Login as 111 and link
      await waitUntil(() async => UserService.instance.user != null);
      await FirebaseAuth.instance.currentUser?.linkWithCredential(_phoneAuthCredential!);
    } catch (e) {
      error = e;
    }
    assert(error == null, "alreadyRegisteredPhoneNumberTest: There is an error: $error");

    if (error == null) {
      log("No error", name: '🟢');
    } else {
      log("ERROR", name: '🔴');
      debugPrint(error.toString());
    }
  }

  deleteFieldTest() async {
    await UserService.instance.signOut();
    final uid1 = await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    await Future.delayed(const Duration(milliseconds: 500));

    const testDisplayNameVal = "Test Display Name";
    const testNameVal = "Test Name";

    await my.update(
      displayName: testDisplayNameVal,
      name: testNameVal,
    );

    final myDataUpdate = await User.get(uid1, cache: false);

    assert(
      myDataUpdate?.displayName == testDisplayNameVal,
      "deleteFieldTest: Something went wrong in the middle of testing",
    );
    assert(
      myDataUpdate?.name == testNameVal,
      "deleteFieldTest: Something went wrong in the middle of testing",
    );

    await my.deleteFields([User.field.displayName]);

    await Future.delayed(const Duration(milliseconds: 500));

    final displayNameUpdate = await User.getField(uid: uid1, field: User.field.displayName, cache: false);
    debugPrint("displayNameUpdate: $displayNameUpdate");
    final nameUpdate = await User.getField(uid: uid1, field: User.field.name, cache: false);

    assert(
      displayNameUpdate == null,
      "deleteFieldTest: Display name SHOULD be deleted",
    );

    assert(
      nameUpdate == testNameVal,
      "deleteFieldTest: Name field should NOT be deleted",
    );
  }

  anonymousSignInTest() async {
    await UserService.instance.signOut();
    final originalSetup = UserService.instance.enableAnonymousSignIn;
    UserService.instance.enableAnonymousSignIn = true;
    await UserService.instance.initAnonymousSignIn();

    await waitUntil(() async => UserService.instance.user != null);

    // final getMy = await User.get(my.uid, cache: false);

    UserService.instance.enableAnonymousSignIn = originalSetup;

    assert(
      i.anonymous,
      "anonymousSignInTest: Unable to login as anonymous",
    );
  }

  blockUserTest() async {
    UnimplementedError("Unable to Unit test because of confirmation");

    // User 1
    await UserService.instance.signOut();
    final uid1 = await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);

    // User 2
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    if (!context.mounted || !mounted) return;

    // Block user 1
    await UserService.instance.block(context: context, otherUid: uid1);

    assert(
      UserService.instance.blocks.containsKey(uid1),
      "blockUserTest: Unable to block user 1, uid: $uid1, myUid: ${my.uid}",
    );
  }

  getDataTest() async {
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);

    final getMy = await User.get(my.uid, cache: false);
    assert(
      getMy != null,
      "getDataTest: User.get failed to get my User",
    );
  }

  getFieldTest() async {
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);

    await Future.delayed(const Duration(milliseconds: 500));

    await UserService.instance.usersRef.child(myUid!).child("testField").set("testing");

    final testField = await User.getField(uid: myUid!, field: "testField");

    debugPrint("testField: $testField");

    final testfield2Once = await FirebaseDatabase.instance.ref("users").child(myUid!).child("testField").once();

    debugPrint("testField2: ${testfield2Once.snapshot.value}");

    final testfield2Get = await FirebaseDatabase.instance.ref("users").child(myUid!).child("testField").get();

    debugPrint("testField2: ${testfield2Get.value}");
  }

  displayNameUpdateTest() async {
    final displayName = 'newDisplayName:${DateTime.now().millisecond}';
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    await UserService.instance.user!.update(
      displayName: displayName,
    );
    final updated = await User.get(my.uid, cache: false);
    assert(
      updated!.displayName == displayName,
      "uid: ${my.uid}, updated displayName from Database: ${updated.displayName} vs displayName: $displayName",
    );
  }

  nameUpdateTest() async {
    final name = 'newName:${DateTime.now().millisecond}';
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    await UserService.instance.user!.update(
      name: name,
    );
    final updated = await User.get(my.uid, cache: false);
    assert(
      updated!.name == name,
      "nameUpdateTest: uid: ${my.uid}, updated name from Database: ${updated.name} vs name: $name",
    );
  }

  yearUpdate() async {
    final newBirthYear = DateTime.now().millisecond;
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    await UserService.instance.user!.update(
      birthYear: newBirthYear,
    );
    final updated = await User.get(my.uid, cache: false);
    assert(
      updated!.birthYear == newBirthYear,
      "yearUpdate: uid: ${my.uid}, updated birthYear from Database: ${updated.birthYear} vs newBirthYear: $newBirthYear",
    );
  }

  birthMonthUpdate() async {
    final newBirthMonth = DateTime.now().millisecond;
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    await UserService.instance.user!.update(
      birthMonth: newBirthMonth,
    );
    final updated = await User.get(my.uid, cache: false);
    assert(
      updated!.birthMonth == newBirthMonth,
      "birthMonthUpdate: uid: ${my.uid}, updated birthMonth from Database: ${updated.birthMonth} vs newBirthMonth: $newBirthMonth",
    );
  }

  birthDayUpdate() async {
    final newBirthDay = DateTime.now().millisecond;
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    await UserService.instance.user!.update(
      birthDay: newBirthDay,
    );
    final updated = await User.get(my.uid, cache: false);
    assert(
      updated!.birthDay == newBirthDay,
      "birthDayUpdate: uid: ${my.uid}, updated birthDay from Database: ${updated.birthDay} vs newBirthDay: $newBirthDay",
    );
  }

  genderUpdate() async {
    final newGender = ['M', 'F'][Random().nextInt(2)];
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    await UserService.instance.user!.update(
      gender: newGender,
    );
    final updated = await User.get(my.uid, cache: false);
    assert(
      updated!.gender == newGender,
      "genderUpdate: uid: ${my.uid}, updated gender from Database: ${updated.gender} vs newGender: $newGender",
    );
  }

  photoUrlUpdate() async {
    final photoUrl = 'photoUrl:${DateTime.now().millisecond}';
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    await UserService.instance.user!.update(
      photoUrl: photoUrl,
    );
    final updated = await User.get(my.uid, cache: false);
    assert(
      updated!.photoUrl == photoUrl,
      "photoUrlUpdate: uid: ${my.uid}, updated photoUrl from Database: ${updated.photoUrl} vs newGender: $photoUrl",
    );
  }

  stateMessageUpdate() async {
    final stateMessage = 'stateMessage:${DateTime.now().millisecond}';
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    await UserService.instance.user!.update(
      stateMessage: stateMessage,
    );
    final updated = await User.get(my.uid, cache: false);
    assert(
      updated!.stateMessage == stateMessage,
      "stateMessageUpdate: uid: ${my.uid}, updated stateMessage from Database: ${updated.stateMessage} vs stateMessage: $stateMessage",
    );
  }

  statePhotoUrlUpdate() async {
    final statePhotoUrl = 'statePhotoUrl:${DateTime.now().millisecond}';
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    await UserService.instance.user!.update(
      statePhotoUrl: statePhotoUrl,
    );
    final updated = await User.get(my.uid, cache: false);
    assert(
      updated!.statePhotoUrl == statePhotoUrl,
      "statePhotoUrlUpdate: uid: ${my.uid}, updated statePhotoUrl from Database: ${updated.statePhotoUrl} vs statePhotoUrl: $statePhotoUrl",
    );
  }

  userDeletetest() async {
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    final myUid = my.uid;

    await UserService.instance.user!.update(
      name: "test name",
    );
    final checkUpdate = await User.get(myUid, cache: false);
    debugPrint("Check if Updated: ${checkUpdate?.name ?? 'null'}");
    await UserService.instance.user!.delete();
    final deleted = await User.get(myUid, cache: false);
    debugPrint("Check if nulled: ${deleted?.name ?? 'null'}");
    assert(
      deleted == null,
      "userDeletetest: uid: $myUid, deleted from Database: $deleted",
    );
  }

  userResigntest() async {
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);

    await UserService.instance.user!.update(
      name: "test name",
    );

    final oldUid = my.uid;
    final checkUpdate = await User.get(oldUid, cache: false);
    debugPrint("Check if Updated: ${checkUpdate?.name ?? 'null'}");

    debugPrint("Resigning user: ${i.auth.currentUser?.uid}");
    await UserService.instance.resign();

    // Check if deleted
    await UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    final deleted = await User.get(oldUid, cache: false);
    assert(
      deleted == null,
      "userResignTest: uid: $oldUid, deleted from Database: $deleted",
    );
  }
}
