import 'dart:convert';

import 'package:easy_youtube/src/snippet.dart';
import 'package:easy_youtube/src/video_list.dart';
import 'package:youtube_parser/youtube_parser.dart';
import 'package:http/http.dart' as http;

class Youtube {
  String? url;
  String? id;

  Youtube({
    this.url,
    this.id,
  }) : assert(url != null || id != null);

  String getVideoId() {
    if (id == null && url != null) id = getIdFromUrl(url!);
    return id!;
  }

  Future<Snippet> getSnippet({required String apiKey}) async {
    // part= snippets,statistics,contentDuration

    // snippets containts basic inforamtion.
    // statistics contains counts such as like count , view count, comment count favorite count...
    // contentDetails containts the duration video currently in ISO 8601 format. and other like definition(hd, sd) etc..
    final url =
        'https://www.googleapis.com/youtube/v3/videos?part=id%2C+snippet,statistics,contentDetails&id=$id&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    final json = jsonDecode(response.body);

    if (json['error'] != null) {
      throw Exception(json['error']['message']);
    }
    final snippet = Snippet.fromJson(json);
    return snippet;
  }

  /// Getting channelinfo
  ///
  /// to get channel info like channel avatar chanel deails like custome url
  /// like video count , subscribers , playlistId etc .
  static Future<ChannelInfo> getChannelInfo(
      {required String apiKey, required String channelId}) async {
    final url =
        'https://www.googleapis.com/youtube/v3/channels?part=id%2C+snippet,statistics,contentDetails&id=$channelId&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    final json = jsonDecode(response.body);

    if (json['error'] != null) {
      throw Exception(json['error']['message']);
    }

    return ChannelInfo.fromJson(json);
  }

  /// Getting youtube playlist
  ///
  /// to get the list of item on the playlist from the youtube channel

  static Future<VideoList> getPlaylist(
      {required String apiKey, required String playlistId}) async {
    final url =
        'https://www.googleapis.com/youtube/v3/playlistItems?part=id%2C+snippet&maxResult=8&playlistId=$playlistId&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    final json = jsonDecode(response.body);

    if (json['error'] != null) {
      throw Exception(json['error']['message']);
    }

    return VideoList.fromJson(json);
  }
}
