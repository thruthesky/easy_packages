import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_like/easy_like.dart';
import 'package:example/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final documentReference =
      FirebaseFirestore.instance.collection('tmp').doc('bbb');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.hasData) {
                    return Text('User is signed in: ${snapshot.data?.uid}');
                  }
                  return const Text('User is not signed in');
                }),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signInAnonymously();
              },
              child: const Text('Login as Anonymous'),
            ),
            ElevatedButton(
              onPressed: () {
                LikeTestService.instance.runTests();
              },
              child: const Text('Test Likes'),
            ),
            LikeDoc(
              documentReference: documentReference,
              builder: (liked) {
                return Column(
                  children: [
                    Icon(liked ? Icons.favorite : Icons.favorite_border),
                    ElevatedButton(
                      onPressed: () async {
                        final like = Like(
                          documentReference: documentReference,
                        );
                        await like.like();
                      },
                      child: Text('(Future) Like: $liked'),
                    ),
                  ],
                );
              },
            ),
            LikeDoc(
              sync: true,
              documentReference: documentReference,
              builder: (liked) {
                return Column(
                  children: [
                    Icon(liked ? Icons.favorite : Icons.favorite_border),
                    ElevatedButton(
                      onPressed: () async {
                        final like = Like(
                          documentReference: documentReference,
                        );
                        await like.like();
                      },
                      child: Text('(Sync) Like: $liked'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
