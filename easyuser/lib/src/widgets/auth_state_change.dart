import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// AuthStateChanges
///
/// Use this widget to listen to the login user's authentication state changes
/// and rebuild the UI accordingly. It simply wraps
/// [FirebaseAuth.instance.authStateChanges] insdie a [StreamBuilder].
///
/// [builder] is the UI builder callback that will be called when the user's
/// authentication state changes.
///
class AuthStateChanges extends StatelessWidget {
  const AuthStateChanges({super.key, required this.builder});

  final Widget Function(User?) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        final user = snapshot.data;
        return builder(user);
      },
    );
  }
}
