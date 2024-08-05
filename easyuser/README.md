# Easy User

- The `easyuser` package allows you to manage user accounts and their information securely and easily.
- It uses Firestore to save user data and perform complex filtering and searches.
- It mirrors user data into the Realtime Database for listing user data and performing simple searches.
  - The Realtime Database is more cost-efficient and loads data faster.


# TODO

- write the unit test for firestore rules in `firebase` folder.
- write the security rules in `firebase/firestore/firestore.rules` and ask developers to copy this and install.
- write a script to mirror all the user data from firestore to rtdb in `firebase/mirror` folder.

# Installation


## Firebase Database Security Rules

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
  }
}
```



# Intialization


You can initialize the user functionality with `UserService.instance.init()`. This package actually works partially even without the initialization. However, to manage logged-in user information, you need to go through the initialization process.

The `UserService.instance.init()` function is designed to be initialized only once. Therefore, if an app initializes it, even if a dependent package uses the `easyuser` package, it won't initialize it a second time. Instead, it continues with the app's initialized settings.



# Logic



## Anonymous


- By default, it supports Anonymous sign-in. If you don't want this, you can set `enableAnonymousSignIn` to false during the initialization process.
  - Users who sign in anonymously are recognized as logged-in users, but the logout button is not displayed.
  - Also, Anonymous users are not considered as registered users. That is, they are considered users who have logged in but have not registered.
  - Therefore, you should show a registration menu or a sign-in button to Anonymous users.


Remember the nature of Firebase Auth and account merging especially when the user signed in as anonymous.

- When A opens the app,
  - Then, A signs in as `A-A` anonymous automatically,
  - Then, A signs in as `A` as his account and merge his account with `A-A`.
  - Then, A signs out, then A will automatically signs-in as another Anonymous like `A-N`. Not the same anonymous as `A-A`.
  - Then, when A sign in again as `A`, then he cannot merge with `A-N`.

This is the nature of Firebase Auth.






# How to use


## Usages

The easy package developers might consider adding the `easyuser` package to their package. However, it's best to only add `easyuser` if necessary. For example, include `easyuser` if you need to search for users, as it offers a user search dialog. But, if you just need to check if a user is signed in or get the user's UID, you don't need to use the `easyuser` package.



# Database structure for user

User database structure customization is no longer supported by v0.0.8. This is because `easyuser` has a security rules to apply `admin` field and other reules. And it often leads more complication when the database structure customization applied.

If you have a different database structure for user data management, you will need to customize it by userself. It is recommended to simply store the copy version the user data into `/users` collection when the user updates his information.




## User collection

- Firestore 의 `/users/{uid}` 와 같이 저장됩니다. 컬렉션에 저장되는 문서의 키는 사용자 UID 입니다. 이 문서에는 공개 정보만 저장되어야 합니다. 이메일, 전화번호, 주소, 각종 신용카드, 면허증 번호 등의 연락 가능한 개인 정보, 민감한 정보를 저장해서는 안됩니다.

- `/users/{uid}` - The user data is stored in Firestore as `/users/{uid}`.
- The key for the user document is the user's `uid`.



## User meta collection


- 개인 정보는 `/users/{uid}/user-meta/private` 에 저장됩니다. 연락처 정보, 민감한 정보 등을 이 문서에 보관하면 됩니다.
- 개인 설정은 `/users/{uid}/user-meta/settings` 에 저장됩니다.

- The user document should only contain public information. User's proviate information should not be store in this document.
  - Private informations are like card number, license number, email, phone number, address and otehr sensitive information.
- The user's private information is stored in `/users/{uid}/user-meta/private`.
- The user's settings are stored in `/users/{uid}/user-meta/settings`.



## 개인정보

예를 들면, 이름, 생년월일, 성별 등은 민감한 개인 정보로 개발자의 선택에 따라 비공개로 할 수 있다. 비공개로 하기 위해서는 Firestore 의 `/users` 컬렉션에 정보를 보관하면 안되고, `/users-private` 컬렉션에 따로 정보를 보관해야 한다. 참고로 email 과 phoneNumber 필드는 `하우스`가 내부적으로 처리를 비공개 처리를 해 주며, 그 외의 필드는 직접 `/user-private` 컬렉션에 저장해야하며, 이와 관련된 라이브러리가 제공된다.

어떤 필드를 비 공개로 할지 초기화 과정에서 지정을 해 주면 된다.

에제

```dart
my.private.email;
my.private.phoneNumber;
my.private.set('field', 'value');
```



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



- `stateMessage`: User can save his state message. This will be displayed with profile.
- `statePhotoUrl`: User can save a photo for his state. It is mostly used as a background of his profile.




### User blocking

- User model and user service supports user blockings.
- User blocking functionality is not seprated to another package because
  - a user can block only users. Not the other entities(or other data type). Meaning, user blocking is part of the user management feature. That's why it is not separated as another package.
  - It is often required functionality for app review. Without user blocking feature, the app may be rejected from the reviewer of the app publishing.
- `/users/{uid}/user-meta/blocks`: This document holds all the list of blocked users.
  - It is separated from the user document because
    - Blocking information is a private information and that must be protected
    - If it is in the user document (even if it's a privacy matter), the document may become big and cost more on network in seaching user's public data.

- When A blocks B, A should not see the contents from B.
  - A can still invite/like B.
  - This security can be softly done within the flutter code. There is no need to be hard limited from security rules.

- Below is an example of blocking user and unblocking user.

```dart
ElevatedButton(
  onPressed: () async {
    await i.block(context: context, otherUid: user.uid);
  },
  child: UserBlocked(
    otherUid: user.uid,
    builder: (b) => Text(b ? 'Un-block' : 'Block'),
  ),
),
```

- Use the code below to display the list of users who are blocked by the login user.
  - This screen also shows unblock button.

```dart
ElevatedButton(
  onPressed: () => i.showBlockListScreen(context),
  child: const Text(
    'Block list',
  ),
),
```


### Phone number collections

- `user-phone-sign-in-numbers`: is the collection that all the phone numbers of phone-sign-in auth are saved.
- The reason why it is needed is to know if the phone number is already signed in.
  - So, when the app links the current login with the login of phone sign-in,
    - If the phone number is not singed in yet, then it will link
    - If the phone number is already signed in, then it will sign-in with the phone number.
    - Since SMS OTP can be used only once, it needs to know if the phone number is alredy signed-in or not.
- It is protected by security rules that hackers cannot not get all the numbers.
  - They can only get one by one by gussing the phone nubmer and they will not get anthing except the phone number itself.




# linkWithCredential

- The SMS OTP of Phone Auth can be used only one time. So, it needs to know if the phone number is already sign ed in. Use `UserService.instance.isPhoneNumberRegistered()` to know if the phone number is already signed in.
- When `linkWithCredential` is used to link the current user login, `UserService.instance.initUserLogin` must be called once. Or the `MyDoc` will not update and phone number will not be registered immedately.


# Widget


## User sign-in or sign-out

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


## MyDoc


- To know if my document is ready, so i can use `my` or `UserService.instance.user`, do the following
```dart
MyDoc(
  builder: (my) => my == null
      ? const SizedBox.shrink()
      : Column(
          children: [
            Text('Reference: ${my.ref.path}'),
            const SizedBox(height: 24),
            CommentInputBox(
              documentReference: my.ref,
            ),
            CommentListView(documentReference: my.ref),
          ],
        ),
),
```
And to make it short, you can use `MyDocReady`.


## UserDoc

- You can display any user's data using `UserDoc`.
  - This is handy when you have the user's UID and prefer not to repeatedly access the database, saving time and reducing costs by caching the data in memory.

- This widget displays the user data from Realtime Database. If you want to display user data from Firestore, use `FirestoreUserDoc`.

- `uid` is the user's UID. It uses the `MemoryCache` package to cach the data in memory.

- There are three different usage for using `UserDoc`
  - If `sync` is passed as true, then it will rebuild the widget whenever the database changes. It first shows the data cached in memory as the `initialData` (this will help reducing flickering).  And then shows(re-builds) data from database. The default value is false.
  - If `cache` is true, it uses data cached in memory. If there is no cached data in memory, it reads data from the server. The default value is true, and once user data is read(loaded) from the database, it does not access the database again.
  - If the both of `sync` and `cache` are set to false, it will get the data from database always.

  If `sync` is passed as true, the `cache` option will be ignore.it first shows the data cached in memory as the `initialData` and then fetches and shows data from the server. So, it build the widget twice.

- It uses the `initialData` for reducing flickering.


Examples:

- If you need to show a user's avatar which requires the user (document) obect but you only have his UID, then use the `UserDoc` to fetch the user's document object. This is a practical way to get the user object when you their uid only.

```dart
UserDoc(
  uid: widget.post.uid,
  builder: (user) => UserAvatar(
    user: user!,
  ),
),
```

## FirestoreUserDoc

It works just the same as `UserDoc` but gets data from Firestore.






### Deleting user document

- When the user wants to resign, you can call `User.delete` method. It is recommended to delete the account from FirebaseAuth also. See the `easy_engine` for deleting user account from Firebase Auth.




## Finding user 

You can search users by thier name or display name with `UserService.instance.showUserSearchDialog` .


- if `exactSearch` is `true` it will search the exact text search provided in the user collection (ex: You search John Smith it will show result of user who name exactly Johm Smith). while if its `false` it will search base on the given and provide what might be your searching (ex: you search John and it will show result of user who have John in thier name John Smith, John Doe, John Carl, etc)


- if `searchName` is `true` is will search from the name field of the user.
- if `searchNickname` is `true` it will search from the display name field of the user.

- The name or display name are case insensitive. And it is supported by saving the name and display name in lower case in the Firestore.

- Note that, the search is `case-insensitive` and the by default it will search `exact match` of the user `name` field.


Using UserSearchDialog Widget

```dart
ElevatedButton(
  onPressed: () async {
    final user = await UserService.instance.showUserSearchDialog(
      context,
      exactSearch: false,
      searchNickname: true,
    );
    print('user; $user');
  },
  child: const Text('User Search Dialog'),
),
```


For custom design, you would design for the search item(user) and `pop` with the user object. Even though it's really up to you how you can customize. You can do something else instead of `pop`ing the user object.

```dart
ElevatedButton(
  onPressed: () async {
    final user = await UserService.instance.showUserSearchDialog(
      context,
      exactSearch: false,
      itemBuilder: (user, index) => ElevatedButton(
        onPressed: () => Navigator.of(context).pop(user),
        child: Text(user.displayName),
      ),
    );
    print('user; $user');
  },
  child: const Text('User Search Dialog'),
),
```


## Trouble shooting

- `user-document-not-loaded` this happens when the `UserService.instance.user` is accessed when it is null. If the user is logged in and this exception happens, then you should check if you are using it too early.



# Update document with following





# EasyUser Helpers

`iam` and `i` are global variables that serve as aliases for `UserService.instance` to make the code shorter. You don't have to use them if you don't need them, but they can be used appropriately.

The `my` variable is a global variable that serves as an alias for `UserService.instance.user` to make the code shorter.





# User data mirroring to Realtime Database

- Realtime database is faster and cheaper than Firestore.
- Whenever user updates his data, the data will be mirrored to `mirror-users` path in Realtime Database.
- You can use Firestore to filter(search) user data.
- You can use Realtime database if you don't need to filter.
- Use `User.update()` method whenever you update user's data. Or the user data may not be mirrored to realtime database.
  - If you really need to use other way to update user data in firestore, make sure you will call the `User.update()` again with approprivate parameters.
    - For instance, if you use `StorageService.instance.uploadAt` to update the user field in firestore, then you need to call `User.update` with the url again.
      - See: `user.update_avartar.dart` for an example.



# Widgets


## UserListView


It fetches the user list from Realtime Database.
It supports all the properties of ListView.
If you want to use Firestore, use `FirestoreUserListView`.

```dart
UserListView()
```

You can display users in horizontal like below.


```dart
SizedBox(
  height: 68,
  child: UserListView(
    scrollDirection: Axis.horizontal,
    itemBuilder: (u, i) => Padding(
      padding: EdgeInsets.fromLTRB(i == 0 ? 28 : 4, 4, 4, 4),
      child: UserAvatar(
        size: 60,
        radius: 24,
        uid: u.uid,
        cacheId: 'user-avatar',
      ),
    ),
  ),
),
```


## FirestoreUserListView

It fetches the user list from Firestore.




## MyDoc

It uses Firestore only. There is no option to use Realtime Database. This is because it is used only for the login user.



## UserDoc

It uses Realtime Database only.








`---------------  아래 부터 문서 작업을 할 것: 아래는 과거 버전의 문서이다. 작업해서 위로 올린다. ----------------`


# Geo query

- TODO: easy_geo_query 패키지를 만들어서 따로 관리 할 것. 아래 링크 방식으로 제작 할 것.

- Here is some tips to better understand about Geo search: [How to perform geoqueries on Firestore (somewhat) efficiently](https://medium.com/firebase-developers/how-to-perform-geoqueries-on-firestore-somewhat-efficiently-6c2f10fd285f)



- 먼저 앱이 실행되면 사용자의 위/경도 정보를 사용자 문서 필드  `latitude`, `longitude` 에 저장한다.
    - 그러면 Fireflutter 이 자동으로 geohash4,geohash5,geohash6,geohash7 를 저장한다.
    - 그리고, 필요에 따라 Firestore 미러링되게 한다.

- 검색을 할 때, 로그인한 사용자의 200 미터 내의 사용자 검색은 로그인을 한 사용자의 geohash7 과 DB 의 geohash7 이 일치하는 사용자를 가져와 보여주면 된다.
    - geohash6 는 1km 이내, geohash5 는 5km 이내, geohash4 는 20km 이내의 사용자를 검색 할 수 있다.







## 로그인

하우스에서 이메일/비밀번호를 통한 기본적인 회원 가입 및 회원 정보 수정 위젯을 제공한다. 하지만, 실제 앱 개발을 할 때에는 각 앱에 맞는 로그인을 사용하기를 바란다. 어떤 방식이든 Firebase Auth 를 통해서 로그인을 하면 된다. 그러면 각 기능들이 Firebase Auth 서비스를 통해서 로그인 정보를 액세스하고 연동하여 잘 동작을 한다.






## 관리자

관리자는 앱을 실행하여, 회원 가입하고, 최초 1회 `관리자되기` 버튼을 클릭하는 사용자가 `root` 관리자가 된다. 이 후 부터는 `root` 권한을 가진 관리자가 다른 사용자를 관리자로 임명하여 아래의 권한을 줄 수 있으며, 다른 관리자에게 `root` 권한을 줄 수 있다.

자세한 정보는 [관리자 문서](./admin.md)를 참고한다.



## 사용자 위젯

### 파이어베이스 로그인 AuthStateChanges

`AuthStateChanges` 위젯은 단순히, `Firebase.instance.authStateChanges` 내장하여 사용자의 Firestore 로그인 상태에 따라, UI 위젯을 빌드 할 수 있도록 해 놓은 것이다. 내부적으로 StreamBuilder 를 사용하므로, StreamBuilder 의 특성을 그대로 이용하면 된다.






### MyDoc

로그인한 사용자의 정보를 액세스 할 수 있다. 즉, 나의 이름이나 나이, 성별 등의 정보를 읽고 수정 할 수 있다.

주의 할 것은 로그인을 해도 builder 의 파라메타가 null 일 수 있다. 따라서 로그인을 했는지 하지 않았는지로 사용하지 않도록 한다.

다만, 나의 정보를 나타낼 때, 데이터가 로딩되었으면 위젯을 보여주고, 로딩되지 않았으면, 사용자 데이터를 로딩 중이라고는 표시 할 수 있다.



/// -- 여기서 부터


`UserService.instance.user` 는 DB 의 사용자 문서 값을 모델로 가지고 있는 변수이다. 짧게 `my` 로 쓸 수 있도록 해 놓았다. DB 의 값이 변경되면 실시간으로 이 변수의 값도 업데이트(sync)된다. 그래서 DB 에 값을 변경 한 다음, (약간 쉬었다) `my` 변수로 올바로 값이 저장되었는지 확인 할 수 있다. 예를 들면, form field 값 변경 즉시 저장하고, submit 버튼을 누르면 확인을 할 수 있다.

로그인한 사용자(나)의 정보를 참조하기 위해서는 `MyDoc` 를 사용하면 된다. 물론, `UserDoc` 를 사용해도 되지만, `MyDoc` 를 사용하는 것이 더 효과적이다. To reference the information of the logged-in user (yourself), you can use MyDoc. While using UserDoc is acceptable, using MyDoc is more effective.

Fireflutter 은 `UserService.instance.myDataChanges` 를 통해서 로그인 한 사용자의 데이터가 변경 될 때 마다, 자동으로 BehaviorSubject 인 `myDataChanges` 이벤트 시키는데 그 이벤트를 받아서 `MyDoc` 위젯이 동작한다. 그래서 추가적으로 DB 액세스를 하지 않아도 되는 것이다. Fireflutter uses UserService.instance.myDataChanges to automatically trigger the BehaviorSubject myDataChanges event whenever the data of the logged-in user changes. MyDoc widgets respond to this event, eliminating the need for additional DB access.

```dart
MyDoc(builder: (my) => Text("isAdmin: ${my?.isAdmin}"))
```

관리자이면 위젯을 표시하는 예. An example of displaying a widget if the user is an administrator:

```dart
MyDoc(builder: (my) => isAdmin ? Text('I am admin') : Text('I am not admin'))
```

If you are going to watch(listen) a value of a field, then you can use `MyDoc.field`.

```dart
MyDoc.field('${Field.blocks}/$uid', builder: (v) {
  return Text(v == null ? T.block.tr : T.unblock.tr);
})
```

### UserDoc



## 데이터베이스 구조

- 사용자 정보는 realtime database 의 `/users/<uid>` 에 기록된다.

`displayName` is the name of the user.
Firefluter (including all the widgets) will always use `dispalyName` to display the name of the user. This can be a real name, or it can be a nickname. If you want to keep user's name in different format like `firstName`, `middleName`, `lastName`, you can do it in your app. You may get user's real name and save it in `name` field in your app.

- `seearchDisplayName` 은 검색을 위한 용도로 사용한됩니다. 예를 들어 `displayName` 이, "JaeHo Song" 이면, "jaehosong" 으로 모두 소문자로 저장하며, 공백없이 저장을 합니다. 그래서 검색을 할 때, `Jaeho` 또는 `jaehoso` 등으로 검색을 보다 유연하게 할 수 있습니다.

`createdAt` has the time of the first login. This is the account creation time.

사용자의 본명 또는 화면에 나타나지 않는 이름은 `name` 필드에 저장한다.
화면에 표시되는 이름은 `displayName` 필드에 저장을 한다. The user's real name or a name not displayed on the screen is stored in the name field. The displayed name is saved in the `displayName` field.

`isVerified` 는 관리자만 수정 할 수 있는 필드이다. 비록 사용자 문서에 들어 있어도 사용자가 수정 할 수 없다. 관리자가 직접 수동으로 회원 신분증을 확인하고 영상 통화를 한 다음 `isVerified` 에 true 를 지정하면 된다. `isVerified` is a field that only administrators can modify. Even if it's included in the user document, users cannot modify it. Administrators manually confirm identity documents and conduct video calls. Afterward, they can set `isVerified` to true.

`gender` 는 `M` 또는 `F` 의 값을 가질 수 있으며, null (필드가 없는 상태) 상태가 될 수도 있다. 참고로, `isVerified` 가 true 일 때에만 성별 여부를 믿을 수 있다. 즉, `isVerified` 가 true 가 아니면, `gender` 정보도 가짜일 수 있다. `gender` can have values of `M` or `F` and may be in a null state (no field). Note that the gender information can only be trusted when `isVerified` is true. In other words, if `isVerified` is not true, gender information may also be false.

`blocks` 는 차단한 사용자의 목록을 가지고 있다. 차단은 사용자만 할 수 있다.
참고로, 좋아요는 사용자, 글, 코멘트, 채팅 등에 할 수 있고, 북마크는 사용자, 글, 코멘트 등에 할 수 있으나, 차단은 사용만 할 수 있다.
참고로, `likes` 는 쌍방으로 정보 확인이 가능해야한다. 이 말은 내가 누구를 좋아요 했는지 알아야 할 필요가 있고, 상대방도 내가 좋아요를 했는지 알아야 할 필요가 있다. 그래서 데이터 구조가 복잡해 `/user-likes` 에 따로 저장을 하지만, `blocks` 는 내가 누구를 차단했는지 다른 사람에게 알려 줄 필요가 없다. 그래서 `/users` 에 저장을 한다.

`latitude` 와 `longitude` 에 값이 저장되면 자동으로 `geohash4`, `geohash5`, `geohash6`, `geohash7` 에 GeoHash 문자열 4/5/6/7 자리 값이 저장된다. 즉, 위/경도의 값은 앱에서 Location 또는 GeoLocator 패키지를 써서, 퍼미션 설정을 하고, Lat/Lon 값을 구한 다음, `UserModel.update()` 로 저장하면, 자동으로 geohash 문자열이 저장되는 것이다. 보다 자세한 내용은 [거리 검색](#거리-검색)을 참고한다.

- User profile photo is saved under `/users/<uid>` and `/user-profile-photos/<uid>`.
    - The reason why it saves the photo url into `/user-profile-photos` is to list the users who has profile photo.
    Without `/user-profile-photos` node, It can list with `/users` data but it cannot sort by time.
    - `/user-profile-photos/<uid>` has `updatedAt` field that is updated whenever the user changes profile photo.
    - It is managed by `UserModel`.

- 참고 할 만한 사용자 생성 코드
  - `firebase/functions/tests/test.functions.ts` 의 `createTestUser()`
  - `user.model.dart` 의 `create()` 함수


## 사용자 기능 초기화

사용자 기능 초기화는 FireFlutter 가 제공하는 다른 Service 와 마찬가지로 앱 부팅을 할 때, 적절한 위치에서 `init` 함수를 실행하면 된다.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({
    super.key,
  });

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  @override
  void initState() {
    super.initState();
    UserService.instance.init(); /// 여기에서 초기화
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
```

