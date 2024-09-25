import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class TextFormFieldScreen extends StatelessWidget {
  const TextFormFieldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TextFormField'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text("Comic TextFormField"),
            Theme(
              data: ComicTheme.of(context),
              child: TextFormField(),
            ),
            const SizedBox(height: 16),
            const Text("Sleek TextFormField"),
            Theme(
              data: SleekTheme.of(context),
              child: TextFormField(),
            ),
          ],
        ),
      ),
    );
  }
}
