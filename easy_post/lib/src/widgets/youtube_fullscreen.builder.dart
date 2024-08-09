import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/widgets/youtube_player_builder.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart'
    hide YoutubePlayerBuilder;

/// To support fullscreen on youtube video you need to wrap your whole scaffold
/// with the `YoutubeFullscreenBuilder` this widget will create a youtube player
/// base on the post that allows fullscreen
///

///
class YoutubeFullscreenBuilder extends StatefulWidget {
  /// `post` this contains the post information
  ///
  /// `builder` callback function that returns the widget which is
  ///  the youtube player
  const YoutubeFullscreenBuilder({
    super.key,
    required this.post,
    required this.builder,
  });

  final Post post;
  final Widget Function(BuildContext, Widget) builder;

  @override
  State<YoutubeFullscreenBuilder> createState() =>
      _YoutubeFullscreenBuilderState();
}

class _YoutubeFullscreenBuilderState extends State<YoutubeFullscreenBuilder> {
  YoutubePlayerController? youtubeController;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.post.youtube['id'] == null) return;
    youtubeController = YoutubePlayerController(
      initialVideoId: widget.post.youtube['id']!,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        controlsVisibleAtStart: false,
      ),
    )..addListener(listener);
  }

  @override
  void dispose() {
    youtubeController?.pause();
    youtubeController?.dispose();
    super.dispose();
  }

  listener() {
    if (mounted && youtubeController!.value.isReady) {
      isPlaying = youtubeController!.value.isPlaying;
      setState(() {});
    }
  }

  /// Load the new post youtube id if the post youtube url changes
  /// or the user updates the post youtube url
  @override
  void didUpdateWidget(covariant YoutubeFullscreenBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.post.hasYoutube == false) {
      return;
    }
    if (oldWidget.post.youtube['id'] != widget.post.youtube['id']) {
      youtubeController?.load(widget.post.youtube['id']!);
      youtubeController?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        bottomActions: [
          IconButton(
            onPressed: () {
              if (youtubeController != null) {
                youtubeController!.value.isPlaying
                    ? youtubeController?.pause()
                    : youtubeController?.play();
              }
            },
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          const CurrentPosition(),
          const ProgressBar(
            colors: ProgressBarColors(
                playedColor: Colors.white,
                handleColor: Colors.white,
                backgroundColor: Colors.grey),
            isExpanded: true,
          ),
          const SizedBox(
            width: 8,
          ),
          const RemainingDuration(),
          const FullScreenButton(),
        ],
        topActions: const [],
        controller: youtubeController!,
        // When thumbnail is not provided, it will try to get from the provided post
        // When it is also not exist in the post it will show a default arrow
        thumbnail: CachedNetworkImage(
          imageUrl: widget.post.youtube['hd'] ?? '',
          errorWidget: (context, error, _) => const Center(
            child: Icon(Icons.play_arrow),
          ),
        ),
      ),
      builder: (context, smallWidget) {
        return widget.builder(context, smallWidget);
      },
    );
  }
}
