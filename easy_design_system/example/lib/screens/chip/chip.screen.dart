import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class ChipScreen extends StatefulWidget {
  const ChipScreen({super.key});

  @override
  State<ChipScreen> createState() => _ChipScreenState();
}

class _ChipScreenState extends State<ChipScreen> {
  bool c1 = true;
  bool c2 = true;
  bool ic1 = true;
  bool ic2 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Table(
              children: [
                const TableRow(
                  children: [
                    Text("Comic Theme"),
                    Text("Sleek Theme"),
                  ],
                ),
                TableRow(
                  children: [
                    ComicTheme(
                      child: ChoiceChip(
                        label: const Text("ChoiceChip"),
                        selected: c1,
                        onSelected: (v) => setState(() => c1 = v),
                      ),
                    ),
                    SleekTheme(
                      child: ChoiceChip(
                        label: const Text("ChoiceChip"),
                        selected: c2,
                        onSelected: (v) => setState(() => c2 = v),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    ComicTheme(
                      child: InputChip(
                        label: const Text("InputChip"),
                        selected: ic1,
                        onSelected: (v) => setState(() => ic1 = v),
                      ),
                    ),
                    SleekTheme(
                      child: InputChip(
                        label: const Text("InputChip"),
                        selected: ic2,
                        onSelected: (v) => setState(() => ic2 = v),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const NothingToLearn(),
          ],
        ),
      ),
    );
  }
}
