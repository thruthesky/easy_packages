import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:flutter/material.dart';

/// PostField is a widget that displays a post document or an specific field from database.
/// If the field is not provided, it will get the whole post.
///
/// [category] is the category of the post
///
/// [id] is the id of the post
///
/// [field] is the node where the data will come from.
///
/// [sync] default value is false. If it is true, it will rebuild the widget
/// whenever the [field] is updated. And if it is false, it will get
/// the data once and will just return it.
class PostField<T> extends StatelessWidget {
  const PostField({
    super.key,
    required this.id,
    required this.category,
    required this.field,
    required this.builder,
    this.initialData,
    this.sync = false,
  });

  final String category;
  final String id;
  final String field;
  final T? initialData;
  final Widget Function(T) builder;
  final bool sync;

  @override
  Widget build(BuildContext context) {
    if (sync) {
      return Value(
          ref: postFieldRef(category, id, field),
          initialData: initialData,
          builder: (v, _) {
            return builder(v);
          });
    }

    return Value.once(
        ref: postFieldRef(category, id, field),
        initialData: initialData,
        builder: (v, _) {
          return builder(v);
        });
  }
}
