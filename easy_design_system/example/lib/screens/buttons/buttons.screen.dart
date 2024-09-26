import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class ButtonsScreen extends StatefulWidget {
  static const String routeName = '/Buttons';
  const ButtonsScreen({super.key});

  @override
  State<ButtonsScreen> createState() => _ButtonsScreenState();
}

class _ButtonsScreenState extends State<ButtonsScreen> {
  final space = const SizedBox(width: 16);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buttons'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(4),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(4)
          },
          children: [
            TableRow(children: [
              const Text("Comic Theme"),
              space,
              const Text("Sleek Theme"),
            ]),
            TableRow(children: [
              ComicTheme(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('ElevatedButton'),
                ),
              ),
              space,
              SleekTheme(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('ElevatedButton'),
                ),
              ),
            ]),
            TableRow(children: [
              ComicTheme(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('TextButton'),
                ),
              ),
              space,
              SleekTheme(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('TextButton'),
                ),
              ),
            ]),
            TableRow(children: [
              ComicTheme(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('TextButton.icon'),
                ),
              ),
              space,
              SleekTheme(
                child: TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('TextButton.icon'),
                ),
              ),
            ]),
            TableRow(
              children: [
                ComicTheme(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('OutlinedButton'),
                  ),
                ),
                space,
                SleekTheme(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('OutlinedButton'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
