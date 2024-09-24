import 'package:easy_design_system/easy_design_system.dart';
import 'package:easystate/easystate.dart';
import 'package:example/app.state.dart';
import 'package:example/screens/icon_buttons/icon_buttons.screen.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown_block.dart';

class SleekIconButtonThemeDataContent extends StatelessWidget {
  const SleekIconButtonThemeDataContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MarkdownBlock(data: '''
# SleekIconButtonThemeData

- Why?
  - For the same reason of IconButtonThemeData!

- How?
  - See the IconButton menu for details.
'''),
        Theme(
          data: ComicThemeData.of(context),
          child: ElevatedButton(
            onPressed: () {
              EasyState.of<AppState>(context)
                  .setContent(const IconButtonScreen());
            },
            child: const Text('IconButton'),
          ),
        ),
      ],
    );
  }
}
