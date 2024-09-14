// import 'package:example/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        title: const Text('Realtime Database Example'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const Text(
                'DatabaseListView',
              ),
              DatabaseLimitedListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                ref: FirebaseDatabase.instance.ref('mirror-users'),
                limit: 5,
                itemBuilder: (context, entry, index) {
                  return ListTile(
                    title: Text(entry.value['name'] ?? 'No name'),
                    subtitle: Text(entry.key),
                  );
                },
              ),
              DatabaseLimitedQueryBuilder(
                ref: FirebaseDatabase.instance.ref('mirror-users'),
                limit: 5,
                builder: (data) {
                  return Column(
                    children: data.entries
                        .map<Widget>(
                          (entry) => ListTile(
                            title: Text((entry.value as Map)['name'] ?? '...'),
                            subtitle: Text(entry.key as String),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
