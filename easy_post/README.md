# Easy Post

A post management library for Firebase and Fltuter.

# TODOs

- Use Realtime Database for Post Listing.
  - Mirror the title, uid, first photo, createdAt into Realtime Database for
    - all categories in one path
    - each category in each path
  - Mirro all the post information into a RTDB
  - This is for reducing the cost.
  - The Firestore will hold data for keeping original data and filtering purpose.

# Database Structure

- `youtubeUrl` has the youtube url. If there is no youtubeUrl, it must be an empty string. The `youtubeUrl` field must always exsit. To get posts that has youtube url, filter the post document using the firestore's `graterThan` filter.

- 'posts'
  - category
  - id
  - uid
  - ........ so on

# Custom Data

You can use `extra` field to save custom fields and values.

```dart
await Post.create(category: 'puzzle-score', extra: {
'size': size,
'time': timeElapsed,
'moves': movedTile,
});
```

You can access the custom value like `post.extra['size']`. Note that, the `post.extra` is merely the alias of `post.data`.

# Category

The category is being saved in `category` field. The `category` field must exists and it can be empty string.

It's entirely up to you to decide how you want to design the UI/UX of the categories. But by default, `easy_post_v2` uses `easy_category`.

`easy_post_v2` provides post list screen and it requires some categories. You can feed the categories like below;

Example:

```dart
PostService.instance.showPostListScreen(
  context: context,
  categories: [
    Category(id: 'qna', name: 'QnA'),
    Category(id: 'discussion', name: 'Discussion'),
    Category(id: 'youtube', name: 'Youtube'),
    Category(id: 'buyandsell', name: 'Buy and Sell'),
    Category(id: 'job', name: 'Jobs'),
    Category(id: 'news', name: 'News'),
  ],
)
```

If you don't want to use the `easy_category`, you can customize the whole post list screen by yourself. And actually, customizing the whole post list screen is recommended since your app would require different UI/UX. But that does not mean you have to use something other than `easy_category`. You can still use it even if you customize the UI/UX of the whole post screens and widgets.

You can develop your own post list screen where you can design your own category options. It's really up to you for anything. You don't even have to use categoreis if you don't need them.

# Youtube

- You can save the URL of youtube video at `youtubeUrl` field in the post document.
- When you save it (or change it), the post model automatically produces the `youtube` map field in the post document with the name, title, views, thumbnail images, etc.
- You can use the `youtube` map data to display the youtube thumbnail and title on the post list screen.
- The default UI screen for creating and updating has youtube url input box already.
- And there is a default screen for displaying youtube video as a post list view. You can use `PostService.instance.showYoutubeListScreen()`. This screen will show youtube thumbnails and metadata in the list view. If the post has no youtube, then it will show the post title.
- The post details screen displays youtube if there is a youtube. Otherwise, it will display post details without youtube.

# Screen

## Youtube Screen

- you can display a youtube screen with `PostService.instance.showYoutubeScren()`
- YoutubeScreen supported fullscreen mode

Displaying a Youtube video

- to display a youtube video alone you can use `YoutubePlayer()`

```dart
YoutubePlayer(
  post:post,
)
```

- youtube with fullscreen you need to wrap your scaffold with `YoutubeFullscreenBuilder`
  this widget allows your youtube video to be fullscreen

```dart
YoutubeFullscreenBuilder(
  post: post,
  builder: (context, youtube){
    return youtube;
  }
)
```

## Post Create Screen

- Displaying a post creation screen, simply call `PostService.instance.showPostCreateScreen()`

```dart
IconButton(
  onPressed: () {
    PostService.instance
        .showPostCreateScreen(context: context, category: 'idol');
  },
  icon: const Icon(Icons.add),
),
```

- To display your own customize post creation screen you initialize post create screen like this.

- you can still used the default design if you only want to customize something base on your need.

```dart
PostService.instance.init(
  showPostCreateScreen: (context, category) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          if (category == 'idol') {
            return const IdolCreateScreen();
          }
          return PostEditScreen(category: category);
        });
  },
);
```

