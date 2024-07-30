# Easy Post

A post management library for Firebase and Fltuter.



# Database Structure


- `youtubeUrl` has the youtube url. If there is no youtubeUrl, it must be an empty string. The `youtubeUrl` field must always exsit. To get posts that has youtube url, filter the post document using the firestore's `graterThan` filter.


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

``` dart
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

- `post`: The post document to display. It will be also used for initialData for the StreamBuilder of FutureBuilder to reduce the flickering.
- `sync`: If true, it will use `StreamBuilder` to fetch the post and rebuild the widget whenever the post is updated. If false, it will use `FutureBuilder` to fetch the post only once. The default is false.

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