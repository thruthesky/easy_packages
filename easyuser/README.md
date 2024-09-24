# Easy User


- User management package based on Firebase Realtime Database.



# Database Structure

- `users`: is the root node of the database.
  - `users/<uid>`: is the user node.
    - `users/<uid>/name`: is the name of the user.
    - `users/<uid>/photoUrl`: is the photo url of the user.
    - `users/<uid>/role`: is the role of the user.
    - `users/<uid>/status`: is the status of the user.
    - `users/<uid>/createdAt`: is the creation date of the user.
    - `users/<uid>/updatedAt`: is the last update date of the user.
    - `users/<uid>/deletedAt`: is the deletion date of the user.
    - `users/<uid>/deleted`: is the delete status of the user.
    - `users/<uid>/password`: is the password of the user.
    - `users/<uid>/phone`: is the phone of the user.
    - `users/<uid>/address`: is the address of the user.
    - `users/<uid>/gender`: is the gender of the user. "M" or "F".
    - `users/<uid>/birthYear`: is the birth year of the user.
    - `users/<uid>/birthMonth`: is the birth month of the user.
    - `users/<uid>/birthDay`: is the birth day of the user.

- `users-private`: is the root node of the database.
  - `users-private/<uid>`: is the user node.
    - `users-private/<uid>/email`: is the email of the user.
    - `users-private/<uid>/phoneNumber`: is the phone number of the user.

- `user-meta`: is the other data that the user needs.
  -`user-meta/<uid>`: is the user's node.
    -`user-meta/<uid>/blocks`: is the list of blocked users
      -`user-meta/<uid>/blocks/<blockedUid>`: is a blocked user node.

- `user-phone-sign-in-numbers`: is the list for the phone numbers that users used to sign in.
  - `user-phone-sign-in-numbers/<phoneNumber>`: is a phone number that a user used to sign in.
    - `user-phone-sign-in-numbers/<phoneNumber>/lastSignedInAt`: is the milliseconds when the user used the phone number.



# Widgets


## UserField

This wdigets gets only one field of user data and displays.

- `field`: Required. It is to get the minium data of the user field.

- `uid`: is the user id to display.

- `onLoading`: is the loading state of the widget.

- `onError`: is the error state of the widget.

- `builder`: is the builder function to build the widget.

- `sync`: is the sync option. if it's true, it will rebuild the widget when the user data is updated.

- `initialData`: is the initial data that is used on very first time. The data may be cached. If the data is not cached, then it will be used as initial data.

- `cache`: is the cache option. If it's true, then it will use cached data only. If there is no cached data, then it will get data from the server.




## UserModel

This wdiget passes the User model object on the builder method. Meaning, this widget can display all the user data.

- `uid`: is the user id to display.
- `onLoading`: is the loading state of the widget.
- `builder`: is the builder function to build the widget.
- `sync`: is the sync option. if it's true, it will rebuild the widget when the user data is updated.

- `initialData`: is the initial data that is used on very first time. The data may be cached. If the data is not cached, then it will be used as initial data.

- `cache`: is the cache option. If it's true, then it will use cached data only. If there is no cached data, then it will get data from the server.


## UserAvtar

```dart
UserBuildAvatar(photoUrl: null, initials: null)
```




# Logics

## Account Linking

- `/registered-phone-number`: is the node to check if the phone number is registered.
  - Why?
    - To link the phone number to the existing user account.
    - User may sign-in with other sign-in methods like Anonymous, Email, Google, Apple, Facebook, or etc.
    - If the phone number is already registered (or signed-in before), it means, the phone number belongs to an account.
      - You cannot link the phone number to another account when it is already linked to an account.
    - Once the credential of phone number is used, it cannot be used again. (The credential may be reused on other methods.)
    - You may try to link the phone number credential and if it's successful, well, then it's linked.
      - But what if it fails? you cannot reuse the credential. It means, the user must get new credential by sen



```mermaid
flowchart TB
  node_1(["Anonymous User Login"])
  node_2{"Phone Sign-In with Anonymous Account Link?"}
  node_3["Provide if the phone number is registered already"]
  node_1 --> node_2
  node_2 --"Yes"--> node_3
```