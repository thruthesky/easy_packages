import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class RadioButtonScreen extends StatefulWidget {
  const RadioButtonScreen({super.key});

  @override
  State<RadioButtonScreen> createState() => _RadioButtonScreenState();
}

class _RadioButtonScreenState extends State<RadioButtonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radio Button'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Table(
              children: const [
                TableRow(
                  children: [
                    Text('Comic Theme'),
                    Text('Sleek Theme'),
                  ],
                ),
                TableRow(
                  children: [
                    ComicTheme(
                      child: RadioExample(),
                    ),
                    SleekTheme(
                      child: RadioExample(),
                    ),
                  ],
                )
              ],
            ),
            const NothingToLearn()
          ],
        ),
      ),
    );
  }
}

class RadioExample extends StatelessWidget {
  const RadioExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Radio(
              value: 'radio1',
              groupValue: 'radio1',
              onChanged: (value) {},
            ),
            const Text('Selected')
          ],
        ),
        Row(
          children: [
            Radio(
              value: 'radio2',
              groupValue: '',
              onChanged: (value) {},
            ),
            const Text('Not selected')
          ],
        ),
        const Row(
          children: [
            Radio(
              value: 'radio1',
              groupValue: 'radio1',
              onChanged: null,
            ),
            Text('Disable selected')
          ],
        ),
        const Row(
          children: [
            Radio(
              value: 'radio2',
              groupValue: '',
              onChanged: null,
            ),
            Text('Disable unselected')
          ],
        ),
      ],
    );
  }
}
