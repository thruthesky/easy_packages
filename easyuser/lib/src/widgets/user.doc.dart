// import 'package:firebase_core/firebase_core.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';
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
///
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
///
/// [sync] option helps to reduce the blinking(flickering) on the UI.
class UserDoc<T> extends StatelessWidget {
  const UserDoc({
    required this.uid,
    required this.field,
    this.cache = true,
    required this.builder,
    this.onLoading,
    this.sync = true,
    super.key,
  });
  final String uid;
  final String field;
  final bool cache;
  final Widget Function(T) builder;
  final bool sync;
  final Widget? onLoading;

  @override
  Widget build(BuildContext context) {
    String key = '$uid+$field';
    final value = MemoryCache.instance.read<T>(key);

    if (sync) {
      return Value(
        ref: userFieldRef(uid, field),
        initialData: value,
        builder: (v, _) {
          MemoryCache.instance.create(key, v);
          return builder(v);
        },
        onLoading: onLoading,
      );
    }

    /// If [sync] is false and [cache] is true, and there is a cached data,
    if (cache && value != null) {
      return builder(value);
    }

    /// When [sync] is false, and [cache] is false of there is no cached data,
    ///
    return Value.once(
      ref: userFieldRef(uid, field),
      initialData: value,
      builder: (v, _) {
        MemoryCache.instance.create(key, v);
        return builder(v);
      },
      onLoading: onLoading,
    );
  }
}
