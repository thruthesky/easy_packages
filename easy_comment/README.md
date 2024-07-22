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


- ~~`hasChild` is true when the comment has a child or children. This is used to sorting and displaying the commnet in comment list view.~~ (This is comment out at Jul 22, 2024)


- `hasChild` field becomes true when the comment has a child.
  - It is not set in the database,
  - and it is only available when the comments are loaded by `Comment.getAll` method. Meaning, when you list comments with `FirestoreListView` widget, `hasChild` may not be available.







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








# Development Tips


## Testing

```dart
import 'package:easy_comment/easy_comment.dart';
import 'package:easy_post_v2/easy_post_v2.dart';
import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

class CommentTestScreen extends StatefulWidget {
  static const String routeName = '/CommentTest';
  const CommentTestScreen({super.key});

  @override
  State<CommentTestScreen> createState() => _CommentTestScreenState();
}

class _CommentTestScreenState extends State<CommentTestScreen> {
  @override
  Widget build(BuildContext context) {
    // final ref = my.ref;
    // final ref = Post.col.doc('1zsZ2YMplgZN6D6bdZIn');
    // final ref = Post.col.doc('0-console');
    // final ref = Post.col.doc('0-console-2');
    // final ref = Post.col.doc('0-con-3');
    // final ref = Post.col.doc('0-a');
    // final ref = Post.col.doc('0-b');
    // final ref = Post.col.doc('0-c');
    final ref = Post.col.doc('0-4');
    return Scaffold(
      appBar: AppBar(
        title: const Text('CommentTest'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24, 24, 0),
        child: MyDocReady(
          builder: () => ListView(
            padding: const EdgeInsets.all(0),
            children: [
              Text('Reference: ${ref.path}'),
              const SizedBox(height: 24),
              CommentFakeInputBox(
                onTap: () => CommentService.instance.showCommentEditDialog(
                  context: context,
                  documentReference: ref,
                  focusOnContent: true,
                ),
              ),
              CommentInputBox(
                documentReference: ref,
              ),
              CommentListView(
                documentReference: ref,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (comment, index) =>
                    CommentListArrowDetail(comment: comment),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CommentFakeInputBox(
          onTap: () => CommentService.instance.showCommentEditDialog(
            context: context,
            documentReference: ref,
            focusOnContent: true,
          ),
        ),
      ),
    );
  }
}
```