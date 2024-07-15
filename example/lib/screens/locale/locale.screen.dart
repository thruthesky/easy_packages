import 'package:easy_locale/easy_locale.dart';
import 'package:flutter/material.dart';

class LocaleScreen extends StatefulWidget {
  static const String routeName = '/Locale';
  const LocaleScreen({super.key});

  @override
  State<LocaleScreen> createState() => _LocaleScreenState();
}

class _LocaleScreenState extends State<LocaleScreen> {
  String? locale;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Locale Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                lo.init(
                  defaultLocale: locale ?? 'en',
                  deviceLocale: false,
                );
                setState(() {
                  locale = 'en';
                });
              },
              child: const Text('Set English'),
            ),
            Text("name".t),
          ],
        ),
      ),
    );
  }
}
