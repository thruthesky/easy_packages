import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_category/easy_category.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_like/easy_like.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
// import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easyuser/easyuser.dart';
import 'package:example/etc/zone_error_handler.dart';
// import 'package:example/firebase_options.dart';
import 'package:example/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() async {
  /// Uncaught Exception 핸들링
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      lo.init();
      await Firebase.initializeApp(
          // options: DefaultFirebaseOptions.currentPlatform,
          );

      UserService.instance.init();
      runApp(const MyApp());

      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.dumpErrorToConsole(details);
      };
    },
    zoneErrorHandler,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    UserService.instance.init();
    // PostService.instance.init(
    //   categories: {
    //     'qna': '질문답변',
    //     'discussion': 'Discussion',
    //     'news': 'News',
    //     'job': '구인구직',
    //     'buyandsell': '사고팔기',
    //     'travel': '여행',
    //     'food': '음식',
    //     'study': '공부',
    //     'hobby': '취미',
    //     'etc': '기타',
    //     'youtube': 'youtube',
    //   },
    // );

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      // ChatService.instance.showChatRoomEditScreen(globalContext);
      // final room = await ChatRoom.get("t5zClWySjgryFf2tK0M8");
      // if (!mounted) return;
      // ChatService.instance.showChatRoomScreen(context, room: room);
      // PostService.instance.showPostCreateScreen(context: globalContext);
      // PostService.instance.showPostEditScreen(context: globalContext);
      // PostService.instance.showPostListScreen(context: globalContext);
      // PostService.instance
      //     .showYoutubeListScreen(context: globalContext, category: 'youtube');

      // showGeneralDialog(
      //   context: globalContext,
      //   pageBuilder: (_, __, ___) => const CommentTestScreen(),
      // );

      // Open post list screen
      // PostService.instance.showPostListScreen(
      //   context: globalContext,
      //   categories: [
      //     Category(id: 'qna', name: 'QnA'),
      //     Category(id: 'discussion', name: 'Discussion'),
      //     Category(id: 'youtube', name: 'Youtube'),
      //     Category(id: 'buyandsell', name: 'Buy and Sell'),
      //     Category(id: 'job', name: 'Jobs'),
      //     Category(id: 'news', name: 'News'),
      //   ],
      // );

      // FirebaseFirestore.instance
      //     .collection('chat-rooms')
      //     .orderBy('users.uidA.nMC', descending: true)
      //     .snapshots()
      //     .listen((event) {
      //   print('chat-room: ${event.docs.length}');
      //   event.docs.map((e) {
      //     print('chat-room: ${e.id}:');
      //   }).toList();
      // });

      /// Open a post detail screen after creating a post.
      // (() async {
      //   final ref = await Post.create(
      //       category: 'yo',
      //       title: 'title-${DateTime.now().jm}',
      //       content: 'content');
      //   final post = await Post.get(ref.id);
      //   PostService.instance
      //       .showPostDetailScreen(context: globalContext, post: post);
      // })();
      // LikeTestService.instance.runTests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
