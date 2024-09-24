import 'package:example/widgets/no_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class ProgressIndicatorScreen extends StatelessWidget {
  const ProgressIndicatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Indicators'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Theme(
                    data: ComicTheme.of(context),
                    child: const Column(
                      children: [
                        Text('Comic'),
                        SizedBox(height: 16),
                        LinearProgressIndicator(),
                        SizedBox(height: 32),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Theme(
                    data: SleekThemeData.of(context),
                    child: const Column(
                      children: [
                        Text('Sleek'),
                        SizedBox(height: 16),
                        LinearProgressIndicator(),
                        SizedBox(height: 32),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const NoTheme(widgetName: 'ProgressIndicator')
          ],
        ),
      ),
    );
  }
}
