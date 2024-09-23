- [Overview](#overview)
- [Install](#install)
  - [Security Rules](#security-rules)
    - [Firestore Security Rules](#firestore-security-rules)
    - [Realtime Database Security Rules](#realtime-database-security-rules)
  - [Index](#index)
    - [Firestore index](#firestore-index)
- [Example](#example)
- [Initialization](#initialization)
- [Logic](#logic)
- [User database](#user-database)
- [Chat Database](#chat-database)
  - [Chat room database struture](#chat-room-database-struture)
  - [Chat message database structure](#chat-message-database-structure)
  - [Chat room security](#chat-room-security)
  - [Cost of Firestore](#cost-of-firestore)
  - [Chat message database struture (RTDB)](#chat-message-database-struture-rtdb)
- [Group Chat and 1:1 Chat](#group-chat-and-11-chat)
- [Masters](#masters)
- [Chat invitation](#chat-invitation)
  - [Database for chat invitation](#database-for-chat-invitation)
  - [Logic](#logic-1)
  - [ChatInvitationCount - Display no of invitations](#chatinvitationcount---display-no-of-invitations)
- [Password](#password)


## Overview

- User must login to use any of the chat functionalities.

## Install

Add `easychat` into your `pubspec.yaml`

```sh
% flutter pub add easychat
```


### Security Rules


- To install the chat, you need to install the security rules for firestore, realtime database, and storage. Plus, you need to install firestore indexes.

#### Firestore Security Rules

- Copy the security rules of the `chat-settings` and the `chat-rooms` from the [easy chat firestore security rules](https://raw.githubusercontent.com/thruthesky/easy_packages/main/easychat/firebase/firestore.rules).


#### Realtime Database Security Rules


```json
{
  "rules": {
    "mirror-users": {
      ".read": true,
      "$uid": {
        ".write": "$uid === auth.uid",
      },
      ".indexOn": ["createdAt"]
    },
    // push notification
    "fcm-tokens": {
      ".read": true,
      "$token": {
        ".write": "newData.val() === auth.uid",
      },
      ".indexOn": [".value"],
    },
    "fcm-subscriptions": {
      ".read": true,
      "$subscriptionId": {
        "$uid": {
          ".write": "$uid === auth.uid"
        }
      }
    },
    "chat-rooms": {
      "$roomId": {
        ".read": true,
        ".write": true
      }
    },
    "chat-messages": {
      "$roomId": {
        ".read": true,
        ".write": true
      }
    }
  }
}
```


### Index

#### Firestore index




## Example

- See `example/lib/main.dart`.



## Initialization

- You should initialize the `ChatService`. See more on [Developer Guideline](#development-guideline).

```dart
ChatService.instance.init();
```

## Logic

- User must sign in to use any of the chat features.
  - You must be sure that the user sign in first before using the chat screen. Or an error may appears on the screen.

## User database

`easychat` gets user data from `/mirror-users/<uid>/` node in realtime database. So, your app needs to save your display name and photo url in this node. If your app uses diferent database structure, then simply copy the user's data into `/mirror-users/<uid>/` node.

For your information, `easychat` uses `easyuser` package to manage the user's data. You don't have to install this package as the dependency of your app. It's not required but recommended to understand how `easyuser` package works.


## Chat Database

### Chat room database struture

- `/chat-rooms/{roomId}` is the document of chat room information. Chat room documents are saved in Firestore.

- the `room id` has a triple-hypen(`---`) if it's a 1:1 chat.

- `name` is the name of the chat room.

- `description` is the description of the chat room.

- `users` field is a Map that has user's uid as key. And the value of the user is another Map that has key/value for sorting/listing the chat rooms of each user. See the `chat.room.user.dart` for the details of fields.
  - All chat room users(members) exists in this Map whether it is a 1:1 chat or a group chat.

- `invitedUsers` field has the list of invited user's uid. They cannot enter the chat room, until they confirm it in the app.

- `rejectedUsers` field has the uid list of the rejected users from the invitation. Once the user rejected, his uid is moved from `invitedUsers` to `rejectedUsers`. In this way, the rejected users will not see the invitation in the chat list any more and the inviter cannot invite anymore.

- `blockedUsers` is the uid list of blocked users by masters.

- `masterUsers` is the uid list of master user. See [Masters](#masters)

- `createdAt` is the Firestore Timestamp when the chat room created.

- `updatedAt` is the Timestamp when the chat room information updated.

- `open` if it is set to true, the chat room is open chat. So, it is listed in the open chat rom list and anyone can join the chat room without invitation.

- `hasPassword` is set to true if the chat room has a password. See [Password](#password)

- `single` - is true when the room is single chat

- `group` - is true when the room is group chat

- `open` - is true when the room is open group chat.

- `gender` - If it is 'M', only males can joins the chat room. If it is 'F', only femails can join the chat room (NOT SUPPORTED, YET)

- `domain` - It is the domain of the chat room. It is for a grouping chat rooms. It can be the name of the app.
  - For instance, There are two different apps: A and B. And the two apps are using same Firebase project.
    - And the developer may want to display only the chat rooms that were created by app A in the app A.
  - The domain can be initlized by `init` and will be set to the chat room that are created by the app.
    - And it's upto you how you use it.



### Chat message database structure

- `/chat-messages/<room-id>` is the path of chat room messages. It is saved in Realtime Database.




### Chat room security

- Chat room information must not be public. Only members and invited users, and the rejected users read it.
  - Invite users are included to read the chat room information NOT because once is was invited, but because there is no easy way of displaying the list of chat rooms that the user has rejected.
  - To secure the chat room information from the rejected users, the chat room information should maintain as less information as possible. For this reason, the chat room does not store the last message.
  - So, to display the last chat message on chat room list, the package listens the last message of the chat room.


- Security rules for open chat;
  - The principle of the security for blocked users.
    - It allows `blocked users` to read the `open chat room`.
      - **Because**; any one can read the chat room information. If the blocked user simply logs-out and logs-in another user, and he is able to read the chat room information. Then, what's the use of blocking blocked users not to read the `open chat room` information.
    - For 1:1 chat rooms and grup chat rooms, they have invitation mechanism and the user needs to be invited to read the chat room.

- In Security rules, user may get doc of single group chat where the user uid is included in the `roomId`, whether it exist or not. The format of single chat is like `otherUid---roomId`, or the combination of uids of the single chat members separated by `---`. However, this is not allowed in listing.
  - The reason for this one is that, having permission-denied error upon accessing may cause problems when the single chat room doesn't exist. The logic is when single chat room doesn't exist, it should create. The permission-denied error may stop the process.


### Cost of Firestore

- Firestore is more expensive compared to Realtime Database.
  - In the previous version, we were able to build the complete chat functionality with Realtime Database, but you(developers) don't like it. That's why we converted it to Firestore. Well, it costs more.
  - We have plan to customize on costy parts of Firestore chat rooms, and share the chat room data management with Realtime Database.
  - For now, when theere is a chat message, chat room updates.
    - In chat room list screen and chat room screen, the chat room document are listened(subscribed) for realtime updates. And it will be a bit costy.
    - If you have millions of users and if it costs, let us know. We will hurry to customize it for low cost.

### Chat message database struture (RTDB)

For the speed and cost efficiencies, the chat messages are saved under `/chat-messages/{roomId}` in Realtime Database


- `id` is the id of the chat message. NOTE, that this id is not saved in the database. It is used in the client side only.

- `roomId` is the room id.

- `uid` is the chat message sender uid.

- `createdAt` is the date time of the chat message creation.

- `updateAt` is the date time of the chat message edition.


- `order` is the chat message list order.


- `text` is the text of the chat message.

- `url` is the url of photo or file of the chat message.

- `deleted` is true when the message is deleted. if the message is deleted, then text, url, url preview values will be deleted.

- When sending a chat message, if the text contains a URL, the site information is displayed for previewing. The appropriate values are stored in the following fields below the message:
  - `previewUrl` - URL
  - `previewTitle` - Title
  - `previewDescription` - Description
  - `previewImageUrl` - Image


- `replyTo` is the chat message that the current message is replied to.





## Group Chat and 1:1 Chat

- `1:1 chat` is also called `single chat`.
- For single chat, `single` field goes true. For gropu chat, `group` field goes true.
- The logic between `single` and `group` chat are very much the same.



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


### Database for chat invitation

- It uses `easy_setting_v2` package to save the `chatInvitationCount`.

- `/chat-settings/<uid>/chatInvitationCount`: this field has the number of chat inivitation. This field is open to anyone.
  - This value of user B is updated when
    - A invites B
    - B rejects
    - B accepts
  - The `chatInvitationCount` is updated inside the following methods of `ChatRoom` model.
    - `inviteUser`
    - `acceptInvitation`
    - `rejectInvitation`
  - The `chatInvitationCount` is reset with actual number of invitation every time when app starts. So, if something goes wrong, it will correct by itself.


### Logic


- Initialize the chat service and countig the no of invitation will automatically work.
  - During initialization, the app will reset the number of invitations to correct any errors caused by open security rules. This correction happens only once at the start of the app.


### ChatInvitationCount - Display no of invitations

- To display the count(number) of invitations, use `ChatInvitationCount` widget.
  - This widget will call the build method with the no of invitation.
  - It's up to you how you design.
  - Use `invitation count title` text code which has the plural i18n. You can copy this, update and overrite if you want.

Example:
```dart
ChatInvitationCount(
  builder: (count) => count == 0
      ? const SizedBox.shrink()
      : Column(
          children: [
            spaceSm,
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                leading: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.envelope,
                    ),
                    Positioned(
                      top: -5,
                      right: -6,
                      child: Badge(
                        label: Text(
                          '$count',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: context.error,
                      ),
                    ),
                  ],
                ),
                title: Text(
                  'invitation count title'.tr(
                    args: {'count': count},
                    form: count,
                  ),
                  style: TextStyle(
                    color: context.outline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: context.outline,
                ),
                onTap: () {
                  openMainScreen(1);
                },
              ),
            ),
          ],
        ),
)
```


## Password

NOTE: Password is not supported, yet.

The password must kept in secret by the Security rules. Then, how the user can join the chat room without the help of backend? Here is a solution.

- Since the password must be secured for reading, the password must not be saved in chat room document.
- So, it is saved under `/chat-room/{roomId}/chat-room-meta/private` document.
- And, client cannot read the password and when the user enters the password, how the client can check if the password is correct or not?

The solution is that,

- The user will save the password in `/users/{uid}/user-meta/private {chatRoomPassword: ...}`
- And user tries to join the room and in the security rule,
  - Security rules is the one to check if the password in user meta and in the chat private are the same.
    - If they are the same, then the user can enter the chat room.

This is the way how it can compare the chat password.



