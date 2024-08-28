import 'package:easy_setting_v2/easy_setting.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key, required this.id, required this.builder});

  final String id;
  final Widget Function(SettingModel) builder;

  @override
  Widget build(BuildContext context) {
    return Document('settings', id, builder: (model) {
      return builder(model);
    });
  }
}
