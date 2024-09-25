import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: SleekTheme.of(context),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: () {}, child: const Text("Hello, there")),
          ListTile(
            title: const Text('Text Theme'),
            onTap: () {},
          ),
          Theme(
            data: ComicTheme.of(context),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Comic Theme'),
            ),
          ),
        ],
      ),
    );
  }
}
