// import 'package:example/firebase_options.dart';
import 'package:example/firebase_options.dart';
import 'package:example/screens/home/home.screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easychat/easychat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  lo.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    debugPrint('--> MayApp::initState() begins;');
    ChatService.instance.init();

    test();
  }

  test() async {
    // int ts = await getServerTimestamp();
    // print(
    //     'ts: \n$ts\n${ts * -1 + -10000000000000}\n${int.parse("-1$ts")}, ${DateTime.fromMillisecondsSinceEpoch(ts).toIso8601String()}');
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
