import 'dart:async';

import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:easy_engine/easy_engine.dart';

/// The user's reference. Helper function.
DatabaseReference userRef(String uid) => UserService.instance.usersRef.child(uid);

/// The user's field reference. Helper function.
DatabaseReference userFieldRef(String uid, String field) => userRef(uid).child(field);

/// This is the user service class that will be used to manage the user's authentication and user data management.
class UserService {
  static UserService? _instance;
  static UserService get instance => _instance ??= UserService._();

  UserService._();

  bool initialized = false;

  fa.FirebaseAuth get auth => fa.FirebaseAuth.instance;

  FirebaseDatabase get database => FirebaseDatabase.instance;

  DatabaseReference get usersRef => database.ref().child('users');

  DatabaseReference get metaRef => database.ref().child('user-meta');

  DatabaseReference get blockDoc => metaRef.child(myUid!).child('blocks');

  User? user;
  BehaviorSubject<User?> changes = BehaviorSubject();

  /// List of blocked users by the login user.
  ///
  ///
  /// The document of `users/user-meta/block` that holds the block information
  /// of other users.
  /// This data is updated in real-time.
  Map<String, dynamic> blocks = {};

  /// Fires whenever the user blocking data changes.
  BehaviorSubject<Map<String, dynamic>> blockChanges = BehaviorSubject.seeded({});

  /// Enable anonymous sign in, by default it is false.
  ///
  /// If it is true, the user will automatically sign in (as anonymous) when
  /// the user signs out. This may lead confusion!
  ///
  bool enableAnonymousSignIn = false;

  /// to replace the fireflutter public profile screen, you can provide
  /// your own public profile screen in user initialization
  /// ex.
  /// ```dart
  /// UserService.intance.init(
  ///  publicProfileScreen: (user) {
  ///     return MyPublicProfileScreen(user: user);
  ///   }
  /// );
  /// ```
  Widget Function(BuildContext, User?)? $showPublicProfileScreen;
  Widget Function()? $showProfileUpdateScreen;

  /// Current user of Firebase Auth
  fa.User? get currentUser => fa.FirebaseAuth.instance.currentUser;

  /// Buttons on user profile sreen.
  List<Widget> Function(User)? prefixActionBuilderOnPublicProfileScreen;
  List<Widget> Function(User)? suffixActionBuilderOnPublicProfileScreen;

  /// True if the user is signed in with phone number.
  bool get isPhoneSignIn => currentUser?.providerData.where((e) => e.providerId == 'phone').isNotEmpty ?? false;

  init({
    bool enableAnonymousSignIn = false,
    Widget Function(BuildContext, User?)? showPublicProfileScreen,
    Widget Function()? showProfileUpdateScreen,
    List<Widget> Function(User)? prefixActionBuilderOnPublicProfileScreen,
    List<Widget> Function(User)? suffixActionBuilderOnPublicProfileScreen,
  }) {
    if (initialized) {
      dog('UserService is already initialized; It will not initialize again.');
      return;
    }

    dog('UserService::init() begins;');

    initialized = true;

    this.prefixActionBuilderOnPublicProfileScreen = prefixActionBuilderOnPublicProfileScreen;
    this.suffixActionBuilderOnPublicProfileScreen = suffixActionBuilderOnPublicProfileScreen;

    this.enableAnonymousSignIn = enableAnonymousSignIn;
    listenDocumentChanges();
    $showPublicProfileScreen = showPublicProfileScreen;
    $showProfileUpdateScreen = showProfileUpdateScreen;
  }

  /// Returns true if user is signed in including anonymous login.
  bool get signedIn => currentUser != null;
  bool get notSignedIn => !signedIn;
  bool get anonymous => currentUser?.isAnonymous ?? false;

  /// Returns true if user is registered and not anonymous.
  ///
  /// It excludes anonymous users.
  bool get registered => signedIn && !anonymous;

  /// Listen to my document
  StreamSubscription<fa.User?>? firebaseAuthSubscription;

  StreamSubscription<DatabaseEvent>? firebaseMyDocSubscription;

  /// StreamSubscription from "blocks" in RTDB
  StreamSubscription<DatabaseEvent>? firebaseBlockingSubscription;
  // StreamSubscription<DocumentSnapshot>? firestoreBlockingSubscription;

