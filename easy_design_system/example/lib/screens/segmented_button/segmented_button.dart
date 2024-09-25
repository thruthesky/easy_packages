import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class SegmentedButtonScreen extends StatefulWidget {
  const SegmentedButtonScreen({super.key});

  @override
  State<SegmentedButtonScreen> createState() => _SegmentedButtonState();
}

class _SegmentedButtonState extends State<SegmentedButtonScreen> {
  Set<String> _selected = {'value1'};
  Set<String> _selected1 = {'value1'};

  void updateSelection(Set<String> newSelection) {
    setState(() {
      _selected = newSelection;
    });
  }

  void updateSelection1(Set<String> newSelection) {
    setState(() {
      _selected1 = newSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segmented Button'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Comic'),
            Theme(
              data: ComicTheme.of(context),
              child: SegmentedButton(
                selected: _selected,
                segments: const [
                  ButtonSegment(value: 'value1', label: Text('Inbox')),
                  ButtonSegment(value: 'value2', label: Text('Primary')),
                  ButtonSegment(value: 'value3', label: Text('Others')),
                ],
                onSelectionChanged: updateSelection,
              ),
            ),
            const SizedBox(height: 24),
            const Text('Sleek'),
            Theme(
              data: SleekThemeData.of(context),
              child: SegmentedButton(
                selected: _selected1,
                segments: const [
                  ButtonSegment(value: 'value1', label: Text('Inbox')),
                  ButtonSegment(value: 'value2', label: Text('Primary')),
                  ButtonSegment(value: 'value3', label: Text('Others')),
                ],
                onSelectionChanged: updateSelection1,
              ),
            ),
            const SizedBox(height: 32),
            const NothingToLearn(),
          ],
        ),
      ),
    );
  }
}
