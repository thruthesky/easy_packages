import 'package:example/widgets/code_to_learn.dart';
import 'package:flutter/material.dart';
import 'package:easy_design_system/easy_design_system.dart';

class SleekListViewScreen extends StatefulWidget {
  static const String routeName = '/SleekListView';
  const SleekListViewScreen({super.key});

  @override
  State<SleekListViewScreen> createState() => _ComicListViewScreenState();
}

class _ComicListViewScreenState extends State<SleekListViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SleekListView'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SleekListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: List.generate(
                  5,
                  (index) => ListTile(
                    title: Text('Item $index'),
                    subtitle: Text('Subtitle $index'),
                    leading: const Icon(Icons.ac_unit),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SleekListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) => ListTile(
                  title: Text('Item $index'),
                  subtitle: Text('Subtitle $index'),
                  leading: const Icon(Icons.ac_unit),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {},
                ),
              ),
              const CodeToLearn(md: '''
# SleekListView

`SleekListView` is a list view with comic style theme. It provides `SleekListView`, `SleekListView.builder()`, `SleekListView.separated()`.

The `SleekListView` supports full ListView widget with the comic style ui design.


```dart
SleekListView(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  padding: EdgeInsets.zero,
  children: List.generate(
    5,
    (index) => ListTile(
      title: Text('Item \$index'),
      subtitle: Text('Subtitle \$index'),
      leading: const Icon(Icons.ac_unit),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {},
    ),
  ),
),
```

`SleekListView.builder()` support the most of `ListView.builder()` properties with opinionated comic style ui design.

```dart
SleekListView.builder(
  padding: EdgeInsets.zero,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: 5,
  itemBuilder: (context, index) => ListTile(
    title: Text('Item \$index'),
    subtitle: Text('Subtitle \$index'),
    leading: const Icon(Icons.ac_unit),
    trailing: const Icon(Icons.arrow_forward_ios),
    onTap: () {},
  ),
),
```

`SleekListView.separated` supports the most of `ListView.separated` properties except that you cannot customize the `separatedBuilder` since it is opinionated for comic ui design.



```dart
SleekListView.separated(
  padding: EdgeInsets.zero,
  shrinkWrap: true,
  itemCount: 5,
  itemBuilder: (context, index) => ListTile(
    title: Text('Item \$index'),
    subtitle: Text('Subtitle \$index'),
    leading: const Icon(Icons.ac_unit),
    trailing: const Icon(Icons.arrow_forward_ios),
    onTap: () {},
  ),
),
```
'''),
            ],
          ),
        ),
      ),
    );
  }
}
