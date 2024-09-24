import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class CheckboxScreen extends StatefulWidget {
  const CheckboxScreen({super.key});

  @override
  State<CheckboxScreen> createState() => _CheckboxScreenState();
}

class _CheckboxScreenState extends State<CheckboxScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkbox'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                TableRow(children: [
                  ComicTheme(child: CheckboxExample()),
                  SleekTheme(child: CheckboxExample()),
                ]),
              ],
            ),
            const NothingToLearn()
          ],
        ),
      ),
    );
  }
}

class CheckboxExample extends StatelessWidget {
  const CheckboxExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: false,
              onChanged: (v) {},
            ),
            const Text('Off'),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: true,
              onChanged: (v) {},
            ),
            const Text('On'),
          ],
        ),
        const Row(
          children: [
            Checkbox(
              value: false,
              onChanged: null,
            ),
            Text('Off Disabled'),
          ],
        ),
        const Row(
          children: [
            Checkbox(
              value: true,
              onChanged: null,
            ),
            Text('On Disabled'),
          ],
        ),
      ],
    );
  }
}
