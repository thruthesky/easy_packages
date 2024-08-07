import 'dart:async';

import 'package:easy_locale/easy_locale.dart';
import 'package:easy_storage/easy_storage.dart';
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

    StorageService.instance.init(
      uploadBottomSheetPadding: const EdgeInsets.all(16),
      uploadBottomSheetSpacing: 16,
    );

    // MessagingService.instance.init(
    //   projectId: DefaultFirebaseOptions.currentPlatform.projectId,
    //   onMessageOpenedFromBackground: (message) {
    //     print('onMessageOpenedFromBackground: $message');
    //   },
    //   onMessageOpenedFromTerminated: (RemoteMessage message) {
    //     print(
    //         'onMessageOpenedFromTerminated: ${message.notification?.title ?? ''} ${message.notification?.body ?? ''}');
    //     alert(
    //       context: context,
    //       title: Text(message.notification?.title ?? ''),
    //       message: Text(message.notification?.body ?? ''),
    //     );
    //   },
    //   onForegroundMessage: (message) {
    //     print('onForegroundMessage: $message');
    //   },
    // );

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

      // MessagingService.instance.getTokens([
      //   'vysiFTQS1ZXSnvS3UnxfeJEpCWN2',
      //   'Jkihj9GMRoNeZ1WXQ5FHMOr3E4c2',
      // ]);

      // MessagingService.instance.send(
      //     uids: [
      //       'vysiFTQS1ZXSnvS3UnxfeJEpCWN2',
      //       'Jkihj9GMRoNeZ1WXQ5FHMOr3E4c2',
      //     ],
      //     title: 'Test from MyApp',
      //     body: 'Test body',
      //     data: {
      //       'key': 'value',
      //     });

      // MessagingService.instance.send(
      //   uids: ['vysiFTQS1ZXSnvS3UnxfeJEpCWN2'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
