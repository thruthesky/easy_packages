import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// PostPageView
///
///
class PostPageView extends StatelessWidget {
  const PostPageView({
    super.key,
    this.category,
    this.pageSize = 20,
    this.loadingBuilder,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    required this.itemBuilder,
    this.emptyBuilder,
    this.errorBuilder,
    ChildIndexGetter? findChildIndexCallback,
    int? itemCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.hitTestBehavior = HitTestBehavior.opaque,
    this.scrollBehavior,
    this.padEnds = true,
  });
  final String? category;

  final int pageSize;
  final Widget Function()? loadingBuilder;
  final Widget Function(String)? errorBuilder;
  final Widget Function()? emptyBuilder;

  final bool reverse;
  final PageController? controller;
  final ScrollPhysics? physics;
  final DragStartBehavior dragStartBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final Widget Function(Post, int)? itemBuilder;
  final Axis scrollDirection;
  final bool pageSnapping;
  final ValueChanged<int>? onPageChanged;
  final bool allowImplicitScrolling;
  final HitTestBehavior hitTestBehavior;
  final ScrollBehavior? scrollBehavior;
  final bool padEnds;
  @override
  Widget build(BuildContext context) {
    final query = PostService.instance.postsRef
        .orderByChild('category')
        .startAt('$category-')
        .endAt('$category-9999999999999999999999');

    return FirebaseDatabaseQueryBuilder(
      query: query,
      pageSize: pageSize,
      builder: (context, snapshot, _) {
        if (snapshot.isFetching) {
          return loadingBuilder?.call() ?? const Center(child: CircularProgressIndicator.adaptive());
        }

        if (snapshot.hasError) {
          dog('Error: ${snapshot.error}');
          return errorBuilder?.call(snapshot.error.toString()) ??
              Text('Something went wrong! ${snapshot.error}');
        }

        if (snapshot.hasData && snapshot.docs.isEmpty && !snapshot.hasMore) {
          return emptyBuilder?.call() ?? Center(child: Text('post list is empty'.t));
        }

        return PageView.builder(
          itemCount: snapshot.docs.length,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          physics: physics,
          dragStartBehavior: dragStartBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          onPageChanged: onPageChanged,
          pageSnapping: pageSnapping,
          allowImplicitScrolling: allowImplicitScrolling,
          hitTestBehavior: hitTestBehavior,
          scrollBehavior: scrollBehavior,
          padEnds: padEnds,
          itemBuilder: (context, index) {
            // if we reached the end of the currently obtained items, we try to
            // obtain more items
            if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
              // Tell FirebaseDatabaseQueryBuilder to try to obtain more items.
              // It is safe to call this  function from within the build method.
              snapshot.fetchMore();
            }

            final post = Post.fromSnapshot(snapshot.docs[index]);

            return itemBuilder?.call(post, index) ?? PostListTile(post: post);
          },
        );
      },
    );
  }
}
