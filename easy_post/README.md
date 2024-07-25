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


The categories can be set using the `init` method. And it's entirely up to you to decide what categories to use.

Example:
```dart
PostService.instance.init(categories: {
 'qna': '질문답변',
 'discussion': 'Discussion',
 'news': 'News',
 'job': '구인구직',
});
```

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
