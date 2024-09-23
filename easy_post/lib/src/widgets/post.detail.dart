import 'dart:developer';

import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/widgets/post.detail.youtube_meta.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// This widget that contains the overall details of the post
/// contains youtube video, youtube meta data, post title, post content , post photos
///
/// [post] is the post model(document) object and it is updated in realtime.
class PostDetail extends StatefulWidget {
  /// `post` this contains the post inforamtion
  ///
  /// `youtube` for youtube player,this use to pass the youtube player comming from the
  /// `YoutubeFullscreenBuilder` to be reused if this widget is not provide it will
  /// use a new youtube player
  const PostDetail({super.key, required this.post, this.youtubePlayer});

  final Post post;
  final Widget? youtubePlayer;

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  Post get post => widget.post;
  @override
  Widget build(BuildContext context) {
    log('post detail screen: line 33');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UserField<String?>(
          field: User.field.displayName,
          uid: post.uid,
          builder: (displayName) {
            return Row(
              children: [
                UserField<String?>(
                    field: User.field.photoUrl,
                    uid: post.uid,
                    builder: (photoUrl) {
                      return UserAvatar(
                        photoUrl: photoUrl,
                        initials: displayName ?? '',
                      );
                    }),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName ?? ''),
                      Text(post.createdAt.yMd),
                    ],
                  ),
                )
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        UserBlocked(
          otherUid: post.uid,
          builder: (blocked) {
            if (blocked) {
              return const SizedBox(
                width: double.infinity,
                height: 200,
                child: Center(
                  child: Text('This user has been blocked.'),
                ),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.deleted) ...{
                  const SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: Center(
                      child: Text('This Post has been deleted.'),
                    ),
                  ),
                } else ...{
                  PostField<List<Object?>?>(
                    category: post.category,
                    id: post.id,
                    initialData: post.urls,
                    field: Post.field.urls,
                    sync: true,
                    builder: (urls) {
                      if (urls == null) return const SizedBox.shrink();
                      final res = urls.map((v) => v as String).toList();
                      return PostDetailPhotos(urls: res);
                    },
                  ),
                  if (post.hasYoutube && widget.youtubePlayer != null) widget.youtubePlayer!,
                  PostDetailYoutubeMeta(post: widget.post),
                  const SizedBox(
                    height: 16,
                  ),
                  PostField<String?>(
                    category: post.category,
                    id: post.id,
                    initialData: post.title,
                    field: Post.field.title,
                    sync: true,
                    builder: (title) {
                      return Visibility(
                        visible: !title.isEmpty,
                        child: Text(title!),
                      );
                    },
                  ),
                  PostField<String?>(
                    category: post.category,
                    id: post.id,
                    initialData: post.content,
                    field: Post.field.content,
                    sync: true,
                    builder: (content) {
                      return Visibility(
                        visible: !content.isEmpty,
                        child: Text(content!),
                      );
                    },
                  ),
                },
              ],
            );
          },
        ),
        PostDetailBottomAction(
          post: post,
        ),
      ],
    );
  }
}
