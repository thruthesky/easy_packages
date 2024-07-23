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