대부분의 앱에서 사용자 기능을 사용 할 것이다. 만약, 사용자 기능이 초기화 되지 않았는데 사용자 기능을 사용하려고 한다면, 에러가 날 수 있다.

혹시라도 앱 내에서 사용자 기능을 사용하지 않아서, UserService 를 초기화 하지 않는다면, User 관련 모든 기능을 사용하지 말아야 한다. 이 때, UserService 가 초기화 되었는 확인을 해야하는데, `UserService.instance.initialized` 가 false 이면, 초기화를 하지 않은 것으로 모든 User 관련 기능을 비 활성화 하면된다.


## 사용자 UI 커스터마이징 (Customizing User UI)

### 로그인 에러 UI (Login Error UI)

로그인이 필요한 상황에서 로그인을 하지 않고 해당 페이지를 이용하려고 한다면, `DefaultLoginFirstScreen` 이 사용된다. 이것은 아래와 같이 커스터마이징을 할 수 있다. If someone tries to access a page that requires login without logging in, `DefaultLoginFirstScreen` is used. You can customize it as follows:

```dart
UserService.instance.init(
  customize: UserCustomize(
    loginFirstScreen: const Text('로그인을 먼저 해 주세요. (Please login first!)'),
  ...
  ),
)
```

`loginFirstScreen` 은 builder 가 아니다. 그래서 정적 widget 을 만들어주면 되는데, Scaffold 를 통째로 만들어 넣으면 된다. `loginFirstScreen` is not a builder. So, you can create a static widget, and if you put it in a Scaffold, it will work.







