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

### Chat room database struture (Firestore)

- `/chat-rooms/{roomId}` is the document of chat room information.
- `users` field has the list of user's uid who joined the chat room.
  - There is no 1:1 chat room or group chat room. Or you may consider if there are only two users in the room, then it may be 1:1 chat.
- `invitedUsers` field has the list of invited user's uid. They cannot enter the chat room, until they confirm it in the app.
- `rejectedUsers` field has the uid list of the rejected users from the invitation. Once the user rejected, his uid is moved from `invitedUsers` to `rejectedUsers`. In this way, the rejected users will not see the invitation in the chat list any more and the inviter cannot invite anymore.
- `blockedUsers` is the uid list of blocked users by masters.
- `masterUsers` is the uid list of master user. See [Masters](#masters)
- `createdAt` is the Firestore Timestamp when the chat room created.
- `updatedAt` is the Timestamp when the chat room information updated.
- `lastMessageText` is the last message. It may not exist.
- `lastMessageAt` is the Timestamp of the last message sent.
- `lastMessageUid` is the user's uid who sent the last message
- `lastMessageUrl` is the photo or file url of the last message. It may not exist.
- `open` if it is set to true, the chat room is open chat. So, it is listed in the open chat rom list and anyone can join the chat room without invitation.
- `hasPassword` is set to true if the chat room has a password. See [Password](#password)

- `single` - is true when the room is single chat
- `group` - is true when the room is group chat
- `open` - is true when the room is open group chat.


### Chat message database struture (RTDB)

For the speed and cost efficiencies, the chat messages are saved under `/chat-messages/{roomId}` in Realtime Database


- `senderUid` is the chat message sender uid.
- `createdAt` is the date time of the chat message.
- `order` is the chat message list order.
- `text` is the text of the chat message.
- `url` is the url of photo or file of the chat message.
- `deleted` is true when the message is deleted. if the message is deleted, then text, url, url preview values will be deleted.
- When sending a chat message, if the text contains a URL, the site information is displayed for previewing. The appropriate values are stored in the following fields below the message:
    - `previewUrl` - URL
    - `previewTitle` - Title
    - `previewDescription` - Description
    - `previewImageUrl` - Image


### Chat room settings per each users (RTDB)

- Chat room user setting will be saved under `/chat-room/{uid}/{roomId}` in Realtime Database.

- Why is the personal chat room setting required?
  - Users can customize their chat rooms in several ways, such as:
    - Naming their chat rooms.
    - Marking certain chat rooms as favorites.
    - Subscribing to push notifications for updates.
  - Or the chat package saves the number of new messages in each chat room.
  - And much more.

# Logic

## Group Chat and 1:1 Chat

- `1:1 chat` is also called `single chat`.
- There is only one logic of the chat room and all the chat rooms are considered as a group chat. Even if it's a `1:1 chat`, it is considered as `group chat` and the logic goes same as group chat.

- But why do we need to separate it as a single chat or group chat?
  - When A chats to B, A wants to chat with B alone in 1:1 chat mode.
    - Then, the app will create a chat room
      - And then, some time later, B wants to chat with A in a 1:1 chat mode.
        - Then, they need to continue the previous chat room.
        - If there is only group chat, it will create the chat room over and over again and they cannot resume the previous chat room.

## Masters

The one who create chat room automatically becomes a master. And he can add another user as a master.

## Chat invitation

It really happened to one of my own projects that someone sent very bad words to many other users that he does not know. And he ruined the app. So, we have a special feature to prevent this. And this feature is optional.

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

## Password

The password must kept in secret by the Security rules. Then, how the user can join the chat room without the help of backend? Here is a solution.

- Since the password is secured, the password must not be saved in chat room document.
- So, it is saved under `/chat-room/{roomId}/chat-room-meta/private` document.
- And, client cannot read the password and when the user enters the password, how the client can check if the password is correct or not?

The solution is that,
- The user will save the password in `/users/{uid}/user-meta/private {chatRoomPassword: ...}`
- And user tries to join the room and in the security rule,
  - Security rules is the one to check if the password in user meta and in the chat private are the same.
    - If they are the same, then the user can enter the chat room.

This is the way how it can compare the chat password.









# Development Tip


## Opening chat room create in main.dart

```dart
class MyAppState extends State<MyApp> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      ChatService.instance.showChatRoomEditScreen(globalContext);
    });
```

