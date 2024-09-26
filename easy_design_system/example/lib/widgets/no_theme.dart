import 'package:flutter/material.dart';

class NoTheme extends StatelessWidget {
  const NoTheme({
    super.key,
    required this.widgetName,
  });

  final String widgetName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48),
        const Divider(),
        Text(
          "Social design system does not apply any theme UI on $widgetName.",
        ),
      ],
    );
  }
}
