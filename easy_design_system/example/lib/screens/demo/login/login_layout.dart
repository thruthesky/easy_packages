import 'package:flutter/material.dart';

class LoginLayout extends StatelessWidget {
  const LoginLayout({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Spacer(),
        Text(
          'Welcome Back! Login to Social Design System to get started',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 56,
        ),
        ...children,
        const Spacer(flex: 2)
      ],
    );
  }
}
