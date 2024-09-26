import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Settings(
      label: 'Main Settings',
      children: [
        ListTile(
          title: Text('Settings'),
        ),
      ],
    );
  }
}
