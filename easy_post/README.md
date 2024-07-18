# Easy Post

A post management library for Firebase and Fltuter.




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