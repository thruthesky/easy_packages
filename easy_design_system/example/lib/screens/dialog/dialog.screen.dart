import 'package:example/widgets/nothing_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:easy_design_system/easy_design_system.dart';

class DialogScreen extends StatelessWidget {
  const DialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dialog'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Dialogs"),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  // Dialogs
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Theme(
                        data: ComicTheme.of(context),
                        child: const Dialog(
                          child: DialogContent(),
                        ),
                      ),
                    ),
                    child: const Text('Comic Dialog'),
                  ),
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Theme(
                        data: SleekTheme.of(context),
                        child: const Dialog(
                          child: DialogContent(),
                        ),
                      ),
                    ),
                    child: const Text('Sleek Dialog'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Alert Dialogs"),
              const SizedBox(height: 8),
              // Alert Dialogs
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Theme(
                        data: ComicTheme.of(context),
                        child: AlertDialog(
                          icon: const Icon(Icons.star),
                          title: const Text('Comic'),
                          content: const Text(
                              'This is an alert dialog for comic theme.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: const Text('Comic Alert Dialog'),
                  ),
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Theme(
                        data: SleekTheme.of(context),
                        child: AlertDialog(
                          icon: const Icon(Icons.star),
                          title: const Text('Sleek'),
                          content: const Text(
                              'This is an alert dialog for sleek theme.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Ok'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    child: const Text('Sleek Alert Dialog'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text("Simple Dialogs"),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Theme(
                        data: ComicTheme.of(context),
                        child: const SimpleDialog(
                          children: [
                            DialogContent(),
                          ],
                        ),
                      ),
                    ),
                    child: const Text('Comic Simple Dialog'),
                  ),
                  ElevatedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) => Theme(
                        data: SleekTheme.of(context),
                        child: const SimpleDialog(
                          children: [
                            DialogContent(),
                          ],
                        ),
                      ),
                    ),
                    child: const Text('Sleek Simple Dialog'),
                  ),
                ],
              ),
              const NothingToLearn(),
              const MarkdownBlock(
                data: '''
**Note**
In `ComicTheme`, `BorderSide` is used to style the `Dialog` but since it has its own default value and cannot override, you might need to customize it on your own.

```dart
const BorderSide({
  // BorderSide default value
  this.color = const Color(0xFF000000), 
```
''',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// This is a content only for dialog, not necessarily part of the code above
class DialogContent extends StatelessWidget {
  const DialogContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                'This is a Dialog',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
