# Easy Like and Dislike


The `like` unctionality can be applied to various entities in the app, such as user profiles, uploaded photos, posts, and comments.

A simple way to handle this is by saving a list of user IDs who liked or disliked an item. However, if the document becomes too large, it can slow down the app and increase costs for network usage on Firebase. Additionally, Firestore documents have a 1MB size limit, which can cause issues when there are too many like.

The `easy_like` package provides an easy and efficient way to manage the `like` functionality.

It does not support `dislike` since most of the community don't provide `dislike` button. It discourages usres to participate the community.


## Installation

### Security rules


- On the document, the `likes` should be open to be written by any one.




## Terms

- `vote` is the action of voting(doing) like or unlike.
- `like document` is the document under `/likes` collection.

## Database structure for Like and Dislike

- `/likes/{documentId}`: is the like document for holding like information.
    - The fields are
      - `documentReference`: to access the document that this like belong to.
      - `likedBy`: is the list of user uid who did like. If the user unlikes, then the uid will be removed.

## Logic

- It uses transaction to increase and decrease.
- Whenever there is a changes on `vote`, the number of `likes` must be updated in the original document.
- When the user unlike(or the like again), then the no of like will be decrease.



## Displaying the no of likes


- Since the `likes` field is saved on the document, it can simply display with the document. so, the `easy_like` package does not provide andy widgets.

- Below is how to diplay likes on a post detail screen. Note the the post detail screen should listen to the database update.

Example:
```dart
TextButton(
  onPressed: () async {
    final like = Like(uid: my.uid, documentReference: widget.post.ref);
    await like.like();
  },
  child: Text(
    'Like'.tr( args: {'n': widget.post.likes}, form: widget.post.likes),
  ),
),
```