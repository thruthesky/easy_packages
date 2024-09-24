import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown_widget/widget/all.dart';

class NothingToLearn extends StatelessWidget {
  const NothingToLearn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 48),
        Divider(),
        SizedBox(height: 16),
        Text(
          "Social design system will automatically enhance the UI of your app. Just continue building your app.",
        ),
        MarkdownBlock(data: '''
```dart
MaterialApp(
  theme: ComicTheme.of(context),
);
```
'''),
      ],
    );
  }
}
