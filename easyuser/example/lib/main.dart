import 'dart:developer';

import 'package:easy_locale/easy_locale.dart';
// import 'package:example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easyuser/easyuser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  lo.init();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
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
      body: Center(
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
                  UserService.instance.signOut();
                  await UserTestService.instance.createTestUser();
                },
                child: const Text('Create a user')),
            ElevatedButton(
              onPressed: displayNameUpdateTest,
              child: const Text('Update display name'),
            ),
          ],
        ),
      ),
    );
  }

  displayNameUpdateTest() async {
    final displayName = 'newName:${DateTime.now().millisecond}';
    UserService.instance.signOut();
    await UserTestService.instance.createTestUser();
    await waitUntil(() async => UserService.instance.user != null);
    await UserService.instance.user!.update(
      displayName: displayName,
    );
    final updated = await User.get(my.uid, cache: false);
    assert(updated!.displayName == displayName,
        "uid: ${my.uid}, updated name from Database: ${updated.displayName} vs displayName: $displayName");
  }
}
