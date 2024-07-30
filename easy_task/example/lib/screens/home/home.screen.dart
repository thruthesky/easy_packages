import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:flutter/material.dart';
import 'package:easyuser/easyuser.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  fa.User? get user => fa.FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.fact_check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AuthStateChanges(
          builder: (user) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (user == null) ...[
                  EmailPasswordLogin(
                    onLogin: () {
                      if (!context.mounted) return;
                      setState(() {});
                    },
                  ),
                ] else ...[
                  Text("Display Name: ${user.displayName}"),
                  Text("UID: ${user.uid}"),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
