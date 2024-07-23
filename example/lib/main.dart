import 'dart:async';

import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easyuser/easyuser.dart';
import 'package:example/etc/zone_error_handler.dart';
// import 'package:example/firebase_options.dart';
import 'package:example/router.dart';
import 'package:example/screens/forum/comment.test.screen.dart';
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
    PostService.instance.init(
      categories: {
        'qna': '질문답변',
        'discussion': 'Discussion',
        'news': 'News',
        'job': '구인구직',
        'buyandsell': '사고팔기',
        'travel': '여행',
        'food': '음식',
        'study': '공부',
        'hobby': '취미',
        'etc': '기타',
        'youtube': 'youtube',
      },
    );

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // ChatService.instance.showChatRoomEditScreen(globalContext);
      // PostService.instance.showPostCreateScreen(context: globalContext);
      // PostService.instance.showPostEditScreen(context: globalContext);
      // PostService.instance.showPostListScreen(context: globalContext);
      // PostService.instance
      //     .showYoutubeListScreen(context: globalContext, category: 'youtube');

      showGeneralDialog(
        context: globalContext,
        pageBuilder: (_, __, ___) => const CommentTestScreen(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
