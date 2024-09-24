import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown_block.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: MarkdownBlock(
        data: '''
# Easy Design System

- Why Easy Design System?
  - To make it absolutely easy for you to build beautiful apps.
  - And yes, it is absolutely easy to use.
- Easy design system is an Elegant UI/UX library crafted specifically for building beautiful applications.
- You do NOT need to
  - learn anything,
  - do anything,
  - read anything
  - Just wrap your app with the theme and you are good to go.
  It will just work. Continue your job.

## Terms
- `Basic widgets` means the widgets in material.dart.
- `Visual component widget` is a widget that have a visual outloook on screen like a Text widget. While GestureDetector is not a visual component since it does not appear on the screen.
                  ''',
      ),
    );
  }
}
