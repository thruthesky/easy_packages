import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_task/unit_tests/test_helper.functions.dart';

/// A simple email and password login form.
///
/// This widget is used to collect an email and password from the user and
/// then call the [onLogin] callback with the provided credentials.
///
/// There is only one button, "Login", which will call the [onLogin] callback
/// or the [onRegister] callback if provided.
///
/// If the [onRegister] callback is provided, [onLogin] will not be called when
/// the user registered.
///
class EmailPasswordLogin extends StatefulWidget {
  const EmailPasswordLogin({
    super.key,
    this.onLogin,
    this.padding,
  });

  final void Function()? onLogin;
  final EdgeInsets? padding;

  @override
  State<EmailPasswordLogin> createState() => _EmailPasswordLoginState();
}

class _EmailPasswordLoginState extends State<EmailPasswordLogin> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              label: Text("Email"),
              prefixIcon: Icon(
                Icons.email,
              ),
              hintText: 'Enter Email',
            ),
          ),
          TextField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: const InputDecoration(
              label: Text("Password"),
              prefixIcon: Icon(
                Icons.email,
              ),
              hintText: 'Enter Email',
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  log("Email: ${emailController.text}");
                  log("Password: ${passwordController.text}");

                  await loginOrRegister(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  widget.onLogin?.call();
                },
                child: const Text('Login'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  /// Get the credential only.
                  final credential = EmailAuthProvider.credential(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                  try {
                    /// link with current user.
                    await FirebaseAuth.instance.currentUser
                        ?.linkWithCredential(credential);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'email-already-in-use') {
                      await loginOrRegister(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    } else {
                      rethrow;
                    }
                  }
                },
                child: const Text('Link Currnet Accout'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
