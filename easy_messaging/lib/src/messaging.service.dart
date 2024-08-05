import 'dart:io';

import 'package:easy_helpers/easy_helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class MessagingService {
  static MessagingService? _instance;
  static MessagingService get instance => _instance ??= MessagingService._();

  User? get currentUser => FirebaseAuth.instance.currentUser;

  DatabaseReference fcmTokensRef = FirebaseDatabase.instance.ref('fcm_tokens');
  DatabaseReference get myTokensRef => fcmTokensRef.child(currentUser!.uid);

  MessagingService._();

  late Function(RemoteMessage) onForegroundMessage;
  late Function(RemoteMessage) onMessageOpenedFromTerminated;
  late Function(RemoteMessage) onMessageOpenedFromBackground;
  late Function onNotificationPermissionDenied;
  late Function onNotificationPermissionNotDetermined;

  bool initialized = false;
  String? token;

  /// Initialize Messaging Service
  ///
  /// [onBackgroundMessage] - Function to handle background messages.
  init({
    required Future<void> Function(RemoteMessage)? onBackgroundMessage,
    required Function(RemoteMessage) onForegroundMessage,
    required Function(RemoteMessage) onMessageOpenedFromTerminated,
    required Function(RemoteMessage) onMessageOpenedFromBackground,
    required Function onNotificationPermissionDenied,
    required Function onNotificationPermissionNotDetermined,
  }) {
    initialized = true;

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
    _initializeToken();
  }

  _initializeToken() async {
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
        return onNotificationPermissionDenied();
      }
      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        return onNotificationPermissionNotDetermined();
      }
    }

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
        .listen((user) => _updateToken(token));

    /// Token refreshed. update it.
    ///
    /// Run this subscription on the whole lifecycle. (No unsubscription)
    ///
    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => _updateToken(token));

    /// Get token from device and save it into Firestore
    ///
    /// Get the token each time the application loads and save it to database.

    try {
      token = await FirebaseMessaging.instance.getToken() ?? '';
    } on FirebaseException catch (e) {
      dog('Error while getting token: code: ${e.code}, message: ${e.message}, e: $e');
      rethrow;
    }
    await _updateToken(token);
  }

  ///
  Future _updateToken(String? token) async {
    if (token == null || token.isEmpty) return;
    if (currentUser == null) return;
    await myTokensRef.child(token).set(true);
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
      onMessageOpenedFromTerminated(initialMessage);
    }

    // Check if the app is opened(running) from the background state.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onMessageOpenedFromBackground(message);
    });
  }
}
