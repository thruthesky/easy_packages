import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown_widget/widget/all.dart';

class CodeToLearn extends StatelessWidget {
  const CodeToLearn({
    super.key,
    required this.md,
    this.padding,
  });

  final String md;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(0),
      child: Column(
        children: [
          const SizedBox(height: 48),
          MarkdownBlock(data: md),
        ],
      ),
    );
  }
}
