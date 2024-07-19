import 'package:flutter/material.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as ypf;

class YoutubePlayer extends StatefulWidget {
  const YoutubePlayer({
    super.key,
    required this.post,
  });

  final Post post;

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
      flags: const ypf.YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        controlsVisibleAtStart: true,
      ),
    )..addListener(listener);
  }

  @override
  void dispose() {
    super.dispose();
    youtubeController.pause();
    youtubeController.dispose();
  }

  void listener() {
    if (playerReady && mounted && !youtubeController.value.isFullScreen) {
      setState(() {
        playerState = youtubeController.value.playerState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ypf.YoutubePlayer(
      bottomActions: const [],
      topActions: const [],
      controller: youtubeController,
      thumbnail: CachedNetworkImage(imageUrl: widget.post.youtube['hd']),
      onReady: () {
        // log('Player is ready.');
        playerReady = true;
      },
    );
  }
}
