import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:flutter/material.dart';

/// PostDoc is a widget that displays a post document.
///
/// [post] is the post document to display.
///
/// [sync] if it is passed as true, it will rebuild the widget when the post is
/// updated. If it is false, it will use FutureBuilder to get the post only one
/// time. If it is true, it will use StreamBuilder to get the post and rebuild
/// the widget when the post is updated.
class PostDoc<T> extends StatelessWidget {
  const PostDoc({
    super.key,
    required this.category,
    required this.field,
    required this.builder,
    this.initialData,
    this.sync = false,
  });

  final String category;
  final String field;
  final T? initialData;
  final Widget Function(T) builder;
  final bool sync;

  @override
  Widget build(BuildContext context) {
    if (sync) {
      return Value(
          ref: postFieldRef(category, field),
          builder: (v, _) {
            return builder(v);
          });
    }

    return Value.once(
        ref: postFieldRef(category, field),
        initialData: initialData,
        builder: (v, _) {
          return builder(v);
        });
  }
}