### 사용자 정보 수정 페이지 초기화 예제


`profileUpdateForm` 은  `UserService.instance.showProfileUpdateScreen()` 을 호출하면 dialog screen 이 나타나고 그 안에 표시될 회원 정보 양식을 지정 할 때 사용한다.
기본적으로 `DefaultProfileUpdateForm` 위젯을 사용하며, 아래와 같이 커스터마이징을 할 수 있다.


```dart
UserService.instance.init(
  customize: UserCustomize(
    profileUpdateForm: const DefaultProfileUpdateForm(
      stateMessage: (display: true, require: true),
      nationality: (display: true, require: true),
      countryFilter: ['KR', 'VN', 'TH', 'LA', 'MM'],
      region: (display: true, require: true),
      gender: (display: true, require: true),
      morePhotos: (display: true, require: true),
      occupation: (display: true, require: true),
      koreanAreaLanguageCode: 'ko',
    ),
);
```

그런데, 위와 같이 하면 회원 정보 수정 양식만 변경 할 수 있지, 해더나 백그라운드 등 화면 전체에 대한 변경을 할 수 없다. 그래서 아래와 같이 하면 모든 것을 직접 변경 할 수 있다.

```dart
UserService.instance.init(
  customize: UserCustomize(
    profileUpdateScreen: () => const ProfileUpdateScreen(),
  ),
);
```
위 코드는 사용자가 프로필 수정 버튼을 누르면 `ProfileUpdateScreen` 위젯을 화면에 보여주도록 하는 것이다. 이 `ProfileUpdateScreen` 위젯은 직접 만드는 것으로 원하는 모든 것을 작업하면 된다. 가능하면 `DefaultProfileUpdateScreen` 파일을 복사해서 수정할 것을 권한다. 그리고 모든 회원 정보 양식을 직접 만들어도 되지만, 가능하면 `DefaultProfileUpdateForm` 을 `ProfileUpdateScreen` 안에서 사용하고, 헤더 디자인 등 필요한 디자인만 추가할 것을 권한다.


