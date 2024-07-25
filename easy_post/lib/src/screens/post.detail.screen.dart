import 'package:easy_comment/easy_comment.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/widgets/post.doc.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostDetailScreen extends StatefulWidget {
  static const String routeName = '/PostDetail';
  const PostDetailScreen({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  YoutubePlayerController controller = YoutubePlayerController(
    initialVideoId: '-WMK0SLW790',
    flags: const YoutubePlayerFlags(
      autoPlay: true,
      // mute: true,
    ),
  );

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      print(controller.value.playerState);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PostDoc(
        post: widget.post,
        builder: (post) {
          /// If the post has no youtube video, return the normal scallfold.
          if (post.hasYoutube == false) {
            // return buildScaffold(context);
          }

          /// If the post has youtube video, return the youtube fullscreen
          /// builder.
          return YoutubeFullscreenBuilder(
              post: post,
              builder: (context, youtubeSmallVideoWidget) {
                return buildScaffold(context, youtubeSmallVideoWidget);
              });
        });
  }

  buildScaffold(BuildContext context, [Widget? youtubeSmallVideoWidget]) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostDetail'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: PostDetail(
                post: widget.post,
                youtubeSmallVideoWidget: youtubeSmallVideoWidget,
              ),
            ),
          ),
          CommentListTreeView(
            documentReference: widget.post.ref,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: CommentFakeInputBox(onTap: () {
          CommentService.instance.showCommentEditDialog(
            context: context,
            documentReference: widget.post.ref,
          );
        }),
      ),
    );
  }
}
