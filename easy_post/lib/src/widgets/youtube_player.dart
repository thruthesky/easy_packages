import 'package:flutter/material.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as ypf;

// youtube player to display yout youtube video
/// `autoPlay` if true the player will automatically play or start when initialized
///
/// `thumbnail` use this to display thumbnail if the youtube is idle or not playing
///
/// `aspectRatio` use to change the aspectRatio of the Youtube player
///
/// `width` use to change the width of the youtube player
///
/// note: this widget is only for displaying youtube video. this widget does not
/// provide aditional customization and other control actions
class YoutubePlayer extends StatefulWidget {
  const YoutubePlayer({
    super.key,
    required this.post,
    this.autoPlay = false,
    this.thumbnail,
    this.width,
    this.aspectRatio = 16 / 9,
  });

  final Post post;
  final bool autoPlay;
  final Widget? thumbnail;
  final double? width;
  final double aspectRatio;
  @override
  State<YoutubePlayer> createState() => _YoutubePlayerState();
}

class _YoutubePlayerState extends State<YoutubePlayer> {
  late ypf.YoutubePlayerController youtubeController;
  late ypf.PlayerState playerState;
  bool playerReady = false;

  @override
  void initState() {
    super.initState();
    youtubeController = ypf.YoutubePlayerController(
      initialVideoId: widget.post.youtube['id'],
      flags: ypf.YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        mute: false,
        controlsVisibleAtStart: false,
      ),
    )..addListener(listener);
  }

  @override
  void dispose() {
    youtubeController.pause();
    youtubeController.dispose();
    super.dispose();
  }

  void listener() {
    if (playerReady && mounted && !youtubeController.value.isFullScreen) {
      setState(() {
        playerState = youtubeController.value.playerState;
      });
    }
  }

  /// load the new post youtube id if the post youtube url change
  /// or the user update the post youtube url
  @override
  void didUpdateWidget(covariant YoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.youtube['id'] != widget.post.youtube['']) {
      youtubeController.load(widget.post.youtube['id']);
      widget.autoPlay ? youtubeController.play() : youtubeController.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ypf.YoutubePlayerBuilder(
      player: ypf.YoutubePlayer(
        aspectRatio: widget.aspectRatio,
        width: widget.width,
        bottomActions: [
          IconButton(
              onPressed: () {
                youtubeController.value.isPlaying
                    ? youtubeController.pause()
                    : youtubeController.play();
              },
              icon: Icon(
                youtubeController.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
                color: Colors.white,
              )),
          ypf.CurrentPosition(),
          ypf.ProgressBar(
            colors: const ypf.ProgressBarColors(
                playedColor: Colors.white,
                handleColor: Colors.white,
                backgroundColor: Colors.grey),
            isExpanded: true,
          ),
          const SizedBox(
            width: 8,
          ),
          ypf.RemainingDuration(),
          ypf.FullScreenButton(),
        ],
        topActions: const [],
        controller: youtubeController,
        // when thumbnail is not provideo it will try to get from the provided post
        // when it is also not exist in the post it will show a  default arrow
        thumbnail: widget.thumbnail ??
            CachedNetworkImage(
              imageUrl: widget.post.youtube['hd'],
              errorWidget: (context, error, _) => const Center(
                child: Icon(Icons.play_arrow),
              ),
            ),
        onReady: () {
          // log('Player is ready.');
          playerReady = true;
        },
      ),
      builder: (context, widget) {
        return widget;
      },
    );
  }
}
