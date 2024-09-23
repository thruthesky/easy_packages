import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_youtube/easy_youtube.dart';
import 'package:firebase_database/firebase_database.dart';

/// The document reference of current post
DatabaseReference categoryRef(String category) => Post.col.child(category);
DatabaseReference postRef(String category, String id) => categoryRef(category).child(id);

DatabaseReference postFieldRef(
  String category,
  String id,
  String field,
) =>
    postRef(category, id).child(field);

Future<Map<String, dynamic>?> getYoutubeSnippet(String? youtubeUrl) async {
  if (youtubeUrl == null || youtubeUrl.isEmpty) return null;
  final youtube = Youtube(url: youtubeUrl);
  final youtubeId = youtube.getVideoId();

  final apiKey = PostService.instance.youtubeDataApi;
  if (apiKey == null) {
    throw 'youtube/cannot-connect-to-server API key is not set';
  }

  final snippet = await youtube.getSnippet(apiKey: apiKey);
  final shorts = youtubeUrl.contains('shorts');

  Map<String, Map<String, dynamic>> thumbnails = {};
  for (var key in snippet.thumbnails.keys) {
    thumbnails[key] = {
      'url': snippet.thumbnails[key]?.url,
      'width': snippet.thumbnails[key]?.width,
      'height': snippet.thumbnails[key]?.height,
    };
  }

// add data check if null
  return {
    'id': youtubeId,
    'title': snippet.title,
    'channelTitle': snippet.channelTitle,
    'thumbnails': thumbnails,
    'description': snippet.description,
    'channelId': snippet.channelId,
    'isShorts': shorts,
    'statistics': {
      'viewCount': snippet.statistics.viewCount,
      'likeCount': snippet.statistics.likeCount,
      'favoriteCount': snippet.statistics.favoriteCount,
      'commentCount': snippet.statistics.commentCount
    },
    'contentDetails': {
      'duration': snippet.contentDetails.duration,
      'dimension': snippet.contentDetails.duration,
      'definition': snippet.contentDetails.duration,
      'caption': snippet.contentDetails.duration,
      'licensedContent': snippet.contentDetails.duration,
      'projection': snippet.contentDetails.duration,
    },
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
String abbreviateNumber(int views) {
  if (views >= 1000000) {
    return '${(views / 1000000).toStringAsFixed(1)}M';
  } else if (views >= 1000) {
    return '${(views / 1000).toStringAsFixed(1)}K';
  } else {
    return views.toString();
  }
}

/// format number like '123444' to 123.4k it can work on string and number if the value
/// is not a string or number return an error
String abbrivateStringOrNumber(dynamic value) {
  // Convert the input to a number if it's a string
  final number = value is String ? double.tryParse(value) : value;

  // Return the original value if it cannot be parsed to a number
  if (number == null || number.isNaN) {
    throw 'abbrivateStringOrNumber/invalid-number $value is not a String Number  or Number';
  }

  // Format the number based on its size
  if (number >= 1000000) {
    return '${(number / 1000000).toStringAsFixed(1)}M';
  } else if (number >= 1000) {
    return '${(number / 1000).toStringAsFixed(1)}K';
  } else {
    return '${number.toStringAsFixed(0)}';
  }
}

/// format duration
/// this function converts the data of youtube duration that retrive from youtube data
/// api
/// the name formatISO8601ToDuration for clear converting the isoformat to 0:00:00 this format
/// since the data that get from the api is ISO 8601 format.
formatISO8601ToDuration(String duration) {
  final regex = RegExp(r'^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$');
  final match = regex.firstMatch(duration);

  if (match == null) {
    throw ArgumentError('Invalid ISO 8601 duration format');
  }

  final hours = match.group(1) ?? '0';
  final minutes = match.group(2) ?? '0';
  final seconds = match.group(3) ?? '0';

  // Convert to integers and format with leading zeros if necessary
  final formattedHours = int.parse(hours).toString();
  final formattedMinutes = int.parse(minutes).toString().padLeft(2, '0');
  final formattedSeconds = int.parse(seconds).toString().padLeft(2, '0');

  if (int.parse(hours) > 0) {
    return '$formattedHours:$formattedMinutes:$formattedSeconds';
  } else {
    return '$formattedMinutes:$formattedSeconds';
  }
}

/// checking if the youtube thumnail is not empty
String getThumbnailUrl(Post post, {String field = 'standard'}) {
  if (post.youtube['thumbnails'] != null &&
      post.youtube['thumbnails'][field] != null &&
      post.youtube['thumbnails'][field]['url'] != null) {
    return post.youtube['thumbnails'][field]['url'];
  }
  // add error youtube screen
  return '';
}
