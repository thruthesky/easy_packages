import 'package:example/screens/demo/login/email_login.screen.dart';
import 'package:example/screens/demo/login/login_layout.dart';
import 'package:example/screens/demo/login/verify_number_dialog.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class SleekLoginDemo extends StatefulWidget {
  static const String routeName = '/login_screen';

  const SleekLoginDemo({super.key});

  @override
  State<SleekLoginDemo> createState() => _SleekLoginDemoState();
}

class _SleekLoginDemoState extends State<SleekLoginDemo> {
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
        data: SleekTheme.of(context),
        child: const Dialog(
          child: VerifyNumberDialog(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SleekTheme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SleekTheme(
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
                  onPressed: _showCircularProgressIndicator,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
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
                              theme: SleekTheme.of(context),
                            )));
                  },
                  label: const Text('Phone Number'),
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