## Post Update Screen

- to display a post update screen, simply call `PostService.instance.showPostUpdateScreen()`

```dart
IconButton(
  onPressed: () {
    PostService.instance
        .showPostUpdateScreen(context: context, post:post);
  },
  icon: const Icon(Icons.add),
),
```

- To display your own customize post update screen you can initialize post update screen like the example below.

- you can still used the default design if you only want to customize something base on your need.

```dart
PostService.instance.init(
  showPostUpdateScreen: (context, post) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          if (category == 'idol') {
            return const CustomUpdateScreen(post: post);
          }
          return PostEditScreen(category: post.category);
        });
  },
);
```

## Post Detail Screen

To display display the details of post you can use `PostServices.instance.showPostDetailScreen()` or `PostDetailScreen()`

```dart
IconButton(
  icon: const Icon(Icons.add),
  onPressed: () async {
    await PostService.instance.showPostDetailScreen(
      context: context,
      post: post,
    );
  },
),

/// or

PostDetailScreen(post: post);

```

- To display your own customize post detail, simply initialize the showPostDetailScreen from the example.

- You can still use the default design if you only want to customize something base on your need.

```dart
PostService.instance.init(
  showPostDetailScreen: (context, post) {
    return showGeneralDialog(
        context: context,
        pageBuilder: (_, __, ___) {
          if (post.category == 'idol') {
            return const IdolDetailScreen();
          }
          return PostDetailScreen(post: post);
        });
  },
);
```

# Widgets

## PostDoc

`PostDoc` is a widget that displays a post document.

- `category`: The category of the post.
- `id`: The id of the post.
- `field`: This is optional. If you want to display a specific field of the post, you can specify it here.
- `sync`: If true, the widget will be rebuilt whenever the post is updated. If false, the widget will be built only once. The default is false.

Example:

```dart
@override
Widget build(BuildContext context) {
  return PostDoc(
      post: post,
      sync: true,
      builder: (post) {
        /// If the post has no youtube video, return the normal scallfold.
        if (post.hasYoutube == false) {
          return NormalPostScaffold(context);
        }

        /// If the post has youtube video, return the youtube fullscreen
        /// builder.
        return YoutubeFullscreenBuilder(
            post: post,
            builder: (context, player) {
              return YoutubePostScaffold(context, player);
            });
      });
}
```

## Post Detail Widgets

Creating your own screen, you might want to create a customize screen to specific need of your app and still want to use the some of the default
widget used on the defualt screen, you can use the widget below

- `PostDetail` this contains the default widget used in `PostDetailScreen` such as `user meta data`, `post`, `post action button`.

- `PostDetailCommentListTreeView` this contains the list of comments of the Post.

- `PostDetailCommentInputBox` this contains the post comment input box and will open a bottom sheet to input the commnet.

- `PostDetailBottomAction` this contains the post action such as `like`, `comment` and `menu` for `edit`, `delete`, `report`, `block`

- `PostCommentTextButton` this button allows you to open the post comment input box you can use.

- `PostLikeTextButton` this button allows you to toggle like and unlike button by passing the `post` information.

- `PostPopupMenuButton` this button allows you to open more menu such report, block, delete and edit.

# Developer's Tips

## Show a post screen with random post creation

Sometimes, you would want to see the post view screen for testing or designing. You can do the following.

```dart
initState() {
  (() async {
    final ref = await Post.create(
        category: 'yo', title: 'title', content: 'content');
    final post = await Post.get(ref.id);
    PostService.instance
        .showPostDetailScreen(context: globalContext, post: post);
  })();
}
```

## Get posts

To get some posts, you can code like below.

```dart
PostService.instance
    .getPosts(category: 'youtube', limit: 100)
    .then((value) {
      posts.addAll(value);
  }
);
```

## Creating the document if it does not exists

You have built a candy crush game app and you want to keep the user's score based on the grid size. There must be only one document per each size of the user.

And you want to display the best score on the screen in realtime. Then, you can do the following.

