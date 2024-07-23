import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/defines.dart';
import 'package:youtube/youtube.dart';
import 'package:youtube_parser/youtube_parser.dart';

/// Post mostly contains a `title` and `content` there might be also a image when
/// the user post image
///
/// `id` is the postid and it also the document id of the post
///
/// `title` is the title of the post
///
/// `content` is the content of the post
///
/// `urls` is the list of post image urls
///
/// `createdAt` is the time when the post is created
///
/// `updateAt` is the time when the post is update
///
/// `youtubeUrl` is the youtube url from youtube ex:https://youtube.com/watch=<someID>
///
/// `youtube` is the information of the youtube url such as thumbnail
class Post {
  // collectionReference post's collection

  final String id;
  final String category;
  final String title;
  final String content;
  final String uid;
  final DateTime createdAt;
  final DateTime updateAt;
  final List<String> urls;

  static CollectionReference col = PostService.instance.col;

  /// The document reference of current post
  DocumentReference doc(String id) => col.doc(id);

  /// The document reference of current post
  DocumentReference get ref => doc(id);

  /// get the first image url
  String? get imageUrl => urls.isNotEmpty ? urls.first : null;

  /// Youtube URL. Refer README.md for more information
  final String? youtubeUrl;

  final int commentCount;
  final Map<String, dynamic> data;
  final Map<String, dynamic> youtube;
  Map<String, dynamic> get extra => data;

  Post({
    required this.id,
    required this.category,
    required this.title,
    required this.content,
    required this.uid,
    required this.createdAt,
    required this.updateAt,
    required this.urls,
    required this.youtubeUrl,
    required this.commentCount,
    required this.data,
    required this.youtube,
  });

  factory Post.fromJson(Map<String, dynamic> json, String id) {
    return Post(
      id: id,
      category: json['category'],
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      uid: json['uid'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updateAt: json['updateAt'] is Timestamp
          ? (json['updateAt'] as Timestamp).toDate()
          : DateTime.now(),
      youtubeUrl: json['youtubeUrl'],
      urls: json['urls'] != null ? List<String>.from(json['urls']) : [],
      commentCount: json['commentCount'] ?? 0,
      data: json,
      youtube: json['youtube'] ?? {},
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'uid': uid,
        'createdAt': createdAt,
        'updateAt': updateAt,
        'urls': urls,
        'youtubeUrl': youtubeUrl,
        'commentCount': commentCount,
        'youtube': youtube
      };

  @override
  String toString() {
    return 'Post(${toJson()})';
  }

  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.exists == false) {
      throw Exception('Post.fromSnapshot: Post does not exist');
    }

    final docSnapshot = snapshot.data() as Map<String, dynamic>;
    return Post.fromJson(docSnapshot, snapshot.id);
  }

// get a post
  static Future<Post> get(String? id) async {
    if (id == null) {
      throw Exception('Post id is null');
    }
    final documentSnapshot = await PostService.instance.col.doc(id).get();
    if (documentSnapshot.exists == false) {
      throw Exception('Post.get: Post not found');
    }

    return Post.fromSnapshot(documentSnapshot);
  }

  // create a new post
  static Future<DocumentReference> create({
    required String category,
    String? title,
    String? content,
    List<String> urls = const [],
    String youtubeUrl = '',
    Map<String, dynamic>? extra,
  }) async {
    if (currentUser == null) {
      throw 'post-create/sign-in-required You must login firt to create a post';
    }
    if (category.isEmpty) {
      throw 'post-create/category-is-required Category is required';
    }

    final data = {
      'category': category,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      'uid': currentUser!.uid,
      'urls': urls,
      'youtubeUrl': youtubeUrl,
      'commentCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updateAt': FieldValue.serverTimestamp(),
    };

    if (category == 'youtube') {
      final youtube = await prepareYoutubeInfo(youtubeUrl);
      if (youtube == null) {
        throw 'post-create/invalid-youtube-url Invalid Youtube URL';
      }
      data['youtube'] = youtube;
      dog('msg: $youtube');
    }

    return await PostService.instance.col.add({
      ...data,
      ...?extra,
    });
  }

  Future<Post?> update({
    String? title,
    String? content,
    List<String>? urls,
    String? youtubeUrl,
    Map<String, dynamic>? extra,
  }) async {
    final data = {
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (urls != null) 'urls': urls,
      if (youtubeUrl != null) 'youtubeUrl': youtubeUrl,
    };

    if (category.toLowerCase() == 'youtube') {
      final youtube = prepareYoutubeInfo(youtubeUrl!);
      data['youtube'] = youtube;
    }

    if (data.isEmpty) {
      throw Exception('Post.update: No data to update');
    }
    await doc(id).update(
      {
        ...data,
        'updateAt': FieldValue.serverTimestamp(),
        ...?extra,
      },
    );

    return get(id);
  }

//  prepared youtube information
  static Future<Map<String, dynamic>?> prepareYoutubeInfo(
      String youtubeUrl) async {
    // get youtubeId
    final youtubeId = getIdFromUrl(youtubeUrl);

    if (youtubeId == null) {
      return null;
    }

    ///
    await Youtube.config(videoId: youtubeId);
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
}