참고로, 회원 정보 수정 페이지는 반드시 `UserService.instance.showProfileUpdateScreen(context: context);` 을 통해서 열어야 한다. 그렇지 않고 직접 route 연결을 통해서 열면, 앱 내의 여러 곳에서 회원 정보 수정 페이지를 여는 버튼을 두어야 하는 경우가 있는데 이 같은 경우, `profileUpdateForm` 이나 `profileUpdateScreen` 등에서 혼동이 생길 수 있다.





### User profile update screen

Fireflutter provides a few widgets to update user's profile information like below

#### DefaultProfileUpdateForm - 사용자 정보 수정 양식

회원 정보 수정을 할 때, `DefaultProfileUpdateForm` 을 통해서 쉽게 회원 정보를 수정 할 수 있다.

기본적으로 제공하는 옵션은 아래와 같다.

- `backgroundImage`
- `birthday`
- `occupation`
- `stateMessage`
- `gender`
- `nationality`
- `region`
- `morePhotos`
- `onUpdate`
- `countryFilter`
- `countrySearch`
- `koreanAreaLanguageCode`
- `countryPickerTheme`

- background
- state image (profile background image)
- profile photo
- name
- state message
- birthday picker
- gender
- nationality selector
- region selector(for Korean nation only)
- job

`DefaultProfileUpdateForm` also provides more optoins.

