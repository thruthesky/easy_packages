import 'package:easy_locale/easy_locale.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as ypf;

/// easy_post provide a youtube screen
/// `post`
/// `autoPlay` if true the current playing youtube video will automatically play
class YoutubeListScreen extends StatefulWidget {
  static const String routeName = '/YouTube';

  const YoutubeListScreen(
      {super.key, required this.post, this.autoPlay = false});

  final Post post;
  final bool autoPlay;

  @override
  State<YoutubeListScreen> createState() => _YoutubeListScreenState();
}

class _YoutubeListScreenState extends State<YoutubeListScreen> {
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

  void listener() {
    if (playerReady && mounted && !youtubeController.value.isFullScreen) {
      setState(() {
        playerState = youtubeController.value.playerState;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ypf.YoutubePlayerBuilder(
      player: ypf.YoutubePlayer(
        controller: youtubeController,
        topActions: const [],
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
      ),
      builder: (context, player) => Scaffold(
        appBar: AppBar(
          title: Text('YouTube'.t),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                await PostService.instance.showPostEditScreen(
                  context: context,
                  category: 'youtube',
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // separate the youtube player so it can be reused
              ypf.YoutubePlayer(
                  controller: youtubeController,
                  topActions: const [],
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
                  ]),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${widget.post.youtube['title']}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.post.title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.post.content,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(
                  onPressed: () {
                    youtubeController.pause();
                    PostService.instance.showPostDetailScreen(
                      context: context,
                      post: widget.post,
                    );
                  },
                  child: Text('See Comments'.t)),
              const Divider(),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('You May Also Like'.t),
              ),
              const SizedBox(
                height: 16,
              ),
              PostListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                category: 'youtube',
                separatorBuilder: (context, index) => const SizedBox.shrink(),
                itemBuilder: (post, index) {
                  if (post.id == widget.post.id) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: GestureDetector(
                        onTap: () {
                          Navigator.replace(
                            context,
                            oldRoute: ModalRoute.of(context)!,
                            newRoute: MaterialPageRoute(
                              builder: (context) => YoutubeListScreen(
                                post: post,
                                autoPlay: widget.autoPlay,
                              ),
                            ),
                          );
                        },
                        child: YoutubeTile(post: post)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
