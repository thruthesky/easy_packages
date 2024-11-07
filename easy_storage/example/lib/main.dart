// import 'package:example/firebase_options.dart';
import 'package:example/multiple_upload.dart';
import 'package:example/upload.dart';
import 'package:example/upload_at.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:easy_storage/easy_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // options: DefaultFirebaseOptions.currentPlatform,
      );
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Storage Example'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '''How to use
            1. User must be sign in to upload into Storage. Anonymous login is okay.
            2. The App must have all the setup that required to use Camera and Gallery.
            3. Firebase Storage must be read and the security rules are properly setup.
            ''',
                ),
              ),
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
                      Text('Anonymous User: uid: ${user.uid}'),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: const Text('Sign Out'),
                      ),
                      Upload.image(
                        onUpload: (url) {
                          print('UploadIconButton.image: $url');
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 120,
                              child: Image.network(
                                'https://picsum.photos/120',
                              ),
                            ),
                            const Icon(Icons.camera),
                            const Text('Upload Image'),
                          ],
                        ),
                      ),
                      const UploadButton(),
                      const SizedBox(
                        height: 24,
                      ),
                      UploadAt(uid: user.uid),
                      const SizedBox(
                        height: 24,
                      ),
                      const MultipleUpload(),
                    ],
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
