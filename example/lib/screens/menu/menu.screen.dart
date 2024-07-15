import 'package:flutter/material.dart';

class MenuScreen extends StatefulWidget {
  static const String routeName = '/Menu';
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: const Column(
        children: [
          Text("Menu"),
        ],
      ),
    );
  }
}
