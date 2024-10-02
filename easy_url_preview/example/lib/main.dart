import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Easy URL Preview Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is the text: https://www.google.com. Press the button below to see the preview.',
            ),
            ElevatedButton(
              onPressed: () async {
                final model = UrlPreviewModel();
                await model.load(text);
                if (!model.hasData) return;
                await message.update(
                  previewUrl: model.firstLink,
                  previewTitle: model.title,
                  previewDescription: model.description,
                  previewImageUrl: model.image,
                );
              },
              child: const Text('Show Preview'),
            ),
          ],
        ),
      ),
    );
  }
}