You you can call `UserService.instance.showProfileScreen(context)` mehtod which shows the `DefaultProfileUpdateForm` as dialog.

It is important to know that Fireflutter uses `UserService.instance.showProfileScreen()` to display the login user's profile update screen. So, if you want to customize everything by yourself, you need to copy the code and make it your own widget. then conect it to `UserService.instance.init(customize: UserCustomize(showProfile: ... ))`.

#### SimpleProfileUpdateForm

This is very simple profile update form widget and we don't recommend it for you to use it. But this is good to learn how to write the user update form.

```dart
Scaffold(
  appBar: AppBar(
    title: const Text('Profile'),
  ),
  body: Padding(
    padding: const EdgeInsets.all(md),
    child: Theme(
      data: bigButtonTheme(context),
      child: SimpleProfileUpdateForm(
        onUpdate: () => toast(
          context: context,
          message: context.ke('업데이트되었습니다.', 'Profile updated.'),
        ),
      ),
    ),
  ),
);
```

## 사용자 정보 참고

`UserDoc` 위젯을 사용 하면 된다. 자세한 것은, 위젯 문서를 참고한다.

## 나의 (로그인 사용자) 정보 액세스

`UserService.instance.user` 는 DB 의 사용자 문서 값을 모델로 가지고 있는 변수이다. 짧게 `my` 로 쓸 수 있도록 해 놓았다. DB 의 값이 변경되면 실시간으로 이 변수의 값도 업데이트(sync)된다. 그래서 DB 에 값을 변경 한 다음, (약간 쉬었다) `my` 변수로 올바로 값이 저장되었는지 확인 할 수 있다. 예를 들면, form field 값 변경 즉시 저장하고, submit 버튼을 누르면 확인을 할 수 있다.

로그인한 사용자(나)의 정보를 참조하기 위해서는 `MyDoc` 를 사용하면 된다. 물론, `UserDoc` 를 사용해도 되지만, `MyDoc` 를 사용하는 것이 더 효과적이다. To reference the information of the logged-in user (yourself), you can use MyDoc. While using UserDoc is acceptable, using MyDoc is more effective.

Fireflutter 은 `UserService.instance.myDataChanges` 를 통해서 로그인 한 사용자의 데이터가 변경 될 때 마다, 자동으로 BehaviorSubject 인 `myDataChanges` 이벤트 시키는데 그 이벤트를 받아서 `MyDoc` 위젯이 동작한다. 그래서 추가적으로 DB 액세스를 하지 않아도 되는 것이다. Fireflutter uses UserService.instance.myDataChanges to automatically trigger the BehaviorSubject myDataChanges event whenever the data of the logged-in user changes. MyDoc widgets respond to this event, eliminating the need for additional DB access.

```dart
MyDoc(builder: (my) => Text("isAdmin: ${my?.isAdmin}"))
```

관리자이면 위젯을 표시하는 예. An example of displaying a widget if the user is an administrator:

```dart
MyDoc(builder: (my) => isAdmin ? Text('I am admin') : Text('I am not admin'))
```

If you are going to watch(listen) a value of a field, then you can use `MyDoc.field`.

```dart
MyDoc.field('${Field.blocks}/$uid', builder: (v) {
  return Text(v == null ? T.block.tr : T.unblock.tr);
})
```


### MyDoc 의 initialData 옵션

`MyDoc` 은 StreamBuilder 를 통해서 `UserService.instance.changes` 이벤트를 수신해서, `UserService.instance.user` 가 가지고 있는 값을 빠르게 가져오지만, StreamBuilder 는 loader 를 필수적으로 화면에 표시를 한다. 즉, 화면이 깜빡이게 되는 것이다.

화면이 깜빡이는 이유는 loader 를 표시하기 때문이다.

`initialData` 를 통해서 이미 로드한 사용자의 정보(`UserService.instance.user`)를 전달하면, StreamBuilder 가 loader 를 화면에 나타내지 않고, `initialData` 를 사용한다. 즉, loader 를 화면에 표시하지 않으므로 화면이 깜빡이지 않는다.

특히, 많은 데이터를 리스트로 표현할 때 각 아이템에서 MyDoc 을 사용하면, 화면에 매우 깜빡 거리거나 리스트의 맨 밑으로 스크롤을 내렸을 때, 아래/위로 흔들리는 경우가 종종있다. 이 같은 경우 initialData 를 사용하면 매우 효과적이다.


```dart
MyDoc(initialData: UserService.instance.user, builder: (user) => ... ) // 와 같이 사용 할 수 있다.
MyDoc(initialData:my, builder: (user) => ... ) // 또는 짧게 my 를 쓸 수 있다.
```


### 관리자 위젯 표시 (Displaying Admin Widgets)

관리자 인지 확인하기 위해서는 아래와 같이 간단하게 하면 된다. To check if a user is an administrator, you can do it as follows:

```dart
Admin( builder: () => Text('I am an admin') );
```

## 사용자 정보 수정 (User Information Update)

`UserModel.update()` 를 통해서 사용자 정보를 수정 할 수 있다. 그러나 UserModel 의 객체는 DB 에 저장되기 전의 값을 가지고 있다. 그래서, DB 에 업데이트 된 값을 쓰기 위해서는 `UserModel.reload()` 를 쓰면 된다.

```dart
await user.update(displayName: 'Banana');
await user.reload();
print(user.displayName);
```

## Displaying user data

- You can use `UserDoc` or `MyDoc` to display user data.
- The most commonly used user properties are name and photos. Fireflutter provides `UserDisplayName` and `UserAvatar` for your convinience.

### UserDoc

The `UserDoc` can be used like this:

```dart
UserDoc(
  uid: uid,
  builder: (data) {
    if (data == null) return const SizedBox.shrink();
    final user = UserModel.fromJson(data, uid: uid);
    return Text( user.displayName ?? 'No name' );
  },
),
```

### MyDoc

The `MyDoc` can be used like this:

```dart
MyDoc(
  builder: (my) {
    return Text( user.displayName ?? 'No name');
  }
),

```

### UserDisplayName

The `UserDisplayName` widget can be used like this:

```dart
UserDisplayName(uid: uid),
```

This will show `displayName`, not `name` of the user.

### UserAvatar

The `UserAvatar` widget can be used like this:

```dart
UserAvatar(user: user, size: 100, radius: 40),
```