```dart
listenBestScore() {
  /// 1. Make sure that the score document exists.
  (() async {
    final List<Post> posts = await PostService.instance.getPosts(
      query: PostService.instance.col
          .where('category', isEqualTo: Config.candyCrushCategory)
          .where('uid', isEqualTo: my.uid)
          .where('size', isEqualTo: gridSize)
          .limit(1),
    );
    if (posts.isEmpty) {
      /// Create a new score document if the user does not have one.
      await Post.create(category: Config.candyCrushCategory, extra: {
        'category': Config.candyCrushCategory,
        'uid': my.uid,
        'size': gridSize,
        'score': currentScore,
      });
    }
  })();

  /// 2. Then, listen for the realtime update.
  bestScoreSubscription = PostService.instance.col
      .where('category', isEqualTo: Config.candyCrushCategory)
      .where('uid', isEqualTo: my.uid)
      .where('size', isEqualTo: gridSize)
      .limit(1)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isNotEmpty) {
      bestScorePost = Post.fromSnapshot(snapshot.docs.first);
      bestScore = bestScorePost!.extra['score'] ?? 0;
      dog('bestScore: $bestScore');
      setState(() {});
    }
  });
}
```

# postListActionButton

You can add extra button on the header in post list screen.
The `postListActionButton` contains the category information from Postlist if category is selected and it accepts a Function that return a widget

The return widget will be display in the action button.

Usage: (e.g. adding extra icon on the chat room header. like notification toggle icon)

Example below using `PushNotificationToggleIcon` widget to subscribe to subscriptionName.

```dart
    PostService.instance.init(
      postListActionButton: (category) => PushNotificationToggleIcon(
        subscriptionName: category.isNullOrEmpty
            ? 'post-sub-no-category'
            : "post-sub-$category",
      ),
    );
```

# onCreate CallBack

The `onCreate` is a callback after the post is created.
This contain the newly created `Post` information.

Usage: (e.g. push notification to other users who subscribe to the category)

With the Subscription example fro postListActionButton, we can send push notification to other users who subscribe to the category.

In the example below, users can use `PushNotificationToggleIcon` to subscribe to `post-sub-$category` subscriptionName. Then we also send push notification to other users who subscribe to `post-sub-$category` subscriptionName after the post is created.

```dart
    PostService.instance.init(
      postListActionButton: (category) => PushNotificationToggleIcon(
        subscriptionName: category.isNullOrEmpty
            ? 'post-sub-no-category'
            : "post-sub-$category",
      ),
      onCreate: (Post post) async {
        /// send push notification to subscriber
        MessagingService.instance.sendMessageToSubscription(
          subscription: post.category.isNullOrEmpty
              ? 'post-sub-no-category'
              : "post-sub-${post.category}",
          title: 'post title ${post.title}  ${DateTime.now()}',
          body: 'post body ${post.content}',
          data: {
            "action": 'post',
            'postId': post.id,
          },
        );
      },
    );
```



# Known Issues


## flutter_inappwebview_ios issue - Method does not override any mehtod from its superclass

Override the patch like below.

```yaml
dependency_overrides:
  # TODO: Recheck once flutter_inappwebview version >6.0.0 is released
  flutter_inappwebview_ios:
    git:
      url: https://github.com/IncM/flutter_inappwebview
      path: flutter_inappwebview_ios
      ref: cbc214c7b2cf5fd7996ff2e9e25d203946b74bc3
```


Error messages


```txt
Swift Compiler Error (Xcode): Method does not override any method from its superclass
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1431:25


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1035:20


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1038:16


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1047:20


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1050:16


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1327:25


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:1912:8


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:2859:22


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:2870:22


Swift Compiler Error (Xcode): Ambiguous use of 'evaluateJavaScript(_:completionHandler:)'
/Users/thruthesky/.pub-cache/hosted/pub.dev/flutter_inappwebview_ios-1.0.13/ios/Classes/InAppWebView/
InAppWebView.swift:2964:17


Encountered error while building for device.
```