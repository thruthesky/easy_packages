import 'package:easy_url_preview/easy_url_preview.dart';
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
  String text =
      "This is the text: https://philgo.com  https://www.flutterflow.io/flutterflow-developer-groups. Press the button below to see the preview.";
  bool preview = false;
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
            Text(text),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  preview = true;
                });
              },
              child: const Text('Show Preview'),
            ),
            if (preview)
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .6,
                child: UrlPreview(text: text),
              ),
          ],
        ),
      ),
    );
  }
}
