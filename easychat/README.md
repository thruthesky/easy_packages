# EasyChat


This `easychat` package offers everything you need to build a chat app. With this package, you can easily add a full-featured, attractive chat function to your existing app.


## TODO

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



## Why Realtime Database


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



## Dependencies

- To invite other users, it needs the search users by name. To achevie this, it uses `easyuser` package.


## Database Strucutre


### Chat room

- `/chat/rooms/<room-id>`: This is the path of chat room data.

- `users`: This is a Map of users who joined the room. The key of this map is the uid of the user. The value is boolean. If it's true, the user subscribed the chat room. If it's false, the user has unsubscribed the chat room.

### Chat message


- `/chat/messages/<room-id>`: This is the message list of each chat room.


### Chat join

- `/chat/joins/<uid>/<room-id> { ... }`: This is the relation ship bewteen who joined which room.
  - To list 1:1 chat rooms, it can query like `FirebaseDatabase.instance.ref('chat/joins/' + myUid).orderByChild('singleChatOrder');`
- `singleChatOrder`: Ordering single chat. It only exists if it is single chat.
- `groupChatOrder`: Ordering group chat. It only exists if it's group chat.
- `openChatOrder`: Ordering open chat. It only exists if it's a open gruop chat. It will also have `groupChatOrder`.


### Chat setting


- Each user can have indivisual settings.
  - The chat room settings are saved in `/chat/rooms/<room-id>`.

- `chat/settings/<uid>/<room-id>/{ ... }`: Each user's invisual settings for each chat room. For instance, the user can set his own room name, or make the chat room displayed on top with priority settings, etc.
  - For the convinience of data modeling, we don't make it too much flat. We put many properties in place for the convinience of managing.


#### Saving unread number of messages.

- `chat/settings/<uid>/unread-message-count { roomA: 3, roomB: 4, ... }`: We make it flat because this value will be often be read and updated.







#### Changing the chat room name

- `chat/settings/<uid>/name 


#### Saving push notifications

- Push notification settings for on/off is saved with chat room settings; See chat room settings.





### Invited, Rejected Users


- The lists of invitation and rejection are set to flat due to the data management.

- `/chat/invited-users/<uid> { room-a: _time_base_order_value_, room-b: ..., ... }`: Users who were invited will be added here.
- `/chat/rejected-users/<uid> { room-a: _time_base_order_value_, room-b: ..., ... }`: Users who rejected the invitation be added here.











