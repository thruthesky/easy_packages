import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class TextFieldScreen extends StatefulWidget {
  static const String routeName = '/TextField';
  const TextFieldScreen({super.key});

  @override
  State<TextFieldScreen> createState() => _TextFieldScreenState();
}

class _TextFieldScreenState extends State<TextFieldScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextField'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Comic TextField"),
            Theme(
              data: ComicTheme.of(context),
              child: const TextField(),
            ),
            const SizedBox(height: 16),
            const Text("Sleek TextField"),
            Theme(
              data: SleekTheme.of(context),
              child: const TextField(),
            ),
            const SizedBox(height: 16),
            const NothingToLearn(),
          ],
        ),
      ),
    );
  }
}
