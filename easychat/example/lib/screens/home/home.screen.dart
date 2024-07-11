import 'package:flutter/material.dart';
import 'package:easyuser/easyuser.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/Home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          const Text("Home"),
          AuthStateChanges(builder: (user) {
            return user == null
                ? const EmailPasswordLogin()
                : Column(
                    children: [
                      Text("Welcome ${user.uid}"),
                      ElevatedButton(
                        onPressed: () async {
                          await i.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  );
          }),
        ],
      ),
    );
  }
}
