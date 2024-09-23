import 'package:example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easyuser/easyuser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen'),
      ),
      body: AuthStateChanges(
        builder: (user) => user == null
            ? const Center(
                child: EmailPasswordLogin(),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          UserService.instance.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                      Text(user.uid),

                      // ElevatedButton(onPressed: onPressed, child: Text('Create Post')),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
