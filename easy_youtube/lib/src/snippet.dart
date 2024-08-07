/**
 * {
    "publishedAt": "2024-08-07T08:18:59Z",
    "channelId": "UCsU-I-vHLiaMfV_ceaYz5rQ",
    "title": "'파죽지세' 해리스 돌풍, 2주 만에 트럼프 꺾었다｜지금 이 뉴스",
    "description": "해리스 부통령의 지지율이 2주 만에 트럼프 전 대통령을 꺾고 역전했다는 여론조사가 나왔습니다. '피격 사건' 이후 승기를 굳혀가는 듯했던 트럼프 전 대통령이 '밴스 설화' 등으로 주춤해지는 사이 해리스 부통령의 지지층이 집결하고 있다는 분석이 나옵니다.\n\n#미국대선여론조사 #해리스지지율 #트럼프지지율 #오차범위이내접전 #JTBC #심수미기자\n\n📢 지금, 이슈의 현장을 실시간으로!\n☞JTBC 모바일라이브 시청하기 https://www.youtube.com/@jtbc_news/streams\n\n☞JTBC유튜브 구독하기 (https://www.youtube.com/user/JTBC10news)\n☞JTBC유튜브 커뮤니티 (https://www.youtube.com/user/JTBC10news/community)\n\n#JTBC뉴스 공식 페이지\n(홈페이지) https://news.jtbc.co.kr\n(APP) https://news.jtbc.co.kr/Etc/SmartPhoneReport.aspx\n\n페이스북 https://www.facebook.com/jtbcnews\nX(트위터) https://twitter.com/JTBC_news\n인스타그램 https://www.instagram.com/jtbcnews\n\n☏ 제보하기 https://news.jtbc.co.kr/Etc/InterNetReport.aspx\n방송사 : JTBC (https://jtbc.co.kr)",
    "thumbnails": {
        "default": {
            "url": "https://i.ytimg.com/vi/ZZKZBC_Fv0k/default.jpg",
            "width": 120,
            "height": 90
        },
        "medium": {
            "url": "https://i.ytimg.com/vi/ZZKZBC_Fv0k/mqdefault.jpg",
            "width": 320,
            "height": 180
        },
        "high": {
            "url": "https://i.ytimg.com/vi/ZZKZBC_Fv0k/hqdefault.jpg",
            "width": 480,
            "height": 360
        },
        "standard": {
            "url": "https://i.ytimg.com/vi/ZZKZBC_Fv0k/sddefault.jpg",
            "width": 640,
            "height": 480
        },
        "maxres": {
            "url": "https://i.ytimg.com/vi/ZZKZBC_Fv0k/maxresdefault.jpg",
            "width": 1280,
            "height": 720
        }
    },
    "channelTitle": "JTBC News",
    "tags": [
        "genre:국제",
        "format:리포트",
        "type:디지털",
        "source:영상",
        "series:디지털only",
        "custom:지금이뉴스"
    ],
    "categoryId": "25",
    "liveBroadcastContent": "none",
    "localized": {
        "title": "'파죽지세' 해리스 돌풍, 2주 만에 트럼프 꺾었다｜지금 이 뉴스",
        "description": "해리스 부통령의 지지율이 2주 만에 트럼프 전 대통령을 꺾고 역전했다는 여론조사가 나왔습니다. '피격 사건' 이후 승기를 굳혀가는 듯했던 트럼프 전 대통령이 '밴스 설화' 등으로 주춤해지는 사이 해리스 부통령의 지지층이 집결하고 있다는 분석이 나옵니다.\n\n#미국대선여론조사 #해리스지지율 #트럼프지지율 #오차범위이내접전 #JTBC #심수미기자\n\n📢 지금, 이슈의 현장을 실시간으로!\n☞JTBC 모바일라이브 시청하기 https://www.youtube.com/@jtbc_news/streams\n\n☞JTBC유튜브 구독하기 (https://www.youtube.com/user/JTBC10news)\n☞JTBC유튜브 커뮤니티 (https://www.youtube.com/user/JTBC10news/community)\n\n#JTBC뉴스 공식 페이지\n(홈페이지) https://news.jtbc.co.kr\n(APP) https://news.jtbc.co.kr/Etc/SmartPhoneReport.aspx\n\n페이스북 https://www.facebook.com/jtbcnews\nX(트위터) https://twitter.com/JTBC_news\n인스타그램 https://www.instagram.com/jtbcnews\n\n☏ 제보하기 https://news.jtbc.co.kr/Etc/InterNetReport.aspx\n방송사 : JTBC (https://jtbc.co.kr)"
    },
    "defaultAudioLanguage": "ko"
}

 */

class Snippet {
  final DateTime publishedAt;
  final String channelId;
  final String title;
  final String description;
  final Map<String, Thumbnail> thumbnails;
  final String channelTitle;
  final List<String> tags;
  final String categoryId;
  final String liveBroadcastContent;
  final Localized localized;
  final String defaultAudioLanguage;

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
  });

  factory Snippet.fromJson(Map<String, dynamic> json) {
    return Snippet(
      publishedAt: DateTime.parse(json['publishedAt']),
      channelId: json['channelId'],
      title: json['title'],
      description: json['description'],
      thumbnails: {
        'default': Thumbnail.fromJson(json['thumbnails']['default']),
        'medium': Thumbnail.fromJson(json['thumbnails']['medium']),
        'high': Thumbnail.fromJson(json['thumbnails']['high']),
        'standard': Thumbnail.fromJson(json['thumbnails']['standard']),
        'maxres': Thumbnail.fromJson(json['thumbnails']['maxres']),
      },
      channelTitle: json['channelTitle'],
      tags: List<String>.from(json['tags']),
      categoryId: json['categoryId'],
      liveBroadcastContent: json['liveBroadcastContent'],
      localized: Localized.fromJson(json['localized']),
      defaultAudioLanguage: json['defaultAudioLanguage'],
    );
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
}
