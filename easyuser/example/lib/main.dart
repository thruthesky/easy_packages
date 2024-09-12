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
<<<<<<< HEAD
      // options: DefaultFirebaseOptions.currentPlatform,
      );
=======
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp(
    name: 'withcenter-test-4',
    options: const FirebaseOptions(
      apiKey: 'AIzaSyC4JBZruWm7i8GI6W5Ge8HjXPN6LxEzZqM',
      appId: '1:109766947030:ios:ad65ec34614b14ea239977',
      messagingSenderId: '109766947030',
      projectId: 'withcenter-test-4',
      databaseURL: 'https://withcenter-test-4-default-rtdb.firebaseio.com',
      storageBucket: 'withcenter-test-4.appspot.com',
      iosBundleId: 'com.exam.banana.RunnerTests',
    ),
  );
>>>>>>> 897f133bde9bfc0f6410b83b8d907ae0bbcc90db
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
                final String uid = await UserTestService.instance.createTestUser();
                log('loginOrRegister uid: $uid');
              },
              child: const Text('loginOrRegister on 2nd Firebase'),
            ),
          ],
        ),
      ),
    );
  }
}
