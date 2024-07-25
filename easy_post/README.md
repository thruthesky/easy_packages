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


- The `PostService.instance.showPostCreateScreen()` has an option of `youtubeUrl`. 

- If you create a post with a `youtubeUrl`  the post will generate a youtube information base on the `youtubeUrl`.

```dart
PostService.instance.showEditScreen(category: 'youtube');
```

displaying youtube screen

- you can display a youtube screen via `YoutubeScreen()` or `PostService.instance.showYoutubeScren()`
- YoutubeScreen supported fullscreen mode

```dart 
YoutubeScreen(
  post:post,
)

/// or 

PostService.intsance.showYoutubeScreen(
  post:pos
),
gs
```

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


# Post Details 
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

