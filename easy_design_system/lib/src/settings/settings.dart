import 'package:flutter/material.dart';

/// Settings
///
/// A widget that displays a list of settings.
class Settings extends StatelessWidget {
  const Settings({
    super.key,
    required this.children,
    required this.label,
    this.indent = false,
    this.padding = const EdgeInsets.all(0),
    this.elevation = 0,
  });

  final List<Widget> children;
  final String label;
  final bool indent;
  final EdgeInsetsGeometry padding;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final isSleekTheme = Theme.of(context).dividerColor ==
        Theme.of(context).colorScheme.onPrimaryContainer;

    double? thickness;
    double? height;
    double? borderRadius;

    if (isSleekTheme) {
      thickness = 0;
      height = 0;
      borderRadius = 24;
    }
    Widget card = Card(
      margin: EdgeInsets.zero,
      elevation: elevation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTileTheme(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => Divider(
                indent: 16,
                endIndent: 16,
                height: height ?? 2,
                thickness: thickness ?? 1.8,
                color: Theme.of(context).dividerColor,
              ),
              itemCount: children.length,
              itemBuilder: (context, index) => children[index],
            ),
          ),
        ],
      ),
    );

    if (isSleekTheme) {
      card = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: Container(color: Colors.blue, child: card),
      );
    }

    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(label),
          ),
          card,
        ],
      ),
    );
  }
}
