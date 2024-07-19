# Easy Comment

This `comment_package` offers a powerful and simple way to add comment features. It's versatile, perfect for things like post comments, product reviews, or photo feedback.



# Database Structure of Comment


The first thought of the database structure for comment is to use Realtime Database. But the `easy_comment` is not only used for post, but also anything that the developer wants. And it need to be more flexible. So, Firestore would be the right choice over Realtime database.




- To know the first level comment of a document
  - condition: if `parentId is empty`, then it's the first level comment.
