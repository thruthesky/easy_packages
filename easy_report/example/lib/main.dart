import 'package:easyuser/easyuser.dart';
// import 'package:example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_report/easy_report.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('firebase project id: ${FirebaseDatabase.instance.app.options.projectId}');
  runApp(const EasyReportApp());
}

class EasyReportApp extends StatelessWidget {
  const EasyReportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // print("firebase instance: ${FirebaseDatabase.instance.app.name}");
    // final ref = FirebaseDatabase.instance.ref().child('reports').orderByChild('reporter').equalTo('user-uid');
    // print('ref: ${ref.path}');
    // final snapshot = await ref.get();

    // print('snapshot: ${snapshot.value}');

    // // ref.onValue.listen((event) {
    // //   print('event: ${event.snapshot.value}');
    // // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          AuthStateChanges(
            builder: (user) {
              return user == null
                  ? const EmailPasswordLogin()
                  : Column(
                      children: [
                        Text('Welcome user uid: ${user.uid}'),
                        ElevatedButton(
                          onPressed: () {
                            UserService.instance.signOut();
                          },
                          child: const Text('Sign out'),
                        ),
                      ],
                    );
            },
          ),
          ElevatedButton(
            onPressed: () {
              ReportService.instance.report(
                context: context,
                reportee: 'reportee',
                type: 'type',
                path: 'user-uid',
                summary: 'summary',
              );
            },
            child: const Text('Report a user'),
          ),
          ElevatedButton(
            onPressed: () {
              ReportService.instance.report(
                context: context,
                reportee: 'u2',
                type: 'post',
                path: 'post 1',
                summary: 'summary 1',
              );
            },
            child: const Text('Report a Post'),
          ),
          ElevatedButton(
            onPressed: () {
              ReportService.instance.report(
                context: context,
                reportee: 'u3',
                type: 'comment',
                path: 'comment 1',
                summary: 'I report this comment 3',
              );
            },
            child: const Text('Report a Comment'),
          ),
          ElevatedButton(
            onPressed: () {
              ReportService.instance.report(
                context: context,
                reportee: 'uid of the user: if it is a chat room, report one of the master',
                type: 'chat',
                summary: 'Reporting chat room',
                path: '/chat/room/chat_room_id',
              );
            },
            child: const Text('Report a Chat Room'),
          ),
          AuthStateChanges(
            builder: (user) => user == null
                ? const SizedBox.shrink()
                : const Expanded(
                    child: ReportListView(),
                  ),
          ),
        ],
      ),
    );
  }
}
