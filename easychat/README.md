# EasyChat

EasyChat offers everything you need to build a chat app. With the EasyChat package, you can easily add a full-featured, attractive chat function to your existing app.


For your information, EasyChat:

- Uses Firestore for chat room management for efficiency,
- Utilizes Realtime Database for cost-saving measures like managing chat messages and tracking new message counts,
- Allows integration with your existing app to fetch user information,
- Supports push notification subscriptions and sending,
- Enables file transfers and URL previews, among others,
- Provides everything needed for chat functionality,
- Comes with a beautiful UI/UX by default,
- Is optimized for use in large-scale chat applications.



## Install


Add `easychat` into your `pubspec.yaml`

```sh
% flutter pub add easychat
```

## Initialization

```dart
ChatService.instance.init();
```


## User database

If your app uses diferent Firestore database structure from what `easychat` expects, you can use the `easyuser` package to setup the user database structure to fit your app.

For instance, if your app manages user information in `/members` collection, and displayName as `nickname`, user's photo as `photoURL` and the name to search is `searchName`, you can set like below.

```dart
UserService.instance.init(
    userCollection: 'members',
    displayName: 'nickname',
    searchName: 'searchName',
    photoUrl: 'photoURL',
);
ChatService.instance.init();
```

## Chat Database


### Chat room database struture

- `/chat-rooms/{roomId}` is the document of chat room information.
- `users` field has the list of user's uid who joined the chat room.
  - There is no 1:1 chat room or group chat room. Or you may consider if there are only two users in the room, then it may be 1:1 chat.
- `invitedUsers` field has the list of invited user's uid. They cannot enter the chat room, until they confirm it in the app.
- `createdAt` is the Firestore Timestamp when the chat room created.
- `updatedAt` is the Timestamp when the chat room information updated.
- `lastMassage` is the last message. It may not exist.
- `lastMessageAt` is the Timestamp of the last message sent.
- `lastMessageUid` is the user's uid who sent the last message
- `lastMessageUrl` is the photo or file url of the last message. It may not exist.



### Chat new message database struture

- The value of the new message of each chat room is saved under the Realtime Database: `/chat-no-of-new-messages/{uid}/{chatRoomId}/`.




## Logic



## Messages from unknown

It really happened to one of my own projects that some sent very bad words to many users that he does not know. And he ruined the app. So, we have a special feature to prevent this. And this feature is optional.

It only works in 1:1 chat.

- When A sends a chat message to B for the first time, the package considers that A is sending a chat invitation to B. So, the package send a chat message to B together with the invitation.
- On B's screen, B will only see a chat invitation on his chat list. B will not see the chat room but invitaion only.


## Chat invitation

- Chat invitation is an optional.
  - It can be disabled by default with the option that allows each user to enable it.
  - Or it can be enabled by default with the option that each user to disable it.


- If it is enabled, then the user must accept the invitation to enter the chat room.
  - For instance,
    - A sends a chat message to B for the first time while creating the chat room,
      - then B's uid will be added to `invitedUsers`
        - and a push message should be sent to B.
      - and the chat message is normally saved in the chat room.
    - On B's screen, all the chat room that has B's uid in `invitedUsers` will be displayed on top of the chat list. And B will notice that he is invited.
      - If B accepts the invitation, B's uid will be moved from `invitedUsers` to `users` and normal chat continues.













