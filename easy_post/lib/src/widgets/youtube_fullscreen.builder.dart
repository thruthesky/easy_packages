import 'package:easy_helpers/easy_helpers.dart';
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
    this.thumbnail,
    this.autoPlay = false,
  });

  final Post post;
  final Widget Function(BuildContext, Widget) builder;
  final Widget? thumbnail;
  final bool autoPlay;

  @override
  State<YoutubeFullscreenBuilder> createState() =>
      _YoutubeFullscreenBuilderState();
}

class _YoutubeFullscreenBuilderState extends State<YoutubeFullscreenBuilder> {
  YoutubePlayerController? youtubeController;
  ValueNotifier<bool> isPlayingNotifier = ValueNotifier(false);
  // bool isPlaying = false;
  bool isReady = false;
  late PlayerState playerState;

  @override
  void initState() {
    if (widget.post.youtube['id'] == null) return;
    youtubeController = YoutubePlayerController(
      initialVideoId: widget.post.youtube['id']!,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        mute: false,
      ),
    )..addListener(listener);
    playerState = PlayerState.unknown;
    super.initState();
  }

  @override
  void deactivate() {
    // Pauses video while navigating to other screen.
    youtubeController?.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    youtubeController?.pause();
    youtubeController?.dispose();
    isPlayingNotifier.dispose();
    super.dispose();
  }

  listener() {
    if (mounted && youtubeController!.value.isReady) {
      isPlayingNotifier.value = youtubeController!.value.isPlaying;
      playerState = youtubeController!.value.playerState;
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
      youtubeController?.load(widget.post.youtube['id']);
      youtubeController?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        bottomActions: [
          ValueListenableBuilder<bool>(
              valueListenable: isPlayingNotifier,
              builder: (context, isPlaying, _) {
                return IconButton(
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
                );
              }),
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
        thumbnail: widget.thumbnail,
      ),
      builder: (context, smallWidget) {
        return widget.builder(context, smallWidget);
      },
    );
  }
}
