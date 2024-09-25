# Easy Like and Dislike

The `easy_like` package provides an easy and efficient way to manage the `like` functionality.

The `like` functionality can be applied to various entities in the app, such as user profiles, uploaded photos, posts, and comments.

A simple way to handle this is by saving a list of user IDs who liked or disliked an item.

It does not support `dislike` since most of the community don't provide `dislike` button. It discourages users to participate the community.

## Installation

### Security rules

@thruthesky: Please add the security rules here.

## Terms

- `vote` is the action of voting(doing) like or unlike.
- `id` is the name of the node at `/likes/{id}` in database.
  - The id is actually the path of the parent node with dash(-) replace with slash(/). For example, if the parent node is `/posts/1234`, then the id is `posts-1234`.

## Database structure for Like and Dislike

- `/likes/{id}`: This is where like information saved. It must be formed as `type-id` where `type` is the type of the data like `post`, `comment`, `chat` and `id` is the id of the data node. By using this format, it can be easily searched and managed.
- The value of the node is Map type. The key is the uid of the user and the value is always `true`. If a user unlike, the key of uid will be deleted.

## Logic

- Whenever there is a changes on `vote`, the number of `likeCount` must be updated in the original (parent) node.

- When the user unlike, then the number of like will be decrease.

## Displaying the no of likes

- Since the `likeCount` field is saved on the document, it can simply display with the document. so, the `easy_like` package does not provide andy widgets.

- Below is how to diplay `likeCount` on a post detail screen. Note the the post detail screen should listen to the database update.

Example:

```dart
TextButton(
  onPressed: () async {
    final like = Like(uid: my.uid, documentReference: widget.post.ref);
    await like.like();
  },
  child: Text(
    'Like'.tr( args: {'n': widget.post.likeCount}, form: widget.post.likeCount),
  ),
),
```

## Changing Icons if like or unlike

- You can display diffrent widget base on the status of the like (like or unlike)

- `LikeDoc` is a widget that you can use to determine of the like status(like or unlike)

Example

```dart
IconButton(
  onPressed: () async {
    final like = Like(documentReference: post.ref);
    await like.like();
  },
  icon: LikeDoc(
      uid: my.uid,
      documentReference: post.ref,
      sync: true,
      builder: (islike) {
        return FaIcon(
          islike
              ? FontAwesomeIcons.solidHeart
              : FontAwesomeIcons.heart,
          color: Colors.pink[700],
          size: 30,
        );
      }),
),
```

# onLiked CallBack

The `onLiked` is a callback after the liked/unliked is triggered using the Like.like() model is fired.

Usage: (e.g. send push notification to other user)

In the example below, we can send push notification to the post owner after the like is triggered. It contains the `Like` information, and `isLiked` if the like is liked or not.

```dart
    LikeService.instance.init(
      onLiked: ({required Like like, required bool isLiked}) async {
        /// only send notification if it is liked
        if (isLiked == false) return;

        /// get the like document reference for more information
        /// then base from the document reference you can swich or decide where the notificaiton should go
        /// set push notification. e.g. send push notification to post like
        if (like.documentReference.toString().contains('posts/')) {
          Post post = await Post.get(like.documentReference.id);

          /// dont send push notification if the owner of the post is the loggin user.
          if (post.uid == myUid) return;

          /// can get more information base from the documentReference
          /// can give more details on the push notification
          MessagingService.instance.sendMessageToUids(
            uids: [post.uid],
            title: 'Your post got liked',
            body: '${my.displayName} liked ${post.title}',
            data: {
              "action": 'like',
              "source": 'post',
              'postId': post.id,
              'documentReference': like.documentReference.toString(),
            },
          );
        }
      },
    );
```
