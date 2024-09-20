import 'package:flutter/material.dart';
import 'package:easyuser/easyuser.dart';

void main() {
  runApp(const MyApp());
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
                child: Column(
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
    );
  }
}
