import 'package:easy_youtube/easy_youtube.dart';

class VideoList {
  final String nextPageToken;

  final List<VideoItem> videos;

  const VideoList({
    required this.nextPageToken,
    required this.videos,
  });

  factory VideoList.fromJson(Map<String, dynamic> json) {
    return VideoList(
      nextPageToken: json['nextPageToken'],
      videos: List<VideoItem>.from(
          json['items'].map((item) => VideoItem.fromJson(item))),
    );
  }

  @override
  String toString() {
    return 'nextPageToken: $nextPageToken, videos: $videos';
  }
}

class VideoItem {
  final String id;
  final String publishedAt;
  final String channelId;
  final String title;
  final String description;
  final Map<String, Thumbnail> thumbnails;
  final String channelTitle;
  final String playlistId;
  final int position;
  final String videoId;
  final String videoOwnerChannelTitle;
  final String videoOwnerChannelId;

  const VideoItem({
    required this.id,
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.playlistId,
    required this.position,
    required this.videoId,
    required this.videoOwnerChannelTitle,
    required this.videoOwnerChannelId,
  });

  factory VideoItem.fromJson(Map<String, dynamic> json) {
    final snippet = json['snippet'];

    return VideoItem(
      id: json['id'],
      publishedAt: snippet['publishedAt'],
      channelId: snippet['channelId'],
      title: snippet['title'],
      description: snippet['description'],
      thumbnails: {
        if (snippet['thumbnails']['default'] != null)
          'default': Thumbnail.fromJson(snippet['thumbnails']['default']),
        if (snippet['thumbnails']['medium'] != null)
          'medium': Thumbnail.fromJson(snippet['thumbnails']['medium']),
        if (snippet['thumbnails']['high'] != null)
          'high': Thumbnail.fromJson(snippet['thumbnails']['high']),
        if (snippet['thumbnails']['standard'] != null)
          'standard': Thumbnail.fromJson(snippet['thumbnails']['standard']),
        if (snippet['thumbnails']['maxres'] != null)
          'maxres': Thumbnail.fromJson(snippet['thumbnails']['maxres']),
      },
      channelTitle: snippet['channelTitle'],
      playlistId: snippet['playlistId'],
      position: snippet['position'],
      videoId: snippet['resourceId']['videoId'],
      videoOwnerChannelTitle: snippet['videoOwnerChannelTitle'],
      videoOwnerChannelId: snippet['videoOwnerChannelId'],
    );
  }
  @override
  String toString() {
    return 'id: $id, publishedAt: $publishedAt, channelId: $channelId, title: $title, description: $description, thumbnails: $thumbnails, channelTitle: $channelTitle, playlistId: $playlistId, position: $position';
  }
}
