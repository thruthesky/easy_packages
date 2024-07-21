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
