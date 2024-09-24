import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easy_post_v2/src/defines.dart';
import 'package:easy_storage/easy_storage.dart';
import 'package:firebase_database/firebase_database.dart';

/// Post mostly contains a `title` and `content` there might be also a image when
/// the user post image
///
/// `id` is the postid and it also the database id of the post
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

  static const field = (
    id: 'id',
    category: 'category',
    title: 'title',
    subtitle: 'subtitle',
    content: 'content',
    uid: 'uid',
    createdAt: 'createdAt',
    updateAt: 'updateAt',
    urls: 'urls',
    deleted: 'deleted',
    youtubeUrl: 'youtubeUrl',
    youtube: 'youtube',
    order: 'order',
    commentCount: 'commentCount',
    likeCount: 'likeCount',
  );

  final String id;
  final String category;
  final String title;
  final String subtitle;
  final String content;
  final String uid;
  final DateTime createdAt;
  final DateTime updateAt;
  final List<String> urls;
  final bool deleted;
  final int order;

  /// The database reference of current post
  DatabaseReference get ref => postRef(id);

  /// get the first image url
  String? get imageUrl => urls.isNotEmpty ? urls.first : null;

  /// Youtube URL. Refer README.md for more information
  final String youtubeUrl;
  final Map<dynamic, dynamic> youtube;

  /// Returns true if the current post has youtube.
  bool get hasYoutube => (youtubeUrl.isNotEmpty && youtube.isNotEmpty) || youtube['id'] != null;

  final int likeCount;
  final int commentCount;

  final Map<String, dynamic> data;

  Map<String, dynamic> get extra => data;

  /// Return true if the post is created by the current user
  bool get isMine => currentUser?.uid == uid;

  Post({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.uid,
    required this.createdAt,
    required this.updateAt,
    required this.urls,
    required this.youtubeUrl,
    required this.commentCount,
    required this.data,
    required this.youtube,
    required this.deleted,
    required this.likeCount,
    required this.order,
  });

  factory Post.fromJson(Map<dynamic, dynamic> json, String id) {
    return Post(
      id: id,
      category: json[field.category],
      title: json[field.title] ?? '',
      subtitle: json[field.subtitle] ?? '',
      content: json[field.content] ?? '',
      uid: json[field.uid],
      createdAt:
          json[field.createdAt] is int ? DateTime.fromMillisecondsSinceEpoch(json[field.createdAt]) : DateTime.now(),
      updateAt:
          json[field.updateAt] is int ? DateTime.fromMillisecondsSinceEpoch(json[field.updateAt]) : DateTime.now(),

      /// youtubeUrl never be null. But just in case, it put empty string as default.
      youtubeUrl: json[field.youtubeUrl] ?? '',
      urls: json[field.urls] != null ? List<String>.from(json[field.urls]) : [],
      commentCount: json[field.commentCount] ?? 0,
      data: json is Map<String, dynamic> ? json : {},
      youtube: json[field.youtube] ?? {},
      deleted: json[field.deleted],
      likeCount: json[field.likeCount] ?? 0,
      order: json[field.order],
    );
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        field.category: category,
        field.title: title,
        field.subtitle: subtitle,
        field.content: content,
        field.uid: uid,
        field.createdAt: createdAt,
        field.updateAt: updateAt,
        field.urls: urls,
        field.youtubeUrl: youtubeUrl,
        field.commentCount: commentCount,
        field.youtube: youtube,
        field.deleted: deleted,
        field.likeCount: likeCount,
        field.order: order,
      };

  @override
  String toString() {
    return 'Post(${toJson()})';
  }

  factory Post.fromSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists == false) {
      throw PostException('post/fromSanpshot', 'Post.fromSnapshot: Post does not exist');
    }

    final value = snapshot.value as Map<dynamic, dynamic>;
    return Post.fromJson(value, snapshot.key!);
  }

// get a post
  static Future<Post> get(String postKey) async {
    final snapshot = await postRef(postKey).get();
    if (snapshot.exists == false) {
      throw 'post-get/post-not-found Post not found';
    }

    return Post.fromSnapshot(snapshot);
  }

  static Future<T> getField<T>(String id, String field) async {
    final snapshot = await postFieldRef(id, field).get();
    if (snapshot.exists == false) {
      throw 'post-get/post-not-found Post not found';
    }
    return snapshot as T;
  }

  // create a new post
  static Future<DatabaseReference> create({
    required String category,
    String? title,
    String? subtitle,
    String? content,
    List<String> urls = const [],
    String youtubeUrl = '',
    Map<String, dynamic>? extra,
  }) async {
    if (currentUser == null) {
      throw PostException('post-create/sign-in-required', 'You must login firt to create a post');
    }

    /// This millisecond is the date and time of 2054-09-23 4:10:53.512
    /// This is used to set the order of category.
    const int baseMilliseconds = 2673158953512;

    final order = DateTime.now().millisecondsSinceEpoch * -1;

    final youtube = await getYoutubeSnippet(youtubeUrl);

    final data = {
      field.category: '$category-${baseMilliseconds - order}',
      field.order: order,
      if (title != null) field.title: title,
      if (subtitle != null) field.subtitle: subtitle,
      if (content != null) field.content: content,
      field.uid: currentUser!.uid,
      field.urls: urls,
      field.youtubeUrl: youtubeUrl,
      field.commentCount: 0,
      field.createdAt: ServerValue.timestamp,
      field.updateAt: ServerValue.timestamp,
      field.deleted: false,
      if (youtube != null) field.youtube: youtube,
      ...?extra,
    };

    DatabaseReference newRef = PostService.instance.postsRef.push();

    /// Callback before post is created
    PostService.instance.beforeCreate?.call(Post.fromJson(data, newRef.key!));

    await newRef.set(data);

    // await PostService.instance.database.ref().update(postRef(id));

    /// Callback after post is created
    PostService.instance.afterCreate?.call(Post.fromJson(data, newRef.key!));

    /// Update the category and order of the post
    postFieldRef(newRef.key!, field.createdAt).get().then((snapshot) async {
      int createdAt = snapshot.value as int;
      await newRef.update({
        field.category: '$category-${baseMilliseconds - createdAt}',
        field.order: createdAt * -1,
      });
    });

    return newRef;
  }

  /// update a post
  ///
  /// TODO: display loader while updating
  /// TODO: display loader and percentage while image uploading
  Future<void> update({
    String? title,
    String? subtitle,
    String? content,
    List<String>? urls,
    String? youtubeUrl,
    Map<String, dynamic>? extra,
  }) async {
    final data = {
      if (title != null) field.title: title,
      if (subtitle != null) field.subtitle: subtitle,
      if (content != null) field.content: content,
      if (urls != null) field.urls: urls,
      if (youtubeUrl != null) field.youtubeUrl: youtubeUrl,
    };

    await ref.update(
      {
        ...data,
        if (youtubeUrl != null && this.youtubeUrl != youtubeUrl) field.youtube: await getYoutubeSnippet(youtubeUrl),
        field.updateAt: ServerValue.timestamp,
        ...?extra,
      },
    );
  }

  /// delete post, this will not delete the post but instead mark the post in
  /// database as deleted
  ///
  /// TODO: display loader while deleting
  Future<void> delete() async {
    if (deleted == true) {
      throw 'post-delete/post-already-deleted Post is already deleted';
    }

    for (String url in urls) {
      await StorageService.instance.delete(url);
    }

    await ref.update({
      field.deleted: true,
    });
  }
}
