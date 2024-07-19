import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// A wrapper of [MyDoc] to make it short.
///
/// It only calls the [builder] when the [User] is ready.
///
/// Use this widget to know if the user document is loaded and ready to use.
///
/// Note that, the builder does not pass any parameter.
class MyDocReady extends StatelessWidget {
  const MyDocReady({super.key, required this.builder});

  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    return MyDoc(
      builder: (my) => my == null ? const SizedBox.shrink() : builder(),
    );
  }
}
