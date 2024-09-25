import 'package:easy_design_system/easy_design_system.dart';
import 'package:easystate/easystate.dart';
import 'package:example/app.state.dart';
import 'package:example/screens/icon_buttons/icon_buttons.screen.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown_block.dart';

class ComicIconButtonThemeDataContent extends StatelessWidget {
  const ComicIconButtonThemeDataContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MarkdownBlock(data: '''
# ComicIconButtonThemeData

- Why?
  - Flutter themes apply to all widgets globally.
  - We cannot apply themes by ID or cascading style widget trees.
  - Applying a theme to IconButton affects all IconButtons in the app, including those in the AppBar, which can look unattractive.
  - Therefore, we need to create a new theme specifically for IconButton.

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
