import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: AppSettingScreen(),
  ));
}

class AppSettingScreen extends StatefulWidget {
  const AppSettingScreen({super.key});
  @override
  State<AppSettingScreen> createState() => _AppSettingScreenState();
}

class _AppSettingScreenState extends State<AppSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Screen'),
          ],
        ),
      ),
    );
  }
}