  listenDocumentChanges() {
    firebaseAuthSubscription?.cancel();
    // .distinct((p, n) => p?.user?.uid == n?.user?.uid)
    firebaseAuthSubscription = fa.FirebaseAuth.instance.authStateChanges().listen((faUser) async {
      /// User state changed

      /// User signed out
      if (faUser == null) {
        dog('Firebase User is null. User signed out.');
        user = null;
        changes.add(user);

        /// Clear user blocking data
        blocks = {};
        blockChanges.add(blocks);
        initAnonymousSignIn();
      } else {
        /// User signed in (or changed)

        /// The signed user's ref.
        final signedInUserRef = usersRef.child(faUser.uid);

        /// * Fire user document update immediately *
        /// This is required for the case where the app(or device) has no
        /// internet. This will trigger the [UserService.instance.changes] to
        /// update the user document. And this will lead [MyDoc] to be rebuild.
        ///
        /// Refer README.md for more details.
        try {
          // If there is cache, use it.
          final databaseEvent = await signedInUserRef.once();
          if (!databaseEvent.snapshot.exists) throw "User not cached!";
          user = User.fromDatabaseSnapshot(databaseEvent.snapshot);
          changes.add(user);
        } catch (e) {
          // If there is no cache, use the uid.
          user = User.fromUid(faUser.uid);
          changes.add(user);
        }

        /// User is anonymous
        dog('User signed in. The Firebase User is${faUser.isAnonymous ? ' ' : " NOT "}anonymous');

        /// User signed in. Listen to the user's document changes.
        firebaseMyDocSubscription?.cancel();

        /// 사용자 문서 초기화
        await initUserLogin(faUser.uid);

        firebaseMyDocSubscription = signedInUserRef.onValue.listen((event) {
          // 주의: 여기서는 어떤 경우에도 사용자 문서를 업데이트해서는 안된다.
          user = event.snapshot.exists ? User.fromDatabaseSnapshot(event.snapshot) : null;
          changes.add(user);
        });

        firebaseBlockingSubscription?.cancel();

        firebaseBlockingSubscription = blockDoc.onValue.listen((event) {
          blocks = Map<String, dynamic>.from((event.snapshot.value ?? {}) as Map);
          // dog('updated blocks: $blocks');
          blockChanges.add(blocks);
        });
      }
    });
  }

  /// Initialize anonymous sign in if the app is configured to do so.
  initAnonymousSignIn() async {
    if (enableAnonymousSignIn != true) return;
    final user = currentUser;
    if (user != null) return;
    dog('initAnonymousSignIn: sign in anonymously');
    await auth.signInAnonymously();
  }

  /// Get my user document
  Future<void> signOut() async {
    await auth.signOut();
  }

  /// Initialize(update) user document on login
  ///
  /// This method should be called when
  /// - app restarts
  /// - user sign in with any method (email, google, phone, etc.)
  /// - And especially when the user signs-in and does **linkWithCredential()**
  ///   This method will
  ///   - record phone number if needed
  ///   - update lastLoginAt causing the user document to be updated and this
  ///     will trigger the `MyDoc` will be rebuild. So, if the user signed in
  ///     as anonymous, the user will be updated to the real user.
  ///
  /// The purpose of the method is to
  /// - create the user document if it's not exist
  /// - create `createdAt` if it is not exists.
  /// - update `lastLoginAt` on every login.
  ///
  /// Firebase 로그인을 하고, 사용자 문서가 존재 할 수 있고, 존재하지 않을 수 있다.
  /// 사용자 문서가 존재하지 않거나, createdAt 이 null 이면, createdAt 을 생성한다.
  /// 즉, createdAt 은 최초 1회만 생성되므로, 사용자 문서 생성 시, 최초 1회 동작이 필요하다면,
  /// 이 루틴에서 하면 된다.
  ///
  /// lastLoginAt 은 로그인 할 때 마다 업데이트한다.
  ///
  /// Initialize user document on login
  ///
  /// Create `createdAt` if it is not exists.
  /// Update `lastLoginAt` on every login.
  initUserLogin(String uid) async {
    _recordPhoneSignInNumber(uid);

    /// 나의 정보를 가져온다.
    final got = await User.get(uid, cache: false);

    final Map<String, dynamic> data = {
      'lastLoginAt': ServerValue.timestamp,
    };

    if (got == null || got.createdAt == null) {
      data['createdAt'] = ServerValue.timestamp;
    }

    final u = User.fromUid(uid);

    /// Create or update the user data
    await u.ref.update(
      data,
    );
  }

  /// Record the phone number if the user signed in as Phone sign-in auth.
  ///
  /// See README.md for details
  ///
  /// Whenever a user signs in with phone number, the phone number is recorded.
  /// Even if the user signs out and signs in again with the same phone number,
  /// the phone number is recorded over again.
  ///
  /// It will also record again when the app restarts.
  Future<void> _recordPhoneSignInNumber(String uid) async {
    if (!isPhoneSignIn) return;
    dog('Phone sign-in user signed in. Record the phone number.');

    // update the phone number in `/user-phone-sign-in-numbers`.
    final phoneNumber = currentUser?.phoneNumber;
    if (phoneNumber != null) {
      final ref = database.ref().child('user-phone-sign-in-numbers').child(phoneNumber);
      await ref.set({
        'lastSignedInAt': ServerValue.timestamp,
      });
    }
  }

