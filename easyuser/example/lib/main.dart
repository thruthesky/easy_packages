import 'dart:developer';
import 'dart:math' hide log;

import 'package:easy_locale/easy_locale.dart';
import 'package:example/firebase_options.dart';
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

    displayNameUpdateTest();
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
                          UserField(
                            uid: user.uid,
                            field: 'birthDay',
                            initialData: 4,
                            builder: (v, r) {
                              return ElevatedButton(
                                onPressed: () async {
                                  log('UserField(birthDay): ${r.path}');
                                  await r.set((v ?? 0) + 1);
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
            const Text('TESTs'),
            ElevatedButton(
                onPressed: () async {
                  log("Begin Test", name: '❗️');
                  final errors = await UserTestService.instance.test([
                    getDataTest,
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
            ElevatedButton(
              onPressed: () async {
                await UserService.instance.signOut();
                await UserTestService.instance.createTestUser();
              },
              child: const Text('Create a user'),
            ),
            ElevatedButton(
              onPressed: () async {},
              child: const Text('Anonymous sign in test'),
            ),
            ElevatedButton(
              onPressed: getDataTest,
              child: const Text('Get data'),
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
    debugPrint("Check if nulled: ${checkUpdate?.name ?? 'null'}");

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
