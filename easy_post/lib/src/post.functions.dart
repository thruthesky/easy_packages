import 'package:youtube/youtube.dart';
import 'package:youtube_parser/youtube_parser.dart';

///
Future<Map<String, dynamic>?> getYoutubeConfig(String? youtubeUrl) async {
  if (youtubeUrl == null || youtubeUrl.isEmpty) return null;

  // get youtubeId
  final youtubeId = getIdFromUrl(youtubeUrl);

  if (youtubeId == null) {
    return null;
  }

  /// check if the youtube url is a valid
  try {
    await Youtube.config(videoId: youtubeId);
  } catch (e) {
    throw 'youtube/get-config Check if the youtubeUrl is valid';
  }

  final youtubeVideoDetails = Youtube.videoDetails;
  final youtubeChannelDetails = Youtube.channelDetails;
  final youtubeThumbnailDetails = Youtube.thumbnails;

  return {
    'id': youtubeId,
    'title': youtubeVideoDetails.title,
    'name': youtubeChannelDetails.name,
    'fullHd': youtubeThumbnailDetails.fullhd,
    'hd': youtubeThumbnailDetails.hd,
    'sd': youtubeThumbnailDetails.sd,
    'hq': youtubeThumbnailDetails.hq,
    'lq': youtubeThumbnailDetails.lq,
    'duration': youtubeVideoDetails.duration,
    'viewCount': youtubeVideoDetails.viewCount
  };
}

/// format duration in secods to a this foramt "1:02:00" if hour long
/// if 3 mins long "03:01"
String formatDuration(int duration) {
  final durationInSeconds = Duration(seconds: duration);

  /// helper function to check if the the parameter is 2 digit if the parameter
  /// is 1 digit it will concat '0'
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitMinutes = twoDigits(durationInSeconds.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(durationInSeconds.inSeconds.remainder(60));

  if (durationInSeconds.inHours > 0) {
    return "${durationInSeconds.inHours}:$twoDigitMinutes:$twoDigitSeconds";
  } else {
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}

/// format views from 120304050 millions views 1M views
String formatViews(int views) {
  if (views >= 1000000) {
    return '${(views / 1000000).toStringAsFixed(1)}M';
  } else if (views >= 1000) {
    return '${(views / 1000).toStringAsFixed(1)}K';
  } else {
    return views.toString();
  }
}
