import 'package:example/widgets/code_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Table(children: const [
                TableRow(
                  children: [
                    Text('Comic Theme'),
                    Text('Sleek Theme'),
                  ],
                ),
                TableRow(children: [
                  ComicTheme(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CardChild(),
                      ),
                    ),
                  ),
                  SleekTheme(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CardChild(),
                      ),
                    ),
                  ),
                ])
              ]),
              const CodeToLearn(md: '''
## Card

* Card has many properties including a background and a border which causes the UI look dirty.
* By default, Card widget has a border in comic theme and if you add a ListTile inside it, the border will be doubled. You can do your own customization to make it look better.
  Below is an example of a Card with a ListTile inside it.
```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(8.0),
    child: Column(
      children: [
        const ListTile(
          title: Text('Title'),
          subtitle: Text('Subtitle'),
          leading: Icon(Icons.ac_unit),
        ),
        Row(
          children: [
            const Spacer(),
            ElevatedButton(onPressed: () {}, child: const Text("YES")),
            ElevatedButton(onPressed: () {}, child: const Text("NO"))
          ],
        ),
      ],
    ),
  ),
),
```

* Sleek theme does not give theme design for the Card outline variant, Sleek theme is clean and simple so elevation and border are remove for Card Sleek Theme , you can still use the Card.outline variant but there wont be any theme design
        '''),
            ],
          ),
        ),
      ),
    );
  }
}

class CardChild extends StatelessWidget {
  const CardChild({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListTile(
          title: Text('Title'),
          subtitle: Text('Subtitle'),
          leading: Icon(Icons.ac_unit),
        ),
        Row(
          children: [
            const Spacer(),
            ElevatedButton(onPressed: () {}, child: const Text("YES")),
            ElevatedButton(onPressed: () {}, child: const Text("NO"))
          ],
        ),
      ],
    );
  }
}
