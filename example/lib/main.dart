import 'dart:async';

import 'package:easy_comment/easy_comment.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_like/easy_like.dart';

import 'package:easy_locale/easy_locale.dart';
import 'package:easy_messaging/easy_messaging.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_report/easy_report.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easychat/easychat.dart';
// import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easyuser/easyuser.dart';
import 'package:example/etc/zone_error_handler.dart';
// import 'package:example/firebase_options.dart';
// import 'package:example/firebase_options.dart';
import 'package:example/router.dart';
import 'package:example/screens/user/sign_in.screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

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
    postInit();
    commentInit();
    chatInit();
    reportInit();
    likeInit();
    applyChatLocales();

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
      // showGeneralDialog(
      //     context: globalContext,
      //     pageBuilder: (_, __, ___) {
      //       return const MessagingScreen();
      //     });

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

  /// Sample Remote Message handling
  /// When receive message we can redirect or do whatever base from the data
  /// like redirect to post, chat, user profile or display on the screen after the message is click from device trays.
  ///
  handleRemoteMessage(RemoteMessage message) async {
    dog('handleRemoteMessage: ${message.notification?.title ?? ''} ${message.notification?.body ?? ''}');

    /// If action chat, redirect to chat
    if (message.data['action'] == 'chat') {
      ChatRoom? room = await ChatRoom.get(message.data['roomId']);
      if (room != null && globalContext.mounted) {
        ChatService.instance.showChatRoomScreen(
          globalContext,
          room: room,
        );
      }

      /// If action is chatInvite, redirect to chat invite list
    } else if (message.data['action'] == 'chatInvite') {
      ChatService.instance.showInviteListScreen(globalContext);

      /// If action is post or comment then redirect to post view screen
    } else if (message.data['action'] == 'post' ||
        message.data['action'] == 'comment') {
      Post post = await Post.get(message.data['postId']);
      if (globalContext.mounted) {
        PostService.instance.showPostDetailScreen(
          context: globalContext,
          post: post,
        );
      }

      /// If action is like, redirect base from the source of like.
      /// the following example came from post like
      /// so redirect to post view screen.
      /// redirect page may differ depends on the developer
      /// e.g the like came from profile like, then should redirect to profile page
    } else if (message.data['action'] == 'like') {
      if (message.data['source'] == 'post') {
        Post post = await Post.get(message.data['postId']);
        if (globalContext.mounted) {
          PostService.instance.showPostDetailScreen(
            context: globalContext,
            post: post,
          );
        }
      }

      /// if like is report, then mostly we redirect to admin report list screen
    } else if (message.data['action'] == 'report') {
      debugPrint("e.g. open report list screen for admin");
      alert(
        context: globalContext,
        title: Text("Report ${message.notification?.title ?? ''}"),
        message:
            Text("${message.notification?.body} ${message.data.toString()}"),
      );

      /// or display something if on the screen
    } else {
      alert(
        context: globalContext,
        title: Text(
            "Notification wasnt handled0 ${message.notification?.title ?? ''}"),
        message:
            Text("${message.notification?.body} ${message.data.toString()}"),
      );
    }
  }

  messagingInit() async {
    MessagingService.instance.init(
      sendMessageApi: 'https://sendmessage-mkxv2itpca-uc.a.run.app',
      sendMessageToUidsApi: 'https://sendmessagetouids-mkxv2itpca-uc.a.run.app',
      sendMessageToSubscriptionsApi:
          'https://sendmessagetosubscription-mkxv2itpca-uc.a.run.app',
      onMessageOpenedFromBackground: (message) {
        WidgetsBinding.instance.addPostFrameCallback((duration) async {
          dog('onMessageOpenedFromBackground: $message');
          handleRemoteMessage(message);
        });
      },
      onMessageOpenedFromTerminated: (RemoteMessage message) {
        WidgetsBinding.instance.addPostFrameCallback((duration) async {
          dog('onMessageOpenedFromTerminated: $message');
          handleRemoteMessage(message);
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
      );

      // final youtube =
      //     Youtube(url: 'https://www.youtube.com/watch?v=YBmFxBb9U6g');

      /// Register the channel with the system.
      /// If there is already a registed channel (with same id), then it will be re-registered.
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }

    // print('youtube id: ${youtube.getVideoId()}');

    // // youtube.getVideoId();
    // final snippet = await youtube.getSnippet(
    //   apiKey: 'AIzaSyDguL0DVfgQQ8YJHfSAJm1t8gCetR0-TdY',
    // );
    // print(' default url :${snippet.thumbnails['default']}');
    // print('snippet: ${snippet.statistics}');
    // });
  }

  postInit() {
    PostService.instance.init(
      postListActionButton: (category) => PushNotificationToggleIcon(
        subscriptionName: category.isNullOrEmpty
            ? 'post-sub-no-category'
            : "post-sub-$category",
      ),
      onCreate: (Post post) async {
        /// send push notification to subscriber
        MessagingService.instance.sendMessageToSubscription(
          subscription: post.category.isNullOrEmpty
              ? 'post-sub-no-category'
              : "post-sub-${post.category}",
          title: 'post title ${post.title}  ${DateTime.now()}',
          body: 'post body ${post.content}',
          data: {
            "action": 'post',
            'postId': post.id,
          },
        );
      },
    );
  }

  commentInit() {
    CommentService.instance.init(
      onCreate: (Comment comment) async {
        /// get ancestor uid
        List<String> ancestorUids =
            await CommentService.instance.getAncestorsUid(comment.id);

        Post post = await Post.get(comment.documentReference.id);
        if (myUid != null && post.uid != myUid) {
          ancestorUids.add(post.uid);
        }

        if (ancestorUids.isEmpty) return;

        /// set push notification to remaining uids
        /// can get comment or post to send more informative push notification
        MessagingService.instance.sendMessageToUid(
          uids: ancestorUids,
          title: 'title ${DateTime.now()}',
          body: 'ancestorComment test ${comment.content}',
          data: {
            "action": 'comment',
            'commentId': comment.id,
            'postId': comment.documentReference.id,
          },
        );
      },
    );
  }

  /// (Trick) When user disable the notification, then, subscribe !!.
  ///   -> Meaning, when user turn off the notification, then, the uid is saved true in the subscription. This is a reverse logic.
  ///   -> When user turn on the notification, then, delete the uid from the subscription.
  ///
  /// When a user send chat message, call 'sendMessageToUid' with the 'subscription name' and uid list.
  /// With the option of 'excludeSubscribers: true', the backend will send messages to the users whose uid is not in the list of subscription.
  chatInit() {
    ChatService.instance.init(
      /// On chat, users on chatRoom always get  notification unless they turn it off.
      /// To show that the notification is active, PushNotificationToggleIcon is reverse
      /// This will show the Icon as enabled by default, and when click it will set `uid:true` to subscription name
      /// which later on we se set on the `onSendMessage` -> `sendMessageToUid` with parameter of excludeSubscribers.
      /// This will remove the uid of those who has /path/subscriptionName/uid:true from the list of uids
      chatRoomActionButton: (room) => PushNotificationToggleIcon(
        subscriptionName: room.id,
        reverse: true,
      ),
      onSendMessage: (
          {required ChatMessage message, required ChatRoom room}) async {
        final uids = room.userUids.where((uid) => uid != myUid).toList();
        if (uids.isEmpty) return;
        MessagingService.instance.sendMessageToUid(
          uids: uids,
          subscriptionName: room.id,
          excludeSubscribers: true,
          title: 'ChatService ${DateTime.now()}',
          body: '${message.text} ${room.id} ${message.id} ',
          data: {"action": 'chat', 'roomId': room.id},
        );
      },
      onInvite: ({required ChatRoom room, required String uid}) async {
        MessagingService.instance.sendMessageToUid(
          uids: [uid],
          title: 'Chat Invite ${DateTime.now()}',
          body:
              '${my.displayName} Has invited you to join the chat room ${room.id} ${room.name}',
          data: {"action": 'chatInvite', 'roomId': room.id},
        );
      },
      loginButtonBuilder: (context) {
        return TextButton(
          child: Text("Login".t),
          onPressed: () {
            context.push(SignInScreen.routeName);
          },
        );
      },
    );
  }

  reportInit() {
    ReportService.instance.init(
      onCreate: (Report report) async {
        /// set push notification. e.g. send push notification to reportee
        /// or developer can send push notification to admin
        MessagingService.instance.sendMessageToUid(
          uids: [report.reportee],
          title: 'You have been reported',
          body: 'Report reason ${report.reason}',
          data: {
            "action": 'report',
            'reportId': report.id,
            'documentReference': report.documentReference.toString(),
          },
        );
      },
    );
  }

  likeInit() {
    LikeService.instance.init(
      onLiked: ({required Like like, required bool isLiked}) async {
        /// only send notification if it is liked
        if (isLiked == false) return;

        /// get the like document reference for more information
        /// then base from the document reference you can swich or decide where the notificaiton should go
        /// set push notification. e.g. send push notification to post like
        if (like.documentReference.toString().contains('posts/')) {
          Post post = await Post.get(like.documentReference.id);

          /// dont send push notification if the owner of the post is the loggin user.
          if (post.uid == myUid) return;

          /// can get more information base from the documentReference
          /// can give more details on the push notification
          MessagingService.instance.sendMessageToUid(
            uids: [post.uid],
            title: 'Your post got liked',
            body: '${my.displayName} liked ${post.title}',
            data: {
              "action": 'like',
              "source": 'post',
              'postId': post.id,
              'documentReference': like.documentReference.toString(),
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
