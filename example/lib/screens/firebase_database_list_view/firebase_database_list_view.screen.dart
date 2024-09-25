import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseDatabaseListViewScreen extends StatefulWidget {
  static const String routeName = '/FirebaseDatabaseListView';
  const FirebaseDatabaseListViewScreen({super.key});

  @override
  State<FirebaseDatabaseListViewScreen> createState() => _FirebaseDatabaseListViewScreenState();
}

class _FirebaseDatabaseListViewScreenState extends State<FirebaseDatabaseListViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FirebaseDatabaseListView'),
      ),
      body: Column(
        children: [
          const Text("FirebaseDatabaseListView"),
          Expanded(
            child: ValueListView(
              query: FirebaseDatabase.instance.ref('/tmp'),
              pageSize: 3,
              reverseQuery: true,
              builder: (snapshot, fetchMore) {
                return ListView.builder(
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index) {
                    print('index: $index');
                    fetchMore(index);
                    return ListTile(
                      contentPadding: const EdgeInsets.all(64),
                      title: Text(snapshot.docs[index].key!),
                    );
                  },
                );
              },
              errorBuilder: (s) => Text('Error: $s'),
              loadingBuilder: () => const CircularProgressIndicator(),
              emptyBuilder: () => const Text('Empty'),
            ),
          ),
        ],
      ),
    );
  }
}
