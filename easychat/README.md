# EasyChat


This `easychat` package offers everything you need to build a chat app. With this package, you can easily add a full-featured, attractive chat function to your existing app.

- [EasyChat](#easychat)
- [Terms](#terms)
- [TODO](#todo)
- [Why Realtime Database](#why-realtime-database)
- [Installation](#installation)
  - [Secuirty rules](#secuirty-rules)
    - [Realtime Database Security Rules](#realtime-database-security-rules)
    - [Storage Rules](#storage-rules)
    - [Firestore Rules](#firestore-rules)
    - [Firestore Indexes](#firestore-indexes)
- [Dependencies](#dependencies)
- [Logics](#logics)
  - [Ordering](#ordering)
  - [Counting the invitation](#counting-the-invitation)
- [Database Strucutre](#database-strucutre)
  - [Chat room](#chat-room)
  - [Chat message](#chat-message)
  - [Chat join](#chat-join)
  - [Chat setting](#chat-setting)
    - [Saving unread number of messages.](#saving-unread-number-of-messages)
    - [Changing the chat room name](#changing-the-chat-room-name)
    - [Saving push notifications](#saving-push-notifications)
  - [Invited, Rejected Users](#invited-rejected-users)
  - [Server timestamp](#server-timestamp)
- [Widgets](#widgets)
  - [Displaying chat room information](#displaying-chat-room-information)
  - [ChatInvitationCounter](#chatinvitationcounter)
  - [ChatInvitationListView](#chatinvitationlistview)
- [Coding Guideline](#coding-guideline)
  - [How to get server timestamp](#how-to-get-server-timestamp)
- [Known Issues](#known-issues)

# Terms

- `Required`: If it is used with field description, it means the field must exists in the data always.
- `Rear exception`: An exception that should not occure during normal app usage. For instance, the user always need to be a chat room member to send a message. There is no change for any user can send message if they are not a member. If they are not a member of the chat room, they should be able to open, or once they open the chat room they need to become the member, or there must be an error on the chat room screen. So, they never have a change to send a message if they are not a member. In this case, we may still throw an excpetion with comment of `rear exception`. And this kind of exception should not be handled to display to a user. But may be used for a debug or error reporting system like `Firebase Crashlytics`.




# TODO

- Support: `verifiedUserOnly`, `urlForVerifiedUserOnly`, `uploadForVerifiedUserOnly`.
- Support: password.
- Support: gender. To let only female or male join.
- Support: chat room customization for each user. For instance, the user may
  - want to pin the chat room on top of the chat room list
  - want to change the color of the chat room title for the priority
  - want to chagne the name of the chat room when the chat room name or photo are not set properly or the other user name is not set properly.
- Support: master can invite another user as master.
- Support: the chat room invitation as optional. So, users can be invited directly without invitation.
- Support: Favorite chat friend. Display favorites chat friend in horizontal carousel view.
- Example: Create full featured chat example
- Document: Add the whole screenshot of the chat screens and functions.
- Document: Write complete document



# Why Realtime Database


For your information on `easychat` history:

- We built this package using firestore 4 years ago. Since then we continously updating this package as a part of [fireflutter](https://github.com/thruthesky/fireflutter/tree/v-2024-07-08) package.
- Recently in 2024, we decided to use realtime database because the package built with firestore is expensive. It's not for a big sized application.

- So, we built it in realtime database in [fireflutter version 4.x.x](https://github.com/thruthesky/fireflutter/tree/v-2024-07-08).
  - realtime database is much cheaper,
  - simpler,
  - faster

- Then, sometime later in mid 2024, we found out that developers are hesitating to use the realtime database. Developers who use Firebase are more pond of Firestore over Realtime Database. There are more chance to filter information in chat room. To give easy to developers, So, we decided to put chat room information in Firestore. And the chat message remains in realtime database. We named it as `easychat` with the version `0.0.x`.
  - Soon after we realized that there is no easy solution to keep the data safe.
    - The chat room user information is in Firestore and the chat room messages are in Realtime Database. To secure the chat room message, the user list of the chat room must be in realtime database, but it is in Firestore.
      - We have thought of the solutions;
        - Creating a cloud function to mirror the user list from firestore to realtime database is not an ideal because (1) It gives burden to developers to install the cloud function. we can make it Firebase Extension, but still it's an extra work. (2) The speed of reactiveness it a bit slow. When user enter the chat room, the user list is not mirrored from firestore to rtdb quickly.
        - Security rules adjsutment;
          - We found out some possible senarios to make it work by tweeking the security rules and client codes. But they are not so simple and clean. The one of the reason why we moved from realtime database to firestore is because we wanted to give other developers to feed easy. And adjusting with the security rules goes in even more complicated logic.

- For the reason above, we go back to the realtime database again to make it more fast and scalable. When the scalability of cost, the realtime database is the best choice.



# Installation

## Secuirty rules

### Realtime Database Security Rules

### Storage Rules

### Firestore Rules

`easychat` uses the firestore for some functionalities like reporting the user or chat rooms.

### Firestore Indexes




# Dependencies

- To invite other users, it needs the search users by name. To achevie this, it uses `easyuser` package.


# Logics


## Ordering

- Since the realtime database has no filtering, it needs multiple order fields to display items in order.
  - For instance,
    - singleOrder
    - groupOrder
    - openOrder
    - order

- The order field must have negative millisecond timestamp value to display in reverse order.

- The milliseconds has 13 digits like `1000000000000`
  - It negates the time like `-1000000000000`. This is the order value. So, the chat rooms are listed in reverse.
  - If the chat room has new messages, then we add `-1` (by adding `-10000000000000` - 14 digits) infront of the order. Meaning, it becomes like `-11000000000000`. If the order begins with `-11`, then it is a chat room that has new message. if the user have seen(open) the chat room, then remove the front `-1` by dividing 10.




- The logic of updating order #1. This logic is a bit complicated but performs better because it write the data immediately to server with client time which more likely works as expected. Then it corrects the time silently.
  - 1. Save the negative timestamp value from client time to the order field.
  - 2. Read the time of `updatedAt` from the chat room data (or chat join data).
  - 3. Correct the order with server time.
  - 4. Update the order of chat joins.

- The logic of updating order #2. Simple. And believe the performance is not noticible.
  - 1. Write a sample time data to the realtime database.
  - 2. Get the time
  - 3. Use it.



## Counting the invitation

- It simply gets the all the invitation data and count it because the realtime database is fast and cheap.
  - Before it keeps track of the number of invitation a field of a document when it was based on firestore.


- See the [ChatInvitationCounter] for details.


# Database Strucutre


## Chat room

- `/chat/rooms/<room-id>`: This is the path of chat room data.

- `users`: Required. This is a Map of users who joined the room. The key of this map is the uid of the user. The value is boolean. If it's true, the user subscribed the chat room. If it's false, the user has unsubscribed the chat room.

- `single`: Required.
- `group`: Required.
- `open`: Required.


## Chat message


- `/chat/messages/<room-id>`: This is the message list of each chat room.


## Chat join

- `/chat/joins/<uid>/<room-id> { ... }`: This is the relation ship bewteen who joined which room.
  - To list 1:1 chat rooms, it can query like `FirebaseDatabase.instance.ref('chat/joins/' + myUid).orderByChild('singleOrder');`
- `singleOrder`: Ordering single chat. It only exists if it is single chat.
- `groupOrder`: Ordering group chat. It only exists if it's group chat.
- `openOrder`: Ordering open chat. It only exists if it's a open gruop chat. It will also have `groupOrder`.


- `name`, `iconUrl` fields are copied from the chat room, and
  - `displayName`, `photoUrl` fields are copied from the user data.
  - Note, that copying chat room data and user data looks like that;
    - It copies the data over again, so it takes more database space.
      - But we consider this is a minor duplication.
    - The copied data does not sync when the master updated the chat room and the user change his name and photo.
      - The copied data will be synced on the next chat message sending.


- `displayName`, `photoUrl` is set when the chat is 1:1 chat.
  - For the login user, the value of `displayName`, `photoUrl` will be the other user's data.
  - For the other user, the vlaue of `displayName`, `photoUrl` will be the login user's data.




## Chat setting


- Each user can have indivisual settings.
  - The chat room settings are saved in `/chat/rooms/<room-id>`.

- `chat/settings/<uid>/<room-id>/{ ... }`: Each user's invisual settings for each chat room. For instance, the user can set his own room name, or make the chat room displayed on top with priority settings, etc.
  - For the convinience of data modeling, we don't make it too much flat. We put many properties in place for the convinience of managing.


### Saving unread number of messages.

- `chat/settings/<uid>/unread-message-count { roomA: 3, roomB: 4, ... }`: We make it flat because this value will be often be read and updated.





### Changing the chat room name

- `chat/settings/<uid>/name 


### Saving push notifications

- Push notification settings for on/off is saved with chat room settings; See chat room settings.





## Invited, Rejected Users


- The lists of invitation and rejection are set to flat due to the data management.

- `/chat/invited-users/<uid> { room-a: _time_base_order_value_, room-b: ..., ... }`: Users who were invited will be added here.
- `/chat/rejected-users/<uid> { room-a: _time_base_order_value_, room-b: ..., ... }`: Users who rejected the invitation be added here.



## Server timestamp

- `/chat/-info/timestap`: This is used by the `getServerTimestamp()` function. See the comment of the function for more details.



# Widgets


## Displaying chat room information

- To display the chat room information, use `ChatRoomDoc` like below.
  - It rebuilds the widget when data changes in realtime.

```dart
ChatRoomDoc(
  ref: ChatService.instance.roomRef(joinDoc.key!),
  builder: (room) {
    return ChatRoomListTile(
      room: room,
    );
  },
)
```

- If you dig into the ChatRoomDoc, it uses `Value` of the `easy_realtime_database`. It is a simple wraper of the `Value` to help you to write a shorter code.



## ChatInvitationCounter


## ChatInvitationListView

```dart
ChatInvitationListView(),
```



# Coding Guideline


## How to get server timestamp

```dart
int ts = await getServerTimestamp();
print('ts: ${DateTime.fromMillisecondsSinceEpoch(ts).toIso8601String()}');
```

# Known Issues






