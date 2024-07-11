import 'package:easy_helpers/easy_helpers.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';

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
            decoration: InputDecoration(
              label: Text('emAIL'.t),
              prefixIcon: const Icon(
                Icons.email,
              ),
              hintText: 'input email'.t,
            ),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.lock,
              ),
              label: Text('password'.t),
              hintText: 'input password'.t,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  dog("Email: ${emailController.text}");
                  dog("Password: ${passwordController.text}");

                  if (emailController.text.trim().isEmpty) {
                    throw Exception(
                      'input-email/Input email to login',
                    );
                  } else if (passwordController.text.trim().isEmpty) {
                    throw Exception(
                      'input-password/Input password to login',
                    );
                  }

                  await loginOrRegister(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  widget.onLogin?.call();
                },
                child: Text('login'.toUpperCase()),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () async {
                  /// Get the credential only.
                  dog('Get credential only without login');
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
                      dog('The email is already in use -> Try to sign-in with the email and password.');
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
