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

  DatabaseReference subscriptionRef(String subscriptionName) =>
      rootRef.child('$fcmSubscriptions/$subscriptionName/${currentUser!.uid}');

  MessagingService._();

  Function(RemoteMessage)? onForegroundMessage;
  Function(RemoteMessage)? onMessageOpenedFromTerminated;
  Function(RemoteMessage)? onMessageOpenedFromBackground;
  Function? onNotificationPermissionDenied;
  Function? onNotificationPermissionNotDetermined;

  /// Firebase function API url [sendmessageToTokens] API to send push notification via tokens
  late final String sendMessageToTokensApi;

  /// Firebase function API url [sendmessageToUids] API to send push notification via uids
  late final String sendMessageToUidsApi;

  /// Firebase function API url [sendmessageToSubscription] API to send push notification via subscription
  late final String sendMessageToSubscriptionApi;

  bool initialized = false;

  /// Current Device token
  String? token;

  /// Initialize Messaging Service
  ///
  /// [onBackgroundMessage] - Function to handle background messages.
  ///   This is invoked when the app is closed(terminated). (NOT running the app.)
  ///   Usage: (updating icon badge, etc.)
  ///
  /// [onForegroundMessage] will be called when the user(or device) receives a push notification
  /// while the app is running and in foreground state.
  ///
  /// [onMessageOpenedFromBackground] will be called when the user tapped on the push notification
  ///
  /// [onMessageOpenedFromTerminated] will be called when the user tapped on the push notification
  /// on system tray while the app was closed(terminated).
  ///
  ///
  init({
    required String sendMessageToTokensApi,
    required String sendMessageToUidsApi,
    required String sendMessageToSubscriptionApi,
    Future<void> Function(RemoteMessage)? onBackgroundMessage,
    Function(RemoteMessage)? onForegroundMessage,
    required Function(RemoteMessage) onMessageOpenedFromTerminated,
    required Function(RemoteMessage) onMessageOpenedFromBackground,
    Function? onNotificationPermissionDenied,
    Function? onNotificationPermissionNotDetermined,
  }) async {
    if (initialized) {
      dog('MessagingService: already initialized');
      return;
    }
    initialized = true;

    this.sendMessageToTokensApi = sendMessageToTokensApi;
    this.sendMessageToUidsApi = sendMessageToUidsApi;
    this.sendMessageToSubscriptionApi = sendMessageToSubscriptionApi;

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

  /// Subscribe to default topics, such as individual platform topics and `allUserTopics`.
  ///
  Future _subscribeToTopics() async {
    // web does not support topics: https://firebase.google.com/docs/cloud-messaging/flutter/topic-messaging#subscribe_the_client_app_to_a_topic
    if (kIsWeb) return;

    /// Subscribe user base on their platform
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

    /// Subscribe all user to allUsers topic
    await FirebaseMessaging.instance.subscribeToTopic(Topic.allUsers);
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

  ///
  /// Preprocess respose
  /// Return the list of tokens that has errors,
  /// If error throw error message
  ///
  preResponse(http.Response response) {
    dog('preResponse status: ${response.statusCode}');
    dog('preResponse body: ${response.body}');
    final decode = jsonDecode(response.body);
    if (decode is Map && decode['error'] is String) {
      throw "messaging/response-error ${decode['error']}";
    }
    return List<String>.from(decode);
  }

  /// Send a message to the users via tokens
  /// Send messages to specific token
  Future<List<String>> sendMessageToTokens({
    required List<String> tokens,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? imageUrl,
  }) async {
    final http.Response response = await httpPost(
      sendMessageToTokensApi,
      {
        "title": title,
        "body": body,
        "data": data,
        if (imageUrl != null) "imageUrl": imageUrl,
        "tokens": tokens,
      },
    );

    return preResponse(response);
  }

  /// Send a message to the users with list of uid
  /// [uids] are the list of uid to send the notification
  /// If the logic requires you to excluded uids that are subscribe to specific fcm-subscription,
  /// you can use [excludeSubscribers] and set to true, and profile the [subscriptionName].
  /// This will remove any uid from the list that are existing on `fcm-subscription/$subscriptionName`
  ///
  Future<List<String>> sendMessageToUids({
    required List<String> uids,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? imageUrl,
    String subscriptionName = '',
    bool excludeSubscribers = false,
  }) async {
    final http.Response response = await httpPost(
      sendMessageToUidsApi,
      {
        "title": title,
        "body": body,
        "data": data,
        "uids": uids,
        "subscriptionName": subscriptionName,
        "excludeSubscribers": excludeSubscribers,
        if (imageUrl != null) "imageUrl": imageUrl,
      },
    );

    return preResponse(response);
  }

  /// Send a message to the users via subscriptions
  /// [subscription] is the string use to check in cloud function if there are subscribers
  /// `fcm-subscriptions/$subscription` path will be check if any uid are added here will receive the push notification
  ///
  Future<List<String>> sendMessageToSubscription({
    required String subscription,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    String? imageUrl,
  }) async {
    final http.Response response = await httpPost(
      sendMessageToSubscriptionApi,
      {
        "title": title,
        "body": body,
        "data": data,
        if (imageUrl != null) "imageUrl": imageUrl,
        "subscription": subscription
      },
    );

    return preResponse(response);
  }

  /// Prepare http post request
  /// Parse the given API url
  /// Attach header with ['Content-Type': 'application/json']
  /// and jsonEncoded the body data
  Future<http.Response> httpPost(String url, Map<String, dynamic> body) {
    return http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }
}
