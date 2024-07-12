# Easy User



The `easyuser` package lets you manage user accounts and their information securely and with ease.



## Intialization


You can initialize the user functionality with `UserService.instance.init()`. This package actually works partially even without the initialization. However, to manage logged-in user information, you need to go through the initialization process.

The `UserService.instance.init()` function is designed to be initialized only once. Therefore, if an app initializes it, even if a dependent package uses the `easyuser` package, it won't initialize it a second time. Instead, it continues with the app's initialized settings.



## How to use



## Database structure for user

User database structure customization is no longer supported by v0.0.8. This is because `easyuser` has a security rules to apply `admin` field and other reules. And it often leads more complication when the database structure customization applied.

If you have a different database structure for user data management, you will need to customize it by userself. It is recommended to simply store the copy version the user data into `/users` collection when the user updates his information.




### User collection

- Firestore 의 `/users/{uid}` 와 같이 저장됩니다. 컬렉션에 저장되는 문서의 키는 사용자 UID 입니다. 이 문서에는 공개 정보만 저장되어야 합니다. 이메일, 전화번호, 주소, 각종 신용카드, 면허증 번호 등의 연락 가능한 개인 정보, 민감한 정보를 저장해서는 안됩니다.
- 개인 정보는 `/users/{uid}/user-meta/private` 에 저장됩니다. 연락처 정보, 민감한 정보 등을 이 문서에 보관하면 됩니다.
- 개인 설정은 `/users/{uid}/user-meta/settings` 에 저장됩니다.

- `/users/{uid}` - The user data is stored in Firestore as `/users/{uid}`.
- The key for the user document is the user's `uid`.
- The user document should only contain public information. User's proviate information should not be store in this document.
  - Private informations are like card number, license number, email, phone number, address and otehr sensitive information.
- The user's private information is stored in `/users/{uid}/user-meta/private`.
- The user's settings are stored in `/users/{uid}/user-meta/settings`.

### User document fields

The fields used in the user document are as follows. If your app uses fields other than those listed below, you should ensure they are saved(copied) according to these fields.

- `admin` If this field is set to `true`, the user becomes an administrator. You can open the Firebase console directly and set the admin field of the desired user document to true.

- `displayName` This is the user's nickname. This value appears on the screen.

- `name` This is the user's full name.

- `gender` This is the user's gender. `M` is for male, `F` is for female.

- `createdAt`

- `updatedAt`
- `birthYear`
- `birthMonth`
- `birthDay`
- `lastLoginAt`
- `photoUrl`



- `state`
- `stateMessage`








## Widget


### User sign-in or sign-out


You display UI based on the user's login status with `AuthStateChanges` as shown below.


```dart
AuthStateChanges(
  builder: (user) {
    return user == null
        ? const EmailPasswordLogin()
        : Column(
            children: [
              Text('User UID: ${user.uid}'),
            ],
          );
  },
),
```



## Trouble shooting

- `user-document-not-loaded` this happens when the `UserService.instance.user` is accessed when it is null. If the user is logged in and this exception happens, then you should check if you are using it too early.
