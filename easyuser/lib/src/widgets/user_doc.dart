// import 'package:firebase_core/firebase_core.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';
import 'package:memory_cache/memory_cache.dart';

/// UserDoc
///
/// 다른 사용자의 정보를 한번만 읽어서 전달한다.
///
/// [uid] 는 사용자 uid 이다. 메모리에 캐시된 데이터를 사용하기 때문에 굳이 User model object
/// 를 통째로 받지 않는다.
///
/// 세가지 다른 모드가 있다.
///
/// [cacheOnly] 가 true 이면, 메모리에 캐시된 데이터만 사용한다. 메모리 캐시된 데이터가 있으면
/// 그 데이터만 사용하고, 메모리에 캐시된 데이터가 없을 때만 서버에서 데이터를 읽어온다.
/// 기본 값은 true 이다.
///
/// [cacheOnly] 가 false 이면, 메모리에 캐시된 데이터를 먼저 보여주고, 서버에서 데이터를 가져와
/// 보여준다.
///
/// [sync] 를 사용하면, 메모리에 캐시된 데이터를 먼저 보여주고, 실시간으로 업데이트된 데이터를
/// 보여준다.
///
///
///
class UserDoc extends StatelessWidget {
  const UserDoc({
    required this.uid,
    this.cacheOnly = true,
    required this.builder,
    this.sync = false,
    super.key,
  });
  final String uid;
  final bool cacheOnly;
  final Widget Function(User?) builder;
  final bool sync;

  @override
  Widget build(BuildContext context) {
    /// 캐시된 데이터만 사용하는가?
    if (cacheOnly) {
      /// 캐시 데이터가 있으면, 캐시 데이터만 사용한다.
      User? user = MemoryCache.instance.read<User?>(uid);
      if (user != null) {
        return builder(user);
      }
    }

    if (sync) {
      return StreamBuilder(
        initialData: MemoryCache.instance.read<User?>(uid),
        stream: UserService.instance.col
            .doc(uid)
            .snapshots()
            .map((snapshot) => User.fromSnapshot(snapshot)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.hasData == false) {
            return const SizedBox.shrink();
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          return builder(snapshot.data);
        },
      );
    }

    /// 캐시된 데이터가 없거나, cacheOnly 가 아닌 경우, 서버에서 데이터를 읽어온다.
    return FutureBuilder(
      /// 캐시된 데이터가 있으면, 캐시된 데이터를 먼저 사용해서 보여준다.
      initialData: MemoryCache.instance.read<User?>(uid),
      future: User.get(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) {
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
  })  : cacheOnly = false,
        sync = true;
}
