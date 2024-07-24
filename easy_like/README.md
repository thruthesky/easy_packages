# Easy Like and Dislike


The `like` and `dislike` functionality can be applied to various entities in the app, such as user profiles, uploaded photos, posts, and comments.

A simple way to handle this is by saving a list of user IDs who liked or disliked an item. However, if the document becomes too large, it can slow down the app and increase costs for network usage on Firebase. Additionally, Firestore documents have a 1MB size limit, which can cause issues if too many users like or dislike an item.

The `easy_like` package provides an easy and efficient way to manage the `like` and `dislike` functionality.



## Terms

- `vote` is the action of voting(doing) like or dislike.
- `like document` is the document under `/likes` collection.

## Database structure for Like and Dislike

- `/likes/{documentId}`: is the document for holding like and dislike.
    - The fields are
      - `documentId`: to filter the users who liked or disliked
      - `uid`: is the user who did like or dislike
      - `vote`: if it is true, the user did like. If it is false, the user did dislike.
      - `createdAt`: the date time of the vote.



## Logic

- It uses transaction to increase and decrease.
- Whenever there is a changes on `vote`, the number of `likes` and `dislikes` must be updated in the document.
- When the user unlike(or the like again), then the like document will be deleted.
- When the user dislike again (or undislike), then the like document will be deleted.
- When the user like on the documnet which he disliked before, then the like document will be changed and the `likes` and `dislikes` on the document should change.
  - When the user dislike on the document which he liked before, it goes the same.
- User can filter all the document of his vote.


