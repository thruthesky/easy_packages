import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class FloatingActionButtonScreen extends StatefulWidget {
  const FloatingActionButtonScreen({super.key});

  @override
  State<FloatingActionButtonScreen> createState() =>
      _FloatingActionButtonScreenState();
}

class _FloatingActionButtonScreenState
    extends State<FloatingActionButtonScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Action Buttons'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      Theme(
                        data: ComicThemeData.of(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            FloatingActionButton(
                              heroTag: 'comicFloatingActionButton',
                              onPressed: () {
                                debugPrint('Pressed');
                              },
                              child: const Icon(Icons.favorite),
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton.extended(
                              heroTag: 'comicFloatingActionButtonExtended',
                              onPressed: () {
                                debugPrint('Pressed');
                              },
                              label: const Text('Extended'),
                            ),
                          ],
                        ),
                      ),
                      Theme(
                        data: SleekThemeData.of(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            FloatingActionButton(
                              heroTag: 'sleekFloatingActionButton',
                              onPressed: () {
                                debugPrint('Pressed');
                              },
                              child: const Icon(Icons.favorite),
                            ),
                            const SizedBox(height: 8),
                            FloatingActionButton.extended(
                              heroTag: 'sleekFloatingActionButtonExtended',
                              onPressed: () {
                                debugPrint('Pressed');
                              },
                              label: const Text('Extended'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const NothingToLearn(),
            ],
          ),
        ),
      ),
    );
  }
}
