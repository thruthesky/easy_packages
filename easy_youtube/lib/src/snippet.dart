class Snippet {
  final DateTime publishedAt;
  final String? channelId;
  final String? title;
  final String? description;
  final Map<String, Thumbnail> thumbnails;
  final String? channelTitle;
  final List<String> tags;
  final String? categoryId;
  final String? liveBroadcastContent;
  final Localized localized;
  final String? defaultAudioLanguage;
  final Statistics statistics;
  final ContentDetails contentDetails;

  Snippet({
    required this.publishedAt,
    required this.channelId,
    required this.title,
    required this.description,
    required this.thumbnails,
    required this.channelTitle,
    required this.tags,
    required this.categoryId,
    required this.liveBroadcastContent,
    required this.localized,
    required this.defaultAudioLanguage,
    required this.statistics,
    required this.contentDetails,
  });

  factory Snippet.fromJson(Map<String, dynamic> json) {
    if (json['items'] == null || json['items'].length == 0) {
      throw Exception('No youtube items found');
    }
    final snippet = json['items'][0]['snippet'];
    final statistics = json['items'][0]['statistics'];
    final contentDetails = json['items'][0]['contentDetails'];
    return Snippet(
      publishedAt: DateTime.parse(snippet['publishedAt']),
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
      tags: List<String>.from(snippet['tags']),
      categoryId: snippet['categoryId'],
      liveBroadcastContent: snippet['liveBroadcastContent'],
      localized: Localized.fromJson(snippet['localized']),
      defaultAudioLanguage: snippet['defaultAudioLanguage'],
      statistics: Statistics.fromJson(statistics),
      contentDetails: ContentDetails.fromJson(contentDetails),
    );
  }

  @override
  String toString() {
    return 'publishedAt: $publishedAt, channelId: $channelId, title: $title, description: $description, thumbnails: $thumbnails, channelTitle: $channelTitle, tags: $tags, categoryId: $categoryId, liveBroadcastContent: $liveBroadcastContent, localized: $localized, defaultAudioLanguage: $defaultAudioLanguage, statistics: $statistics, contentDetails: $contentDetails';
  }
}

class Thumbnail {
  final String url;
  final int width;
  final int height;

  Thumbnail({
    required this.url,
    required this.width,
    required this.height,
  });

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }

  @override
  String toString() {
    return 'url: $url, width: $width, height: $height';
  }
}

class Localized {
  final String title;
  final String description;

  Localized({
    required this.title,
    required this.description,
  });

  factory Localized.fromJson(Map<String, dynamic> json) {
    return Localized(
      title: json['title'],
      description: json['description'],
    );
  }

  @override
  String toString() {
    return 'title: $title, description: $description';
  }
}

/// Statistics  model contains like count , view count favorit count,
class Statistics {
  final String viewCount;
  final String likeCount;
  final String favoriteCount;
  final String commentCount;

  Statistics({
    required this.viewCount,
    required this.likeCount,
    required this.favoriteCount,
    required this.commentCount,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
        viewCount: json['viewCount'],
        likeCount: json['likeCount'],
        favoriteCount: json['favoriteCount'],
        commentCount: json['commentCount']);
  }

  @override
  String toString() {
    return 'viewCount: $viewCount, likeCount: $likeCount, favoriteCount: $favoriteCount, commentCount: $commentCount';
  }
}

/// ContentDetails model
class ContentDetails {
  final String duration;
  final String dimension;
  final String definition;
  final String caption;
  final bool licensedContent;
  final String projection;

  ContentDetails({
    required this.duration,
    required this.dimension,
    required this.definition,
    required this.caption,
    required this.licensedContent,
    required this.projection,
  });

  factory ContentDetails.fromJson(Map<String, dynamic> json) {
    return ContentDetails(
      duration: json['duration'],
      dimension: json['dimension'],
      definition: json['definition'],
      caption: json['caption'],
      licensedContent: json['licensedContent'],
      projection: json['projection'],
    );
  }

  @override
  String toString() {
    return 'duration: $duration, dimension: $dimension, definition: $definition, caption: $caption, licensedContent: $licensedContent, projection: $projection';
  }
}
