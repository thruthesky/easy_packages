import 'package:example/screens/demo/login/email_login.screen.dart';
import 'package:example/screens/demo/login/login_layout.dart';
import 'package:example/screens/demo/login/verify_number_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class ComicLoginDemo extends StatefulWidget {
  static const String routeName = '/login_screen';

  const ComicLoginDemo({super.key});

  @override
  State<ComicLoginDemo> createState() => _ComicLoginDemoState();
}

class _ComicLoginDemoState extends State<ComicLoginDemo> {
  bool _isLoading = false;

  void _showCircularProgressIndicator() {
    setState(() {
      _isLoading = true;
    });

    // Hide the CircularProgressIndicator after 3 seconds
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = false;
      });

      _showDialog();
    });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) => Theme(
        data: ComicTheme.of(context),
        child: const Dialog(
          child: VerifyNumberDialog(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ComicTheme.of(context).copyWith(
        appBarTheme: const AppBarTheme(
          shape: Border(),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ComicTheme(
            child: LoginLayout(
              children: [
                TextField(
                  decoration: InputDecoration(
                      prefixIcon: SizedBox(
                        width: 0,
                        child: Center(
                          child: Text(
                            '+63',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ),
                      hintText: '9012345678',
                      label: const Text('Mobile'),
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    _showCircularProgressIndicator();
                  },
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator())
                      : const Text('Generate OTP'),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Text(' Or Sign in with '),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => EmailLoginScreen(
                              theme: ComicTheme.of(context).copyWith(
                                  appBarTheme: const AppBarTheme(
                                shape: Border(),
                              )),
                            )));
                  },
                  label: const Text('Email'),
                  icon: const Icon(Icons.email),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
