import 'dart:async';

import 'package:easy_locale/easy_locale.dart';
<<<<<<< Updated upstream
import 'package:easy_messaging/easy_messaging.dart';
=======
import 'package:easy_post_v2/easy_post_v2.dart';
>>>>>>> Stashed changes
import 'package:easy_storage/easy_storage.dart';
// import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easyuser/easyuser.dart';
import 'package:example/etc/zone_error_handler.dart';
// import 'package:example/firebase_options.dart';
// import 'package:example/firebase_options.dart';
import 'package:example/router.dart';
import 'package:example/screens/messaging/messaging.screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

<<<<<<< Updated upstream
import 'package:easy_youtube/easy_youtube.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

=======
>>>>>>> Stashed changes
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

    messagingInit();

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
      /// open messaging screen
      showGeneralDialog(
          context: globalContext,
          pageBuilder: (_, __, ___) {
            return const MessagingScreen();
          });

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
<<<<<<< Updated upstream

      // final youtube =
      //     Youtube(url: 'https://www.youtube.com/watch?v=YBmFxBb9U6g');

      // print('youtube id: ${youtube.getVideoId()}');
      //  // ERROR Youtube not found.
      // final snippet = await youtube.getSnippet(
      //   apiKey: 'AIzaSyDguL0DVfgQQ8YJHfSAJm1t8gCetR0-TdY',
      // );

      // print('snippet: $snippet');
    });
  }

  messagingInit() async {
    MessagingService.instance.init(
      projectId: '', //DefaultFirebaseOptions.currentPlatform.projectId,
      onMessageOpenedFromBackground: (message) {
        WidgetsBinding.instance.addPostFrameCallback((duration) async {
          dog('onMessageOpenedFromBackground: $message');
          alert(
            context: globalContext,
            title: Text(message.notification?.title ?? ''),
            message: Text(message.notification?.body ?? ''),
          );
        });
      },
      onMessageOpenedFromTerminated: (RemoteMessage message) {
        WidgetsBinding.instance.addPostFrameCallback((duration) async {
          dog('onMessageOpenedFromTerminated: ${message.notification?.title ?? ''} ${message.notification?.body ?? ''}');
          alert(
            context: globalContext,
            title: Text(message.notification?.title ?? ''),
            message: Text(message.notification?.body ?? ''),
          );
        });
      },
      onForegroundMessage: (message) {
        dog('onForegroundMessage: $message');
      },
    );

    /// Android Head-up Notification
    if (isAndroid) {
      /// Set a channel for high importance notifications.
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description: 'This channel is used for important notifications.', //
        importance: Importance.max, // max 로 해야 Head-up display 가 잘 된다.
        showBadge: true,
        enableVibration: true,
        playSound: true,
=======
      PostService.instance.init(
        youtubeDataApi: 'AIzaSyDguL0DVfgQQ8YJHfSAJm1t8gCetR0-TdY',
>>>>>>> Stashed changes
      );
      // final youtube =
      //     Youtube(url: 'https://www.youtube.com/watch?v=YBmFxBb9U6g');

<<<<<<< Updated upstream
      /// Register the channel with the system.
      /// If there is already a registed channel (with same id), then it will be re-registered.
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
=======
      // print('youtube id: ${youtube.getVideoId()}');

      // // youtube.getVideoId();
      // final snippet = await youtube.getSnippet(
      //   apiKey: 'AIzaSyDguL0DVfgQQ8YJHfSAJm1t8gCetR0-TdY',
      // );
      // print(' default url :${snippet.thumbnails['default']}');
      // print('snippet: ${snippet.statistics}');
    });
>>>>>>> Stashed changes
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
