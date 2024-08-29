# Easy user group

This package helps to grouping users using Firestore.


## Overview

- The user must sign-in first before using any of the user group functionality. Or it may throw exception.

## Installation

- Add the `easy_user_group` package as the dependency of your app.





## Database structure

- It uses Firestore.

- `/user-group`: the user group collection
- `/user-group/<group-id>`: the document that has the group information.


### Fields

- `uid`: the user uid of the owner.
  
- `createdAt`: the date time of creation

- `updatedAt`: ..

- `users`: users who accepted.
- `pendingUsers`: who didn't decided for accept or rejection.
- `declinedUsers`: who rejected the invitation.


## Developer's guideline

- It uses `easyuser` for searching users.



## How to use


### invite user


- Invite a user

```dart
final user = await UserService.instance.showSearchDialog();
await UserGroup.invite(otherUid: user.uid);
```


- Remove a user from the user list

```dart
await UserGroup.remove(otherUid: 'uid');
```


### re-invite

- Use case:
  - If the user declined, the moderator can invite again.

- Re-invite a user
  - This remove the user from declined list and add to pending list.

```dart
await UserGroup.inviteAgain(otherUid: 'uid');
```

### display the details

- To display the details
  - The details screen display not only the user list of accepted, pending, declined.

```dart
UserGroupService.instance.showDetailScreen();
```


- This has a tab of accept, pending, decliend list.
  - with appropriate menus;









