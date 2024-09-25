import 'package:example/screens/demo/login/login_layout.dart';
import 'package:flutter/material.dart';

class EmailLoginScreen extends StatefulWidget {
  static const String routeName = '/email_login';
  const EmailLoginScreen({super.key, required this.theme});
  final ThemeData theme;

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
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

      _showSnackBar();
    });
  }

  void _showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Login Successful'),
        action: SnackBarAction(
          onPressed: () {},
          label: 'Dismiss',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.theme,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: LoginLayout(
              children: [
                const TextField(
                  decoration: InputDecoration(
                      hintText: 'Email',
                      label: Text('Email'),
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                const SizedBox(
                  height: 16,
                ),
                const TextField(
                  decoration: InputDecoration(
                    hintText: 'Password',
                    label: Text('Password'),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
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
                        : const Text('Sign In')),
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
                    Navigator.of(context).pop();
                  },
                  label: const Text('Phone Number'),
                  icon: const Icon(Icons.phone),
                )
              ],
            ),
          )),
    );
  }
}