  /// Check if the phone number is registered.
  ///
  /// This is used to know if the phone number is already in use especially in
  /// the 'linkWithCredential' with phone sign-in process. Since SMS OTP can be
  /// used it only one time, if the phone number is already in use, the app
  /// should use 'signInWithCredential' instead of 'linkWithCredential'. And to
  /// do this, it needs to know if the phone number is already in use.
  ///
  /// See README.md for details
  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    final doc = database.ref().child('user-phone-sign-in-numbers').child(phoneNumber).child("lastSignedInAt");
    final snapshot = await doc.get();
    return snapshot.exists;
  }

  // to display public profile user `UserService.intance.showPublicProfile`
  // this will display publicProfile from fireflutter
  showPublicProfileScreen(
    BuildContext context, {
    required User user,
  }) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return $showPublicProfileScreen?.call(context, user) ?? UserPublicProfileScreen(user: user);
      },
    );
  }

  showProfileUpdaeScreen(BuildContext context) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) => $showProfileUpdateScreen?.call() ?? const UserProfileUpdateScreen(),
    );
  }

  /// To easily display userSearchDialog you can use
  /// `UserService.intance.showUserSearchDialog`
  @Deprecated('Use showSearchDialog instead')
  Future<User?> showUserSearchDialog(
    BuildContext context, {
    Widget Function(bool)? emptyBuilder,
    EdgeInsetsGeometry? padding,
    Widget Function(User, int)? itemBuilder,
    bool exactSearch = true,
    bool searchName = false,
    bool searchNickname = false,
  }) {
    return showDialog<User?>(
      context: context,
      builder: (context) => UserSearchDialog(
        emptyBuilder: emptyBuilder,
        padding: padding,
        itemBuilder: itemBuilder,
        exactSearch: exactSearch,
        searchName: searchName,
        searchNickname: searchNickname,
      ),
    );
  }

  /// Display a dialog to search users.
  ///
  /// Return:
  /// - null if the dialog is canceled.
  /// - User if the user is selected.
  Future<User?> showSearchDialog(
    BuildContext context, {
    Widget Function(bool)? emptyBuilder,
    EdgeInsetsGeometry? padding,
    Widget Function(User, int)? itemBuilder,
    bool exactSearch = true,
    bool searchName = false,
    bool searchNickname = false,
  }) {
    return showDialog<User?>(
      context: context,
      builder: (context) => UserSearchDialog(
        emptyBuilder: emptyBuilder,
        padding: padding,
        itemBuilder: itemBuilder,
        exactSearch: exactSearch,
        searchName: searchName,
        searchNickname: searchNickname,
      ),
    );
  }

  /// Blocks other user.
  ///
  ///
  /// User can block other user.
  /// The block has some UI logic and you may put the block button any where in
  /// the app.
  /// Use this method to block a user for the unified block logic.
  ///
  /// This method toggles the block status.
  ///
  /// Since the block has some logic of displaying the confirmation dialog,
  /// it is better to use this method to unify the block logic.
  ///
  /// This method toggles the block status.
  ///
  ///
  /// Return
  /// - null if the block is canceled or failed to do the action.
  /// - true if the user is blocked.
  /// - false if the user is un-blocked (from blocked)
  ///
  Future<bool?> block({
    required BuildContext context,
    required String otherUid,
  }) async {
    if (otherUid == myUid) {
      toast(context: context, message: Text('you cannot block yourself'.t));
      return null;
    }

    /// Display user info as subtitle in the confirmation dialog.
    Widget userInfoSubtitle = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        UserAvatar.fromUid(uid: otherUid),
        DisplayName(uid: otherUid),
      ],
    );

    /// The user is alredy blocked?
    if (blocks.containsKey(otherUid)) {
      /// Ask if the login-user want to un-block the user.
      final re = await confirm(
        context: context,
        title: Text('un-block confirm title'.t),
        subtitle: userInfoSubtitle,
        message: Text('un-block confirm message'.t),
      );
      if (re != true) return null;

      await blockDoc.update({
        otherUid: null,
      });
      if (context.mounted) {
        toast(context: context, message: Text('user is un-blocked'.t));
      }
      return false;
    }

    final re = await confirm(
        context: context,
        title: Text('block confirm title'.t),
        subtitle: userInfoSubtitle,
        message: Text(
          'block confirm message'.t,
        ));
    if (re != true) return null;

    await blockDoc.update({
      otherUid: {
        'blockedAt': ServerValue.timestamp,
      },
    });

    if (context.mounted) {
      toast(context: context, message: Text('user is blocked'.t));
    }
    return true;
  }

  showBlockListScreen(BuildContext context) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) => const UserBlockListScreen(),
    );
  }

  /// when user resign the user document, user auth, and photo from storage will be deleted.
  Future<void> resign() async {
    try {
      if (my.photoUrl != null) {
        await StorageService.instance.delete(my.photoUrl);
      }
      await my.delete();
    } catch (e) {
      dog('UserService.resign Error--->$e');
      throw 'UserSerive.resign/failed-to-delete-document Failed to delete user document';
    }
    try {
      await engine.deleteAccount();
    } catch (e) {
      dog('UserService.resign Error--->$e');
      throw 'UserSerive.resign/failed-to-delete-document Failed to delete user Auth Credentials';
    }
    i.signOut();
  }
}
