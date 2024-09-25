import 'package:example/widgets/code_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class SleepWalkerScreen extends StatefulWidget {
  static const String routeName = '/SleepWalker';
  const SleepWalkerScreen({super.key});

  @override
  State<SleepWalkerScreen> createState() => _SleepWalkerScreenState();
}

class _SleepWalkerScreenState extends State<SleepWalkerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SleepWalker'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Stack(
                children: [
                  const Text("SleepWalker"),
                  SleepWalker(
                    repeat: true,
                    alignments: const [
                      (
                        alignment: Alignment.topLeft,
                        duration: Duration(milliseconds: 2000),
                      ),
                      (
                        alignment: Alignment.topRight,
                        duration: Duration(milliseconds: 700),
                      ),
                      (
                        alignment: Alignment.bottomRight,
                        duration: Duration(milliseconds: 400),
                      ),
                      (
                        alignment: Alignment.bottomLeft,
                        duration: Duration(milliseconds: 300),
                      ),
                      (
                        alignment: Alignment(.7, .2),
                        duration: Duration(milliseconds: 200),
                      ),
                      (
                        alignment: Alignment(-1, -1),
                        duration: Duration(seconds: 1),
                      ),
                    ],
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const CodeToLearn(padding: EdgeInsets.all(24), md: '''
# Sleep Walker

- You can move around a widget in a stack. It is useful to give some decoration under the stack.

- The speed of the each move is set by the starting point of the `duration`. Meaning, the speed of the current position to next position is depends on the `duration` of the current position. So, the last `duration` is ignored.

```dart
import 'package:flutter/material.dart';
import 'package:social_kit/social_kit.dart';

class SleepWalkerScreen extends StatefulWidget {
  static const String routeName = '/SleepWalker';
  const SleepWalkerScreen({super.key});

  @override
  State<SleepWalkerScreen> createState() => _SleepWalkerScreenState();
}

class _SleepWalkerScreenState extends State<SleepWalkerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SleepWalker'),
      ),
      body: Stack(
        children: [
          const Text("SleepWalker"),
          SleepWalker(
            alignments: const [
              (
                alignment: Alignment.topLeft,
                duration: Duration(milliseconds: 2000),
              ),
              (
                alignment: Alignment.topRight,
                duration: Duration(milliseconds: 700),
              ),
              (
                alignment: Alignment.bottomRight,
                duration: Duration(milliseconds: 400),
              ),
              (
                alignment: Alignment.bottomLeft,
                duration: Duration(milliseconds: 300),
              ),
              (
                alignment: Alignment(.7, .2),
                duration: Duration(milliseconds: 200),
              ),
              (
                alignment: Alignment(-1, -1),
                duration: Duration(seconds: 1),
              ),
            ],
            child: Container(
              width: 200,
              height: 200,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
```

- Use case; You may add a background that moves in a screen. Add a child widget that has some blurred shapes and rotatation.
'''),
          ],
        ),
      ),
    );
  }
}
