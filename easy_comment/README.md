# Easy Comment

This `comment_package` offers a powerful and simple way to add comment features. It's versatile, perfect for things like post comments, product reviews, or photo feedback.



# Terms


- `First level comments` are comments made(created) directly under a post.



# Database Structure of Comment


Initially, we considered using the Realtime Database for comments. However, since comments are needed for various parts of the app, not just posts, we require something more flexible. Therefore, Firestore is a better choice than the Realtime Database.


- `/comments/{commentId}` is the collection and document to store comments.

- To get the `first level comments`, you can use one of the following condition.
  - condition: if `parentId is empty`, then it's the first level comment.
  - condition: if `depth=0`.


- `hasChild` is true when the comment has a child or children. This is used to sorting and displaying the commnet in comment list view.

# Widgets


## CommentInputBox

This is a simple comment create widget.

```dart
CommentInputBox(
  parent: comment,
),
```






## Displaying comments


The `easy_comment` provides `CommentListView` to display the comments of the document. Note that, it is entirely up to use if you want to build your own comment list for different UI/UX instead of using `CommentListView`. 


You can use `CommentListView` like below to display the comments.

```dart
CommentListView(
  documentReference: ref,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemBuilder: (comment, index) =>
      CommentListDetail(comment: comment),
),
```

For the `itemBuilder`, you may use one of `CommentDetail`, `CommentListDetail`, `CommentListArrowDetail`, or `CommentListVerticalLineDetail`. Or you can copy the code and build your own.






