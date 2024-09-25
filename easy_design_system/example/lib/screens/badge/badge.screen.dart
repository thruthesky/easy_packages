import 'package:example/widgets/no_theme.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class BadgeScreen extends StatefulWidget {
  static const String routeName = '/Badge';
  const BadgeScreen({super.key});

  @override
  State<BadgeScreen> createState() => _BadgeScreenState();
}

class _BadgeScreenState extends State<BadgeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              children: [
                const TableRow(
                  children: [
                    Text('Comic Theme'),
                    Text('Sleek Theme'),
                  ],
                ),
                TableRow(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Theme(
                          data: ComicTheme.of(context),
                          child: const Badge(
                            label: Text('5'),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Theme(
                          data: SleekThemeData.of(context),
                          child: const Badge(
                            label: Text('5'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const NoTheme(widgetName: 'Badge'),
          ],
        ),
      ),
    );
  }
}
