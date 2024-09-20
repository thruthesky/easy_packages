# Easy User


- User management package based on Firebase Realtime Database.



# Database Structure


- `users`: is the root node of the database.
  - `users/<uid>`: is the user node.
    - `users/<uid>/name`: is the name of the user.
    - `users/<uid>/photoUrl`: is the photo url of the user.
    - `users/<uid>/role`: is the role of the user.
    - `users/<uid>/status`: is the status of the user.
    - `users/<uid>/createdAt`: is the created date of the user.
    - `users/<uid>/updatedAt`: is the updated date of the user.
    - `users/<uid>/deletedAt`: is the deleted date of the user.
    - `users/<uid>/deleted`: is the deleted status of the user.
    - `users/<uid>/password`: is the password of the user.
    - `users/<uid>/phone`: is the phone of the user.
    - `users/<uid>/address`: is the address of the user.
    - `users/<uid>/gender`: is the

- `users-private`: is the root node of the database.
  - `users-private/<uid>`: is the user node.
    - `users-private/<uid>/email`: is the email of the user.
    - `users-private/<uid>/phoneNumber`: is the phone number of the user.




# Widgets


## User

- Displays the user information in realtiem.

- `field`: Required. It is to get the minium data of the user field.

- `uid`: is the user id to display.

- `onLoading`: is the loading state of the widget.

- `onError`: is the error state of the widget.




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