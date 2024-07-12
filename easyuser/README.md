# 사용자

회원 관리 패키지



## 초기화


`UserService.instnace.init()` 을 통해서 사용자 기능을 초기화 합니다. 초기화를 하지 않아도 부분적으로 동작합니다. 하지만 로그인 사용자의 회원 정보 관리, Firestore 의 DB 구조 설정 등은 초기화 과정을 통해서 알려주어야 합니다.

`UserService.instance.init()` 함수는 한번만 초기화를 하도록 되어져 있습니다. 그래서 앱에서 초기화를 하는 경우, 종속된 패키지가 `easyuser` 패키지를 사용한다고 해도 두 번 초기화를 하지 않고, 앱의 초기화 된 설정을 이어서 계속 진행합니다.


여러분이 사용하는 앱에서 `easyuser` 패키지를 추가하여 사용하는데, 그 앱에서 추가한 다른 패키지들 중 하나가 `easyuser` 패키지를 사용할 수도 있습니다. 그냥 같이 사용을 하면 됩니다. 일반적으로 어떤 패키지가 `easyuser` 패키지를 사용 할 경우, 앱에서 사용하면 (초기화를 하면) 패키지에서는 초기화를 하지 않습니다.



## 사용법



### 사용자 연결



여러분의 앱에서 사용하는 사용자 데이터베이스 구조가, `easyuser` 의 기본 구조와 다르다면, 초기화를 통해서 맞추어 주면 됩니다.


예를 들어, 여러분의 앱에서 `easychat` 또는 `easy_friend` 패키지를 쓰는데, 여러분의 앱에서 사용하는 사용자 Firestore 데이터베이스 컬렉션이 `/users` 이 아니면, `easyuser` 패키지를 써서 맞추어 주면 됩니다.







## 사용자 정보

- Firestore 의 `/users/{uid}` 와 같이 저장됩니다. 컬렉션에 저장되는 문서의 키는 사용자 UID 입니다. 이 문서에는 공개 정보만 저장되어야 합니다. 이메일, 전화번호, 주소, 각종 신용카드, 면허증 번호 등의 연락 가능한 개인 정보, 민감한 정보를 저장해서는 안됩니다.
- 개인 정보는 `/users/{uid}/user-meta/private` 에 저장됩니다. 연락처 정보, 민감한 정보 등을 이 문서에 보관하면 됩니다.
- 개인 설정은 `/users/{uid}/user-meta/settings` 에 저장됩니다.

### 컬렉션 변경

`/users` 컬렉션이 아니라, 다른 컬렉션을 쓴다면 `UserService.instance.init()` 를 통해서 변경을 해 주시면 됩니다.

### 필드

사용자 문서에서 사용되는 필드는 아래와 같습니다. 만약 여러분들의 앱이 아래의 필드가 아닌 다른 필드를 사용한다면, 복사를 아래의 필드에 맞춰서 저장 할 수 있도록 해 주셔야합니다.

- `admin` 이 필드에 `true` 값이 저장되면 관리자가 됩니다. 파이어베이스 콘솔을 직접 열어서 원하는 사용자 문서의 admin 필드에 true 값을 주면 됩니다.

- `displayName` 사용자의 닉네임입니다. 이 값이 화면에 나타납니다.

- `name` 사용자의 전체(full name) 이름입니다.

- `gender` 사용자의 성별입니다. `M` 은 남자, `F` 는 여자입니다.


  String? gender;

  /// 처음 회원 가입을 하고, 최초 데이터를 업데이트(저장)하는 동안에는 createdAt 이 null 이 될 수 있다.
  DateTime? createdAt;
  DateTime? updatedAt;
  int? birthYear;
  int? birthMonth;
  int? birthDay;
  DateTime? lastLoginAt;
  String? photoUrl;


### 관리자 정보

- 관리자는 사용자 문서에 

## 채팅

채팅 방의 경우, 모든 기능을 Firestore 를 통해서 개발하면 비용 문제가 발생 할 수 있습니다.

- 채팅 방 정보는 Firestore 의 `/chat-rooms` 에 저장됩니다. 이 곳에는 채팅방의 기본 정보만 들어갑니다.
- 채팅 메시지는 Realtime Database 의 `/chat-messages` 에 저장됩니다. 채팅 메시지를 Realtime Database 에 보관하는 이유는 빠른 속도와 비용 절감 때문입니다.
- 채팅 방 마다 읽지 않은 채팅 메시지의 갯수를 표시할 때에는 `/chat-meta` 에 저장됩니다.








## 사용된 패키지 목록

```yaml
  cached_network_image: ^3.3.1
  cloud_firestore: ^5.0.2
  date_picker_v2: ^0.0.4
  easy_helpers: ^0.0.3
  easy_storage: ^0.0.2
  firebase_auth: ^5.1.1
  firebase_ui_firestore: ^1.6.4
  memory_cache: ^1.2.0
  rxdart: ^0.27.7
```




## 위젯


### 로그인 확인

아래와 같이 `AuthStateChanges` 를 통해서 사용자 로그인 상태 변경을 확인 할 수 있다.

이 위젯은 Firebase Auth 에 로그인을 했는지 안했는지에 따라 다르게 UI 를 표현 할 수 있으며, 초기화를 하지 않아도 동작합니다.

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