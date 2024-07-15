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

    lo.set(key: 'start game', locale: 'en', value: 'Start the game now');
    lo.set(key: 'start game', locale: 'ko', value: '게임을 시작하세요.');
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
            Text('locale: $locale'),
            Wrap(
              children: [
                ElevatedButton(
                  onPressed: () {
                    lo.init(
                      defaultLocale: 'en',
                      deviceLocale: false,
                    );
                    setState(() {
                      locale = 'en';
                    });
                  },
                  child: const Text('Set English'),
                ),
                ElevatedButton(
                  onPressed: () {
                    lo.init(
                      defaultLocale: 'ko',
                      deviceLocale: false,
                    );
                    setState(() {
                      locale = 'ko';
                    });
                  },
                  child: const Text('Set Korean'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Translage with .t'),
            Text("name".t),
            const SizedBox(height: 24),
            const Text('Translage with .t'),
            Text("start game".t),
            const SizedBox(height: 24),
            const Text('Translage with .tr'),
            Text("version".tr(args: {'v': '1.0.7'})),
          ],
        ),
      ),
    );
  }
}
