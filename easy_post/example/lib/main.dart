import 'dart:developer';

import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/unit_test/post_test.dart';
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
  final titleController = TextEditingController();
  final titleFocus = FocusNode();

  @override
  initState() {
    super.initState();

    test();
  }

  final category = 'temp';
  final postId = '-O7RYUgbwalTmb8-YSbD';

  test() async {
    // final category = randomString(length: 3);
    // final ref1 = await Post.create(category: category, title: '1');
    // final ref2 = await Post.create(category: category, title: '2');
    // final ref3 = await Post.create(category: category, title: '3');
    // final ref4 = await Post.create(category: category, title: '4');
    // final ref5 = await Post.create(category: category, title: '5');

    // final ref = PostService.instance.postsRef
    //     .orderByChild('category')
    //     .startAt('$category-')
    //     .endAt('$category-9999999999999999999999');

    // final snapshot = await ref.get();
    // for (var v in snapshot.children) {
    //   log('v: ${v.key}, value: ${(v.value as Map)["title"]}');
    // }
  }

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
            : Column(
                children: [
                  Wrap(
                    // mainAxisAlignment: MainAxisAlignment.center,
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
                          final post = await Post.get(ref.key!);
                          if (!context.mounted) return;
                          PostService.instance.showPostDetailScreen(context: context, post: post);
                        },
                        text: 'Create Post',
                      ),
                      btn(
                        onPressed: () async {
                          final post = await Post.get(postId);
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
                  TextField(
                    controller: titleController,
                    autofocus: true,
                    focusNode: titleFocus,
                    onSubmitted: (v) {
                      titleController.clear();
                      Post.create(category: category, title: v);
                      titleFocus.requestFocus();
                    },
                  ),
                  Expanded(child: PostListView(category: category)),
                ],
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
