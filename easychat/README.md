# EasyChat

EasyChat 은 채팅 앱을 개발하기 위해 필요한 모든 기능을 제공합니다. EasyChat 패키지를 통해서 여러분들이 이미 만들어 놓은 앱에 완전하고, 아름답고, 쉬운 채팅 기능을 추가 할 수 있습니다.

참고로, EasyChat 은

- 관리의 효율을 위해서 채팅 방은 Firestore 를 사용하고,
- 비용 절감을 위해서 채팅 메시지, 새로운 채팅 메시지 수 관리 등은 Realtime Database 를 사용합니다.
- 또한 여러분들이 이미 만들어 놓은 앱에서 회원 정보를 가져오기 위한 설절을 할 수 있습니다.
- 푸시 알림 구독 및 전송,
- 파일 전송 및 URL Preview 등
- 채팅 기능에 필요한 모든 것을 제공하며
- 아름다운 UI/UX 를 기본적으로 제공하며,
- 대용량 채팅 앱으로 활용 할 수 있도록 최적화 되어져 있습니다.



## 설치

아래와 같이 pubspec.yaml 에 easychat 을 추가하시면 됩니다.

```sh
% flutter pub add easychat
```

## 초기화

```dart
ChatService.instance.init();
```


## 사용자 정보 연결

여러분들이 이미 개발한 앱에 본 패키지를 사용하는 경우, 회원 정보를 어디서 가져 올 것이지 정해주어야 합니다. 기본적으로 `users` 컬렉션을 사용하며, `displayName` 과 `photoUrl` 필드를 사용합니다. 만약 여러분의 앱이 `users` 컬렉션이 아닌 `members` 컬렉션에 사용자 정보를 저장한다면, `easyuser` 패키지를 설치하여 아래와 같이 하시면 됩니다.

```dart
UserService.instance.init(
    collectionName: 'members',
);
ChatService.instance.init();
```

