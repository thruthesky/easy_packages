// import 'package:firebase_core/firebase_core.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:memory_cache/memory_cache.dart';

/// UserDoc
///
/// Gets user data from Realtime Database and keep it in memory cache.
///
/// [uid] User's uid.
///
/// There are three different modes.
///
/// [sync] if [sync] is set to true, then it will display widget with memory
/// data first, then it gets data from server in realtime and updates the
/// widget again. Whenever the data changes in the server, it will update the
/// widget.
///
/// If [cache] is set to true, then it uses cached memory data only. It does
/// not get data from server. But if there is no cached data, then it gets data
/// from the server.
///
/// If [cache] is set to false, it will display the widget with the memory data
/// and gets the data from server and update the widget again.
///
/// If [sync] and [cache] are set to true at the same time, then [cache] is
/// ignored.
class UserDoc extends StatelessWidget {
  const UserDoc({
    required this.uid,
    this.cache = true,
    required this.builder,
    this.sync = false,
    super.key,
  });
  final String uid;
  final bool cache;
  final Widget Function(User?) builder;
  final bool sync;

  @override
  Widget build(BuildContext context) {
    if (sync) {
      return StreamBuilder<User>(
        initialData: MemoryCache.instance.read<User?>(uid),
        stream: UserService.instance.mirrorUsersRef.child(uid).onValue.map(
              (s) => User.fromDatabaseSnapshot(s.snapshot),
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.hasData == false) {
            return const SizedBox.shrink();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          /// Got data from database
          User? user = snapshot.data;

          /// Save it into memory
          MemoryCache.instance.create(uid, user);
          return builder(user);
        },
      );
    }

    /// sync = false 이고, cache = true 인 경우, 캐시된 데이터만 사용하는가?
    if (cache) {
      /// 캐시 데이터가 있으면, 캐시 데이터만 사용한다.
      User? user = MemoryCache.instance.read<User?>(uid);
      if (user != null) {
        return builder(user);
      }
    }

    /// 캐시된 데이터가 없거나, cache 가 아닌 경우, 서버에서 데이터를 읽어온다.
    return FutureBuilder(
      /// 캐시된 데이터가 있으면, 캐시된 데이터를 먼저 사용해서 보여준다.
      initialData: MemoryCache.instance.read<User?>(uid),
      future: User.get(uid, cache: false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
          dog('UserDoc() -> FutureBuilder() -> hasError: ${snapshot.error}');
          return Text(snapshot.error.toString());
        }
        return builder(snapshot.data);
      },
    );
  }

  const UserDoc.sync({
    required this.uid,
    required this.builder,
    super.key,
  })  : cache = false,
        sync = true;
}
