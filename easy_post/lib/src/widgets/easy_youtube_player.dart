import 'package:flutter/material.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// youtube player to display yout youtube video

class EasyYoutubePlayer extends StatefulWidget {
  /// `autoPlay` if true the player will automatically play or start when initialized
  ///
  /// `thumbnailBuilder` use this to display thumbnail if the youtube is idle or not playing
  ///
  /// `aspectRatio` use to change the aspectRatio of the Youtube player
  ///
  /// `width` use to change the width of the youtube player
  ///
  /// `actionPadding` use to change the padding of the action buttons
  ///
  /// note: this widget is only for displaying youtube video. this widget does not
  /// provide aditional customization and other control actions
  ///
  ///
  const EasyYoutubePlayer({
    super.key,
    required this.post,
    this.hideControls = false,
    this.autoPlay = false,
    this.loop = false,
    this.thumbnailBuilder,
    this.width,
    this.aspectRatio = 16 / 9,
    this.actionPadding = const EdgeInsets.all(8),
    this.onReady,
    this.onEnded,
  });

  final Post post;
  final bool hideControls;
  final bool autoPlay;
  final bool loop;
  final Widget Function(PlayerState)? thumbnailBuilder;
  final double? width;
  final double aspectRatio;
  final EdgeInsetsGeometry actionPadding;
  final Function()? onReady;
  final Function(YoutubeMetaData)? onEnded;

  @override
  State<EasyYoutubePlayer> createState() => _EasyYoutubePlayerState();
}

class _EasyYoutubePlayerState extends State<EasyYoutubePlayer> {
  late YoutubePlayerController youtubeController;

  ValueNotifier<PlayerState> isPlayerStateNotifier = ValueNotifier(PlayerState.unStarted);

  @override
  void initState() {
    super.initState();
    if (widget.post.youtube['id'] == null) return;
    youtubeController = YoutubePlayerController(
      initialVideoId: widget.post.youtube['id'],
      flags: YoutubePlayerFlags(
        hideControls: widget.hideControls,
        autoPlay: widget.autoPlay,
        loop: widget.loop,
        mute: false,
        controlsVisibleAtStart: false,
        enableCaption: false,
      ),
    )..addListener(listener);
  }

  listener() {
    if (mounted && youtubeController.value.isReady) {
      isPlayerStateNotifier.value = youtubeController.value.playerState;
    }
  }

  @override
  void dispose() {
    youtubeController.pause();
    youtubeController.dispose();
    super.dispose();
  }

  /// load the new post youtube id if the post youtube url change
  /// or the user update the post youtube url
  @override
  void didUpdateWidget(covariant EasyYoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.youtube['id'] != widget.post.youtube['id']) {
      youtubeController.load(widget.post.youtube['id']);
      widget.autoPlay ? youtubeController.play() : youtubeController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// use notifier instead of setState because theres a lot of side effect its setState
    ///
    return ValueListenableBuilder(
        valueListenable: isPlayerStateNotifier,
        builder: (context, state, child) {
          return YoutubePlayer(
            actionsPadding: widget.actionPadding,
            aspectRatio: widget.aspectRatio,
            width: widget.width,
            onReady: widget.onReady,
            onEnded: (YoutubeMetaData metaData) {
              /// If not loop true and the youtube ended it shows random recommendation.
              /// To prevent showing unwanted youtube list after the video is ended.
              /// SeekTo start the current video and pause.
              if (widget.loop == false) {
                youtubeController.seekTo(const Duration(seconds: 0));
                youtubeController.pause();
              }
              widget.onEnded?.call(metaData);
            },
            bottomActions: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  state == PlayerState.playing ? youtubeController.pause() : youtubeController.play();
                },
                icon: Icon(
                  state == PlayerState.playing ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
              const CurrentPosition(),
              const ProgressBar(
                colors: ProgressBarColors(
                  playedColor: Colors.white,
                  handleColor: Colors.white,
                  backgroundColor: Colors.grey,
                ),
                isExpanded: true,
              ),
              const SizedBox(
                width: 8,
              ),
              const RemainingDuration(),
            ],
            topActions: const [],
            controller: youtubeController,
            // when thumbnail is not provided it will try to get from the provided post
            thumbnail: widget.thumbnailBuilder?.call(state),
          );
        });
  }
}
