import 'package:example/widgets/code_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class SettingScreen extends StatefulWidget {
  static const String routeName = '/Setting';
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ComicTheme(
                child: Settings(
                  label: 'Comic Theme Settings',
                  children: [
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      title: const Text('Notifications'),
                      subtitle: const Text('Receive notifications'),
                      leading: const Icon(Icons.notifications_outlined),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => debugPrint('Item 1'),
                    ),
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      title: const Text('Favorites'),
                      subtitle: const Text('Want to know who likes you?'),
                      leading: const Icon(Icons.favorite_border_outlined),
                      trailing: const Icon(
                        Icons.arrow_right_rounded,
                        size: 32,
                      ),
                      onTap: () => debugPrint('Item 2'),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SleekTheme(
                child: Settings(
                  label: 'Sleek Theme Settings',
                  children: [
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      title: const Text('Notifications'),
                      subtitle: const Text('Receive notifications'),
                      leading: const Icon(Icons.notifications_outlined),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => debugPrint('Item 1'),
                    ),
                    ListTile(
                      visualDensity: VisualDensity.compact,
                      title: const Text('Favorites'),
                      subtitle: const Text('Want to know who likes you?'),
                      leading: const Icon(Icons.favorite_border_outlined),
                      trailing: const Icon(
                        Icons.arrow_right_rounded,
                        size: 32,
                      ),
                      onTap: () => debugPrint('Item 2'),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: CodeToLearn(md: '''
## Settings

- This `Settings` widget is intended for use in a menu or settings screen.
- The `Settings` widget comprises a series of `ListTile` widgets.
- To apply a theme, simply wrap your `Settings` widget with either the `ComicTheme` or `SleekTheme`.
- `elevation` is an optional parameter that adds a shadow to the `Settings` widget.

```dart
Padding(
      padding: const EdgeInsets.all(24.0),
      child: ComicTheme(
        child: Settings(
          label: 'Comic Theme Settings',
          children: [
            ListTile(
              visualDensity: VisualDensity.compact,
              title: const Text('Notifications'),
              subtitle: const Text('Receive notifications'),
              leading: const Icon(Icons.notifications_outlined),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => debugPrint('Item 1'),
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: const Text('Favorites'),
              subtitle: const Text('Want to know who likes you?'),
              leading: const Icon(Icons.favorite_border_outlined),
              trailing: const Icon(
                Icons.arrow_right_rounded,
                size: 32,
              ),
              onTap: () => debugPrint('Item 2'),
            ),
          ],
        ),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(24.0),
      child: SleekTheme(
        child: Settings(
          label: 'Sleek Theme Settings',
          children: [
            ListTile(
              visualDensity: VisualDensity.compact,
              title: const Text('Notifications'),
              subtitle: const Text('Receive notifications'),
              leading: const Icon(Icons.notifications_outlined),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => debugPrint('Item 1'),
            ),
            ListTile(
              visualDensity: VisualDensity.compact,
              title: const Text('Favorites'),
              subtitle: const Text('Want to know who likes you?'),
              leading: const Icon(Icons.favorite_border_outlined),
              trailing: const Icon(
                Icons.arrow_right_rounded,
                size: 32,
              ),
              onTap: () => debugPrint('Item 2'),
            ),
          ],
        ),
      ),
    ),
```

            '''),
            ),
          ],
        ),
      ),
    );
  }
}
