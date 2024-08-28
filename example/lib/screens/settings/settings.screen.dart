import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easy_setting_v2/easy_setting.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/Settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          const Text("Settings"),
          Setting(
            id: 'system',
            builder: (doc) {
              return ListTile(
                title: Text('System count: ${doc.value<int>('count') ?? 0}'),
                onTap: () {
                  doc.increment('count');
                },
              );
            },
          ),
          Setting(
            id: FirebaseAuth.instance.currentUser!.uid,
            builder: (doc) {
              return ListTile(
                title: Text('I like: ${doc.value<String>('fruit') ?? '...'}'),
                subtitle: Row(
                  children: [
                    TextButton(
                      child: const Text('Apple'),
                      onPressed: () {
                        doc.update({'fruit': 'Apple'});
                      },
                    ),
                    TextButton(
                      child: const Text('Banna'),
                      onPressed: () {
                        doc.update({'fruit': 'Banana'});
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
