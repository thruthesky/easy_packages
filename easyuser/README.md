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