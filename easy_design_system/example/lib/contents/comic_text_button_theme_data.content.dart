import 'package:easy_design_system/easy_design_system.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown_block.dart';

class ComicTextButtonThemeDataContent extends StatelessWidget {
  const ComicTextButtonThemeDataContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MarkdownBlock(data: '''
# ComicIconButtonThemeData

- Why?
  - All TextButtons must be simple and borderless, even in the comic theme.
  - If you want a TextButton with a border as the comic design, use [ComicTextButtonThemeData].
  - In summary, comic-themed TextButtons are borderless. To add a border, apply [ComicTextButtonThemeData].

- Example:
```dart
Theme(
  data: ComicThemeData.of(context),
  child: TextButton(
    onPressed: () {
    },
    child: const Text('This is TextButton'),
  ),
),
```

'''),
        Theme(
          data: ComicThemeData.of(context),
          child: TextButton(
            onPressed: () {
              // Display a toast message with the text "TextButton presssed!" with ScaffoldMessenger.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('TextButton presssed!')),
              );
            },
            child: const Text('This is TextButton'),
          ),
        ),
      ],
    );
  }
}