To display user avatar for login user, you may use the code below. The code below displays anonymous avatar if the user didn't signed in. And if the user signed in, it displays the user's photo url. If the user does not have photo url, it will display the first letter of the uid. And it also gives tap event to sign in or updating profile.

```dart
InkWell(
  child: MyDoc(
    builder: (user) => user == null
        ? const AnonymousAvatar()
        : UserAvatar(user: user),
  ),
  onTap: () => i.signedIn
      ? UserService.instance.showProfileUpdaeScreen(context)
      : context.push(SignInScreen.routeName),
),
```

#### UserAvatar.fromUid

If you have only the uid of a user, then you can use this widget to display user avatar

```dart
UserAvatar.fromUid(uid: user.uid),
```

- There is an options for `sync` that will update the avatar when the user update his profile photo. Use this when you want to update the user avatar in a chat room or any other screen that might need to display the user's photo in real time.

```dart
UserAvatar.fromUid(uid: myUid, sync: true),
```


## Block and unblock

You can block or unblock other user like below.

```dart
final re = await my?.block(chat.room.otherUserUid!);
```

You may want to let the user know if the other user has blocked or unblocked.

```dart
final re = await my?.block(chat.room.otherUserUid!);
toast(
  context: context,
  title: re == true ? 'Blocked' : 'Unblocked',
  message: re == true ? 'You have blocked this user' : 'You have unblocked this user',
);
```

## Widgets

### UserDisplayName 사용자 이름 표시

`UserDisplayName` 으로 사용자 이름을 표시 할 수 있습니다.

- `style` 는 TextStyle 로 UI 를 지정 할 수 있습니다.

- `maxLines` 는 최대 라인 수

- `overflow` 는 글자가 overflow 될 때, 처리할 방식


```dart
ConstrainedBox(
  constraints: const BoxConstraints(
    maxWidth: 100,
  ),
  child: UserDisplayName(
    uid: uid,
    cacheId: 'chatRoom',
    style: Theme.of(context).textTheme.labelSmall,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  ),
),
```

### UpdateBirthdayField

You can use this widget to display birthday and let user to update his birthday in profile screen.

### UserTile

Use this widget to display the user information in a list.
`onTap` is optional and if it is not specified, the widget does not capture the tap event.

```dart
FirebaseDatabaseListView(
  query: Ref.users,
  itemBuilder: (_, snapshot) => UserTile(
    user: UserModel.fromSnapshot(snapshot),
    trailing: const Column(
      children: [
        FaIcon(FontAwesomeIcons.solidCheck),
        spaceXxs,
        Text('인증완료'),
      ],
    ),
    onTap: (user) {
      user.update(isVerified: true);
    },
  ),
),
```

You can use `trailing` to add your own buttons intead of using `onTap`.

## 좋아요

- 사용자의 좋아요는 내가 좋아요 한 경우에는 `/who-i-like` 에 저장되고, 다른 사람의 나를 좋아요 한 경우에는 `/who-like-me` 에 저장된다.
    - 만약 A 가 B 를 좋아요 하면,
      - `/who-i-like/A {B: true}` 와 같이 저정되고,
      - `/who-like-me/B {A: true}` 와 같이 저장된다.


- 앱에서는 A 가 B 를 좋아요 할 경우, 오직 `/who-i-like/A {U: true}` 에만 값을 저장하면 된다. 나머지는 클라우드 함수가 처리를 한다.
  - 위와 같이 문서가 저장되면, 클라우드 함수 `userLike` 가 이벤트를 받아서 동작하며,
  - `/who-liked-me` 에 적절한 값을 저장하고
  - 서로 좋아요 (주의: 2024. 06. 현재 서로 좋아요는 플러터 UserModel 에서 수행하는데, 클라우드 함수로 옮겨야 한다.)
  - `noOfLikes`
  등의 필요한 여러가지 작업을 수행한다.


- 다음과 같은 예를 들 수 있다.


A 가 B 를 좋아요 하면,
```json
/who-i-like/A { U: true }
/who-liked-me/U { A: true }
/users/U {noOfLikes: 1}
```

- A 와 B 가 C 를 좋아 하면?
```json
/who-i-like/A {C: true}
/who-i-like/B {C: true}
/who-like-me/C { A: true, B: true}
/users/C {noOfLikes: 2}
```

- B 가 C 를 싫어요 하면? B 의 who-i-like 를 삭제하고, C 의 B 에 대한 who-like-me 를 삭제하고, C 의 noOfLikes 를 1 감소한다.
```json
/who-like-me/C { A: true }
/who-i-like/A { C: true }
/users/U {noOfLikes: 1}
```

- A 가 C 와 D 를 좋아요 하면?
```json
/who-i-like/A { C: true, D: true }
/who-like-me/C { A: true }
/who-like-me/C { A: true }
/users/C {noOfLikes: 1}
/users/D {noOfLikes: 1}
```

You can use the `like` method to perform a like and unlike user like bellow.

```dart
IconButton(
  onPressed: () async {
     await my?.like(uid);
  },
  icon: const FaIcon(FontAwesomeIcons.heart),
),
```

## 서로 좋아요

참고, 서로 좋아요 코드를 플러터 UserModel 에서 클라우드 함수로 이동 시켜야 한다.

- `UserModel.like()` 에서 A 가 B 를 좋아요 할 때, B 가 A 를 좋아요 한 상태이면 서로 좋아요를 표시하고,
- `UserModel.like()` 에서 A 가 B 를 좋아요 해제 할 때, 서로 좋아요 표리를 없앤다. 즉, 둘 중 좋아요 해제를 한 명이라도 하면 둘다 해제하면 되는 것이다.

## 사용자 로그인 후 정보 액세스

사용자가 Firebase 에 로그인을 한 다음, 특정 동작을 해야하는 경우, 아래와 같이 할 수 있다. 사용자 정보 확인이나 사용자 관련 로직을 수행 할 때에는 사용자의 UID 가 필요하다. 이 때, 아래와 같이 하면 firebase auth uid 를 바탕으로 작업을 할 수 있다. 다만, firebase auth 에만 로그인을 한 것으로 RTDB 의 사용자 문서는 로드되지 않았을 수 있다.

```dart
FirebaseAuth.instance
    .authStateChanges()
    .distinct((a, b) => a?.uid == b?.uid)
    .listen((user) {
  if (user != null) {
    ///
  }
});
```


## 사용자 정보 listening

`UserService.instance.myDataChanges` 는 `UserService.instance.init()` 이 호출 될 때, 최초로 한번 실행되고, `/users/<my-uid>` 의 값이 변경 될 때마다 이벤트를 발생시킨다.

BehaviourSubject 방식으로 동작하므로, 최초 값이 null 일 수 있으며, 그 이후 곧 바로 realtime database 에서 값이 한번 로드된다. 그리고 난 다음에는 data 값이 변경 될 때 마다 호출된다. 이러한 특성을 살려 로그인한 사용자 정보의 변화에 따라 적절한 코딩을 할 수 있다.

