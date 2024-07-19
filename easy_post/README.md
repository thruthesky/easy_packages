# Easy Post

A post management library for Firebase and Fltuter.



# Database Structure


- `youtubeUrl` has the youtube url. To get posts that has youtube url, filter the post document using the firestore's `graterThan` filter.


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

- You can set up categories yourself; they're not stored in the database.
  - But if you want, you can save it in the database by yourself.

- Here's an example of how to configure categories to fit the default design.

```dart
PostService.instance.init(categories: {
    'qna': '질문답변',
    'discussion': 'Discussion',
    'news': 'News',
    'job': '구인구직',
    'buyandsell': '사고팔기',
    'travel': '여행',
    'food': '음식',
    'study': '공부',
    'hobby': '취미',
    'etc': '기타',
});
```

- Remember, customizing categories is up to you. If you plan to design the UI/UX yourself, you don't need to set categories in the `init` method.



