import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserChange extends StatelessWidget {
  /// UserChange
  ///
  /// Use this widget to listen to the user state (signed-in, signed-out, different user & token refresh)
  /// ex: linking credential
  /// and rebuild the UI accordingly. It simply wraps
  /// [FirebaseAuth.instance.userChanges] insdie a [StreamBuilder].
  ///
  /// [builder] is the UI builder callback that will be called when the user's
  /// authentication state changes.
  ///
  /// *IMPORTANT: It doesn't rebuild on FirebaseAuth.instance.signInAnonymously
  ///
  const UserChange({super.key, required this.builder});

  final Widget Function(User?) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // To reduce the flickering
      initialData: FirebaseAuth.instance.currentUser,

      /// to listen not only to user login logout
      /// but other changes like when the user auth change or link credential
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && snapshot.hasData == false) {
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