```dart
UserService.instance.myDataChanges.listen((user) {
  if (user == null) {
    print('User data is null. Not ready.');
  } else {
    print('User data is loaded. Ready. ${user.data}');
  }
});
```

만약, 사용자 데이터가 로딩될 때 (또는 데이터가 변하는 경우), 한번만 어떤 액션을 취하고 싶다면, 아래와 같이 하면 된다.

```dart
StreamSubscription? listenRequiredField;
listenRequiredField = UserService.instance.myDataChanges.listen((user) {
  if (user != null) {
    checkUserData(user); // 프로필이 올바르지 않으면 새창을 띄우거나 등의 작업
    listenRequiredField?.cancel(); // 그리고 listenning 을 해제 해 버린다.
  }
});
```

### 사용자가 사진 또는 이름을 입력하지 않았으면 강제로 입력하게하는 방법

아래와 같이, `UserService.instance.myDataChanges` 의 값을 살펴보고, 이름 또는 사진이 없으면 특정 페이지로 이동하게 하면 된다.

```dart
class _HomeScreenState extends State<MainScreen> {
  StreamSubscription? subscribeMyData;

  @override
  void initState() {
    super.initState();

    subscribeMyData = UserService.instance.myDataChanges.listen((my) {
      if (my == null) return;
      // 로그인을 한 다음, 이름이나 사진이 없으면, 강제로 입력 할 수 있는 스크린으로 이동해 버린다.
      if (my.displayName.trim().isEmpty || my.photoUrl.isEmpty) {
        context.go(InputRequiredFieldScreen.routeName);
        // 한번만 listen 하도록 한다.
        subscribeMyData?.cancel();
      }
    });
  }
}
```

## 회원 정보 수정 화면

회원 정보 수정 화면은 로그인 한 사용자가 본인의 정보를 보는 페이지다. `UserService.instance.showProfileScreen` 을 호출하면 회원 정보 수정 화면을 열 수 있다.

## 사용자 공개 프로필 화면

사용자 공개 프로필 화면은 본인 뿐만아니라 다른 사용자가 보는 페이지이다.

사용자 프로필 화면은 여러 곳에서 보여질 수 있다. 예를 들면, 사용자 목록, 게시판, 코멘트, 채팅 등등에서 사용자 이름이나 아이콘을 클릭하면 사용자 공개 프로필 화면이 열리는 것이다. 그래서, 개발하기 편하게 하기 위해서 `UserService.instance.showPublicProfileScreen` 을 호출하면, `DefaultPublicProfileScreen` 이 호출 되도록 했다. 커스텀 디자인을 하려면 `UserService.instance.init(custom: ...)` 에서 수정하면 된다. 사실 커스텀 디자인을 추천하며, 공개 프로필에 들어가는 각각의 작은 위젯들을 재 활용하면 된다.

예제 - 초기화를 통하여 공개 프로필 화면 커스텀 디자인 작업

```dart
UserService.instance.init(
  customize: UserCustomize(
    publicProfileScreen: (uid) => PublicProfileScreen(uid: uid),
  ),
);
```

위와 같이 하면, 사용자가 프로필 사진 등을 탭하면, 화면에 `PublicProfileScreen` 이 나타난다. 이 위젯의 디자인을 완전히 처음부터 새로 작성해도 되지만, `DefaultPublicProfileScreen` 을 복사해서 수정하는 것을 추천한다.

### 사용자 프로필 보기를 할 때, 상대 회원에게 푸시 알림 보내기

