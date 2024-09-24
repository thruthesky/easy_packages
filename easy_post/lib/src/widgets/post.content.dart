import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:flutter/widgets.dart';

/// PostContent is a widget that displays the content of the post.
/// A conventional way to get the `content` as a widget since it is in a different node
/// to avoid downloading the `content` in unnecessary places.
class PostContent extends StatelessWidget {
  const PostContent({
    super.key,
    required this.id,
    required this.builder,
    this.sync = false,
  });

  final String id;
  final Widget Function(String) builder;
  final bool sync;

  @override
  Widget build(BuildContext context) {
    return Value(
      ref: postContentRef(id),
      builder: (v, _) {
        return builder(v);
      },
      sync: sync,
    );
  }
}
