import 'package:example/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_storage/easy_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Example',
      home: HomeScreenScreen(),
    );
  }
}

class HomeScreenScreen extends StatefulWidget {
  static const String routeName = '/HomeScreen';
  const HomeScreenScreen({super.key});

  @override
  State<HomeScreenScreen> createState() => _HomeScreenScreenState();
}

class _HomeScreenScreenState extends State<HomeScreenScreen> {
  String? url;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeScreen'),
      ),
      body: Column(
        children: [
          const Text('HomeScreen'),
          StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.hasData == false || snapshot.data == null) {
                return Column(
                  children: [
                    const Text(
                      'Sign in.',
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signInAnonymously();
                      },
                      child: const Text('Sign In Anonymously'),
                    ),
                  ],
                );
              }

              User user = snapshot.data as User;

              return Column(
                children: [
                  Text('User: uid: ${user.uid}'),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Sign Out'),
                  ),
                  if (url != null)
                    Image.network(
                      url!,
                      width: 200,
                      height: 200,
                    ),
                  ElevatedButton(
                    onPressed: () async {
                      url = await StorageService.instance.upload(
                        context: context,
                      );
                      if (url == null) {
                        return;
                      }
                      setState(() {});
                      print('Uploaded: $url');
                    },
                    child: const Text(
                      'Upload',
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () async {
                  //     url = await StorageService.instance.uploadAt(
                  //       context: context,
                  //     );
                  //     if (url == null) {
                  //       return;
                  //     }
                  //     setState(() {});
                  //     print('Uploaded: $url');
                  //   },
                  //   child: const Text(
                  //     'UploadAt',
                  //   ),
                  // ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
