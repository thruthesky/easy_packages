import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_messaging/easy_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class MessagingService {
  static MessagingService? _instance;
  static MessagingService get instance => _instance ??= MessagingService._();

  static String fcmTokens = "fcm-tokens";

  static String fcmSubscriptions = "fcm-subscriptions";

  User? get currentUser => FirebaseAuth.instance.currentUser;

  static DatabaseReference rootRef = FirebaseDatabase.instance.ref();

  DatabaseReference fcmTokensRef = FirebaseDatabase.instance.ref(fcmTokens);
  Query get myTokenQuery =>
      fcmTokensRef.orderByChild('uid').equalTo(currentUser!.uid);

  DatabaseReference subscriptionRef(String name) =>
      rootRef.child('$fcmSubscriptions/$name/${currentUser!.uid}');

  MessagingService._();

  Function(RemoteMessage)? onForegroundMessage;
  Function(RemoteMessage)? onMessageOpenedFromTerminated;
  Function(RemoteMessage)? onMessageOpenedFromBackground;
  Function? onNotificationPermissionDenied;
  Function? onNotificationPermissionNotDetermined;

  late final String sendMessageApi;
  late final String sendMessageToUidsApi;
  late final String sendMessageToSubscriptionsApi;

  bool initialized = false;
  String? token;

  /// Initialize Messaging Service
  ///
  /// [onBackgroundMessage] - Function to handle background messages.
  init({
    required String sendMessageApi,
    required String sendMessageToUidsApi,
    required String sendMessageToSubscriptionsApi,
    Future<void> Function(RemoteMessage)? onBackgroundMessage,
    Function(RemoteMessage)? onForegroundMessage,
    required Function(RemoteMessage) onMessageOpenedFromTerminated,
    required Function(RemoteMessage) onMessageOpenedFromBackground,
    Function? onNotificationPermissionDenied,
    Function? onNotificationPermissionNotDetermined,
  }) async {
    initialized = true;

    this.sendMessageApi = sendMessageApi;
    this.sendMessageToUidsApi = sendMessageToUidsApi;
    this.sendMessageToSubscriptionsApi = sendMessageToSubscriptionsApi;

    /// Register the background message handler if provided.
    if (onBackgroundMessage != null) {
      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    }

    this.onForegroundMessage = onForegroundMessage;
    this.onMessageOpenedFromTerminated = onMessageOpenedFromTerminated;
    this.onMessageOpenedFromBackground = onMessageOpenedFromBackground;
    this.onNotificationPermissionDenied = onNotificationPermissionDenied;
    this.onNotificationPermissionNotDetermined =
        onNotificationPermissionNotDetermined;

    _initializeEventHandlers();

    await _getPermission();
    _initializeToken();
    _subscribeToTopics();
  }

  _getPermission() async {
    /// Get permission
    ///
    /// Permission request for iOS only. For Android, the permission is granted by default.
    ///
    if (kIsWeb || Platform.isIOS) {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      /// Check if permission had given.
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        onNotificationPermissionDenied?.call() ??
            Exception('messaging/permission-denied Permission Denied');
        return;
      }
      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        onNotificationPermissionNotDetermined?.call() ??
            Exception(
                'messaging/permission-not-determined Permission Not Determined');
        return;
      }
    }
  }

  Future _initializeToken() async {
    /// Save token to database when user logs in (or signs up)
    ///
    /// Subscribe the user auth changes for updating the token for the user.
    ///
    /// Run this subscription on the whole lifecycle. No need to subscribe
    /// since this will be called only one time.
    ///
    /// `/fcm_tokens/<docId>/{token: '...', uid: '...'}`
    /// Save(or update) token
    FirebaseAuth.instance
        .authStateChanges()
        .listen((user) => _saveToken(token));

    /// Token refreshed. update it.
    ///
    /// Run this subscription on the whole lifecycle. (No unsubscription)
    ///
    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => _saveToken(token));

    /// Get token from device and save it into Firestore
    ///
    /// Get the token each time the application loads and save it to database.

    try {
      token = await FirebaseMessaging.instance.getToken() ?? '';
      dog('token: $token');
    } on FirebaseException catch (e) {
      dog('Error while getting token: code: ${e.code}, message: ${e.message}, e: $e');
      rethrow;
    }
    await _saveToken(token);
  }

  /// Save token to database
  ///
  /// Even if the same token exists in the database, it will be overwritten.
  Future _saveToken(String? token) async {
    if (token == null || token.isEmpty) return;
    if (currentUser == null) return;
    final ref = fcmTokensRef.child(token);
    await ref.set(currentUser!.uid);
  }

  Future _subscribeToTopics() async {
    // web does not support topics: https://firebase.google.com/docs/cloud-messaging/flutter/topic-messaging#subscribe_the_client_app_to_a_topic
    if (kIsWeb) return;

    await FirebaseMessaging.instance.subscribeToTopic(Topic.allUsers);
    if (Platform.isAndroid) {
      await FirebaseMessaging.instance.subscribeToTopic(Topic.android);
    } else if (Platform.isIOS) {
      // Don't subscribe for Simulator.
      // It looks like there an issue of subscribing to topics in the simulator.
      // https://github.com/firebase/flutterfire/issues/9822
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      if (iosInfo.isPhysicalDevice == false) {
        return;
      }

      await FirebaseMessaging.instance.subscribeToTopic(Topic.ios);
    } else if (Platform.isMacOS) {
      await FirebaseMessaging.instance.subscribeToTopic(Topic.mac);
    } else if (Platform.isLinux) {
      await FirebaseMessaging.instance.subscribeToTopic(Topic.linux);
    } else if (Platform.isWindows) {
      await FirebaseMessaging.instance.subscribeToTopic(Topic.windows);
    } else if (Platform.isFuchsia) {
      await FirebaseMessaging.instance.subscribeToTopic(Topic.fuchsia);
    }
  }

  /// Initialize Messaging Event Handlers
  ///
  _initializeEventHandlers() async {
    // Handler, when app is on Foreground.
    FirebaseMessaging.onMessage.listen(onForegroundMessage);

    // Check if app is opened from CLOSED(TERMINATED) state and get message data.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      onMessageOpenedFromTerminated?.call(initialMessage);
    }

    // Check if the app is opened(running) from the background state.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onMessageOpenedFromBackground?.call(message);
    });
  }

  /// TODO - send the actual message by calling Cloud functions since the access token for HTTP v1 API is required. and it's not easy to get from flutter client.
  /// Create a cloud function that accepts user uid list and title, body, data, and imageUrl.
  /// Then, send the message to the users.
  /// then, return the result of success or failure to the client.
  send({
    required List<String> uids,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? imageUrl,
    int batchSize = 128,
  }) async {
    /// Get tokens of the users
    final List<String> tokens = await getTokens(uids);

    /// Remove duplicated tokens.
    ///
    ///

    // /// Send messages in batches
    // Uri url =
    //     Uri.https('fcm.googleapis.com', 'v1/projects/$projectId/messages:send');
    // for (String token in tokens) {
    //   http.Response response = await http.post(
    //     url,
    //     body: getPayload(token: token, title: title, body: body, data: data)
    //         .toString(),
    //   );

    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    // }
  }

  /// Get tokens of the users
  ///
  /// [uids] - List of user ids
  Future<List<String>> getTokens(List<String> uids) async {
    final List<String> tokens = [];
    for (var uid in uids) {
      final snapshot = await fcmTokensRef.orderByValue().equalTo(uid).get();
      for (DataSnapshot node in snapshot.children) {
        tokens.add(node.value as String);
      }
    }
    return tokens;
  }

  Map<String, dynamic> getPayload({
    required String token,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? imageUrl,
  }) {
    return {
      "message": {
        "token": token,
        "notification": {
          "title": title,
          "body": body,
        }
      }
    };
  }

  preResponse(http.Response response) {
    dog('Response status: ${response.statusCode}');
    dog('Response body: ${response.body}');
    final decode = jsonDecode(response.body);
    if (decode is Map && decode['error'] is String) {
      throw "messaging/response-error ${decode['error']}";
    }
    return List<String>.from(decode);
  }

  /// Send a message to the users
  Future<List<String>> sendMessage({
    required List<String> tokens,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? imageUrl,
  }) async {
    Uri url = Uri.https(sendMessageApi);
    final re = {
      "title": title,
      "body": body,
      "data": jsonEncode(data),
      if (imageUrl != null) "imageUrl": imageUrl,
      "tokens": tokens.join(',')
    };
    http.Response response = await http.post(
      url,
      body: re,
    );

    return preResponse(response);
  }

  /// Send a message to the users
  Future<List<String>> sendMessageToUid({
    required List<String> uids,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? imageUrl,
  }) async {
    // /// Send messages in batches
    Uri url = Uri.https(sendMessageToUidsApi);
    http.Response response = await http.post(
      url,
      body: {
        "title": title,
        "body": body,
        "data": jsonEncode(data),
        if (imageUrl != null) "imageUrl": imageUrl,
        "uids": uids.join(',')
      },
    );

    return preResponse(response);
  }

  /// Send a message to the users
  Future<List<String>> sendMessageToSubscription({
    required String subscription,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? imageUrl,
  }) async {
    // /// Send messages in batches
    Uri url = Uri.https(sendMessageToSubscriptionsApi);

    final response = await http.post(
      url,
      body: {
        "title": title,
        "body": body,
        "data": jsonEncode(data),
        if (imageUrl != null) "imageUrl": imageUrl,
        "subscription": subscription
      },
    );

    return preResponse(response);
  }
}
