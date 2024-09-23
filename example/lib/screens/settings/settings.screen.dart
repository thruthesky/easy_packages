import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const String routeName = '/Settings';
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Column(
        children: [
          Text("Settings"),
          // TODO: implement the Setting widget: refactoring-database
          // Setting(
          //   id: 'system',
          //   builder: (DocumentModel doc) {
          //     return ElevatedButton(
          //       child: Text('System count: ${doc.value<int>('count') ?? 0}'),
          //       onPressed: () {
          //         doc.increment('count');
          //       },
          //     );
          //   },
          // ),
          // Setting(
          //   id: FirebaseAuth.instance.currentUser!.uid,
          //   builder: (doc) {
          //     return ListTile(
          //       title: Text('I like: ${doc.value<String>('fruit') ?? '...'}'),
          //       subtitle: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           const Text('Choose one;'),
          //           Row(
          //             children: [
          //               TextButton(
          //                 child: const Text('Apple'),
          //                 onPressed: () {
          //                   // print(doc.data);
          //                   doc.update({
          //                     'fruit': 'Apple',
          //                     'updatedAt': DateTime.now()
          //                   });
          //                 },
          //               ),
          //               TextButton(
          //                 child: const Text('Banna'),
          //                 onPressed: () {
          //                   doc.update({
          //                     'fruit': 'Banana',
          //                     'updatedAt': DateTime.now()
          //                   });
          //                 },
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
