import 'dart:convert';

import 'package:easy_youtube/src/snippet.dart';
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
    final url =
        'https://www.googleapis.com/youtube/v3/videos?part=id%2C+snippet&id=$id&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    final json = jsonDecode(response.body);

    if (json['error'] != null) {
      throw Exception(json['error']['message']);
    }
    final snippet = Snippet.fromJson(json);
    return snippet;
  }
}