참고, [푸시알림 메시지 문서](./messaging.md#사용자-프로필이-보여질-때-푸시-알림-커스터마이징)를 본다.






## 좋아요

- [좋아요](./like.md) 문서 참고



## 사용자 차단 표시 및 차단하기

- 블럭된 사용자는 `BlockListView` 로 목록으로 표시 할 수 있다.
- 블럭된 경우 문자열로 표시하는 경우는 `orBlock()` String extension 을 사용하면 된다.
- 위젯으로 표시를 해야하는 경우는 `Blocked`로 하면 된다.

예제 - 코멘트 목록에서 사진을 표시할 때, 사용자가 차단되어져 있으면 사진을 표시하지 않는다.

```dart
Blocked(
  uid: widget.comment.uid,
  yes: () => SizedBox.fromSize(),
  no: () => DisplayDatabasePhotos(
    urls: widget.comment.urls,
    path:
        '${Path.comment(widget.post.id, widget.comment.id)}/${Field.urls}',
  ),
),
```

블럭 버튼을 표시하는 것은 위젯 문서를 참고한다.


- 다른 사용자를 차단 할 때에 `UserService.instance.block()` 함수를 쓰면 된다. 이 함수 내에
  - 로그인을 했는지 확인하고,
  - 차단 할지 물어보고 (ask 옵션)
  - 차단 했으면 화면에 알려주는 (notify 옵션)
  기능들이 모두 포함되어져 있다.




## 사용자 계정 정지

사용자 계정 정지 기능은 일반 사용자 끼리 차단하는 것과 다른 것으로, 관리자가 특정 사용자를 차단하는 것으로 차단된 사용자는 앱의 기능을 쓰지 못하도록 하는 것이다.

그래서 사용자 계정 정지 기능은 오직 관리자만 할 수 있으며, 관리자가 특정 사용자의 계정을 정지 시키면, `isDisabled` 필드에 true 가 저장되며, 이 후 글 쓰기 등을 할 수가 없다.

참고로 사용자 차단은 FireFlutter 가 기본적으로 제공하는 화면에서 할 수 있다.






## 회원 탈퇴

- 회원 탈퇴는 `UserService.instance.resign()` 함수를 호출하면 된다.
  - 이 `UserService.instance.resign()` 함수는 내부적으로 Firebase Cloud Functions 의 `callable function` 을 통해서 클라우드 함수 코드를 호출한다. 따라서 cloud functions 중에서 `userDeleteAccount` 를 설치해야 한다.
- 회원 탈퇴를 callable function 으로 만드는 이유는 Flutter Client SDK 에서 회원 계정 삭제 작업하면 `requires-recent-login` 에러가 발생한다.
  - 그리고 만약, 회원 탈퇴를 할 때, RTDB 나 Firestore 에서 회원 데이터를 삭제해야하는 경우, Firebase Auth 에서 계정 삭제를 먼저 한 다음,데이터를 삭제해야하는데, Firebase Auth 에서 계정 삭제를 하는 순간, 로그인 사용자의 uid 가 사라지고 회원 로그인 상태 정보가 사라져서 데이터를 삭제 할 수 없다. 그렇다고 데이터를 먼저 삭제해 버리면, `requires-recent-login` 에러가 발생해서 회원 탈퇴는 못하고 회원 데이터만 삭제를 해 버리는 꼴이 되어 문제가 복잡해 진다.
  - 그래서 `on call` 방식으로 하여, 본인 인증을 한 다음, 회원 탈퇴를 한다.
    - 참고로 `http request` 로 하면 본인 인증이 안되고, `backend trigger` 로 하면 클라이언트에서 결과 대기하는 것이 어렵다.


```dart
ElevatedButton(
  onPressed: () async {
    final re = await confirm(
      context: context,
      title: '회원 탈퇴',
      message: '회원 탈퇴를 하시겠습니까?',
    );
    if (re == true) {
      await UserService.instance.resign();
      await UserService.instance.signOut();
      if (context.mounted) {
        context.go(EntryScreen.routeName);
      }
    }
  },
  child: Text('회원 탈퇴'),
),
```

## 로그인에 따른 위젯 보여주기

로그인을 했는지 하지 않았는지에 따라 위젯을 다르게 보여주어야 할 때가 있다.


- `Login` 위젯은 사용자가 Firebase 에 로그인을 했으면, `yes` 콜백 함수가 호출되어 위젯을 표시할 수 있다. 만약 로그인을 하지 않았으면 `no` 콜백 함수가 실행된다. 참고로, `Login` 위젯은 Firebase Auth 만으로 동작하며, Firebase Realtime Database 의 사용자 문서가 로딩되거나 되지 않거나 상관없다. 주로, 파이어베이스에 로그인을 하여 사용자 uid 가 사용 가능한지 확인을 위해서 쓴다.

`LoggedIn` 과 `LoggedOut` 위젯은 단순히, `AuthReady` 를 재 사용하기 쉽게 해 놓은 것이다.

- `LoggedIn` 은 FirebaseAuth 에 로그인을 한 경우 보여진다.
- `LoggedOut` 은 Firebase Auth 에 로그인을 하지 않은 경우 보여진다.


- `MyDoc` 은 내가 로그인을 한 경우 이용 할 수 있다.
  - 이 때, 나의 문서를 Firebase Realtime Database 에서 다운로드 한 경우 builder 콜백 함수에 UserModel 이 전달된다.
  - 만약, 앱이 시작되지 마자 호출되어, 아직 나의 정보가 RTDB 에서 다운로드되지 않았다면 (또는 다운로드 중이라면) build 함수에 null 이 전달된다.


- `DocReady` 이 위젯은 내부적으로 `MyDoc` 을 사용하며, Firestore Auth 에 로그인하고, 나의 문서가 RTDB 에서 로드되면 builder 콜백 함수를 호출한다. 만약, 로그인을 하지 않았거나 문서를 아직 로드하지 않았다면(또는 문서가 존재하지 않거나, 로드 할 수 없는 상태 등) `loadingBuilder` 를 보여준다. 즉, 로그인을 하지 않은 경우나 문서가 없는 경우 등은 `loadingBuilder` 가 화면에 보이는 것이다. 참고로, `MyDoc` 을 사용하면, `builder( UserModel? )` 가 null 일 수 있으므로, null 체크를 해야 하는데, `DocReady` 는 `builder(UserModel)` 가 null 이 아니므로 조금 더 편리하게 사용 할 수 있다.





## 로그인을 하지 않은 경우,

로그인을 하지 않고도 앱을 쓸 수 있도록 한다면, 특정 기능에서 에러가 발생 할 수 있다. 예를 들면, 로그인을 하지 않고 채팅방에 입장, 글 쓰기 등을 하는 경우라 할 수 있다. 이 외에도 코멘트 쓰기, 좋아요 등 여러가지 기능이 있다.

이 처럼 로그인을 해야지만 쓸 수 있는 기능의 경우, 대부분 해당 서비스(예: UserService, ChatSerivce, ForumService 등)에서 팝업이나 생 창을 띄우기 전에 로그인을 했는지 검사를 한다. 로그인을 했으면 문제가 없겠지만, 로그인을 하지 않았다면, `UserService.instance.init(loginRequired: ...)` 콜백 함수를 실행한다. 만약, `UserService.instance.init(loginRequired: ...)` 함수가 정의되지 않았다면 `UserService.instnace.loginRequired!()` 와 같이 호출하는 과정에서, `null check operator used on null value` 와 같은 에러가 발생 할 수 있다. 따라서 로그인을 하지 않고, 앱의 사용 할 수 있게 한다면 반드시 `loginRequired` 설정을 해 주어야 한다.

`action` 은 채팅방 입장, 채팅방 메세지 전송, 글 쓰기, 코멘트 쓰기 등의 행동 분류를 나타내며, `data` 는 각 행동에 따른 각종 옵션이 전달된다.


예제 - 로그인을 하지 않고 채팅방에 입장하려 하는 경우,

```dart

```

참고로, 좋아요 또는 신고 등의 경우, 앱의 여러 곳에서 사용 될 수 있는데, 관련 로직이 모델 클래스에 있다. 그래서 로그인 여부를 판단하기 위해서, 서비스(servivce) 클래스에서 wrapping 을 하는 경우가 있다. 이렇게 하는 이유는 글이나 코멘트 등에서 좋아요를 하는 경우, 해당 글/코멘트 모델 객체가 존재 모델 클래스에서 좋아요 로직에서 로그인을 했는지 확인을 할 수 있. 하지만, 좋아요를 하는 경우, 나의 정보를 담고 있는 UserModel 객체가 필요한데, 로그인을 하지 않아서 해당 객체 자체가 존재하지 않기 때문이다. 그리서 서비스 클래스에서 wrapping 해서 로직 관리를 하는 것이다. 그래서 사용자 좋아요 하는 것과 글 좋아요 하는 것은 로직이 다르다.

만약, 로그인을 했다는 확신이 있다면, `my.toggleBlock` 과 같이 바로 호출해도 된다.

## UserModel 에 존재하지 않는 필드 값 읽기/쓰기 - extra


각 앱마다 사용자에게 필요한 다른 필드가 있을 수 있습니다. 사용자를 업데이트할 때 `extra` 를 사용하세요.


Use this to update any other fields that are not in the User model. For example, if you want to update the user's hair color, you  can do it like this:

User 모델에 없는 다른 필드를 저장하고 읽으려면 다음과 같이 extra 를 사용하면 된다. 예를 들어, 사용자의 머리 색깔을 업데이트하고 싶다면 다음과 같이 할 수 있다:

```dart
final user = User.fromSnapshot(snapshot);
user.update(extra: {"hairColor": "black"});
```

위와 같이 업데이트 한 사용자의 머리 색깔을 읽으려면 다음과 같이 할 수 있다:

```dart
final hairColor = user.data['hairColor'];
```