import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class DividerScreen extends StatelessWidget {
  const DividerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Divider'),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Text('Comic'),
            ComicTheme(
              child: Divider(),
            ),
            SizedBox(height: 32),
            Text('Sleek'),
            SleekTheme(
              child: Divider(),
            ),
            SizedBox(
              height: 16,
            ),
            NothingToLearn()
          ],
        ),
      ),
    );
  }
}
