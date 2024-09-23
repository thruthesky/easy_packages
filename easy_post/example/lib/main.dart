import 'dart:developer';

import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:example/categories/categories.dart';
import 'package:example/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:easyuser/easyuser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
  }

  final category = 'yo';
  final postId = '-O7RYUgbwalTmb8-YSbD';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Screen'),
      ),
      body: AuthStateChanges(
        builder: (user) => user == null
            ? const Center(
                child: EmailPasswordLogin(),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user.uid),
                      btn(
                          onPressed: () {
                            UserService.instance.signOut();
                          },
                          text: 'Sign Out'),
                      btn(
                        onPressed: () async {
                          final ref = await Post.create(category: 'yo', title: 'title', content: 'content');
                          log('ref: $ref, key: ${ref.key}');
                          final post = await Post.get(category, ref.key);
                          if (!context.mounted) return;
                          PostService.instance.showPostDetailScreen(context: context, post: post);
                        },
                        text: 'Create Post',
                      ),
                      btn(
                        onPressed: () async {
                          final post = await Post.get(category, postId);
                          if (!context.mounted) return;
                          PostService.instance.showPostDetailScreen(context: context, post: post);
                        },
                        text: 'Show Post',
                      ),
                      btn(
                        onPressed: () {
                          PostService.instance.showPostListScreen(context: context, categories: categories);
                        },
                        text: 'View Categories',
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  btn({required VoidCallback onPressed, required String text}) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
