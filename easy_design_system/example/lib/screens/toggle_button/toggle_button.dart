import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class ToggleButtonScreen extends StatefulWidget {
  const ToggleButtonScreen({super.key});

  @override
  State<ToggleButtonScreen> createState() => _ToggleButtonScreenState();
}

class _ToggleButtonScreenState extends State<ToggleButtonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toggle Button'),
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
                      child: ToggleButtonExample(),
                    ),
                    SleekTheme(
                      child: ToggleButtonExample(),
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

class ToggleButtonExample extends StatelessWidget {
  const ToggleButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: ToggleButtons(
            isSelected: const [true, false, false],
            onPressed: (int index) {},
            children: const <Widget>[
              Text('ABC'),
              Text('DEF'),
              Text('GHI'),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ToggleButtons(
          isSelected: const [false, true, false],
          onPressed: (int index) {},
          children: const <Widget>[
            Text('ABC'),
            Text('DEF'),
            Text('GHI'),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ToggleButtons(
          isSelected: const [false, false, true],
          onPressed: (int index) {},
          children: const <Widget>[
            Text('ABC'),
            Text('DEF'),
            Text('GHI'),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ToggleButtons(
          isSelected: const [true, true, true],
          onPressed: (int index) {},
          children: const <Widget>[
            Icon(Icons.arrow_back),
            Icon(Icons.graphic_eq_rounded),
            Icon(Icons.arrow_forward),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ToggleButtons(
          isSelected: const [true, false, false],
          onPressed: null,
          children: const <Widget>[
            Icon(Icons.arrow_back),
            Icon(Icons.graphic_eq_rounded),
            Icon(Icons.arrow_forward),
          ],
        ),
      ],
    );
  }
}
