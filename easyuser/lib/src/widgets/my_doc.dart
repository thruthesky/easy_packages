import 'package:easyuser/easyuser.dart';
import 'package:flutter/material.dart';

/// 나의 문서가 변하면 위젯을 re-build 한다.
///
/// 주의, 이 위젯은 로그인한 사용자의 문서 `/users/<uid>` 를 listen 하지 않는다.
/// 정확히는 [UserService.instance.changes] 를 listen 한다.
///
/// 즉, DB 업데이트가 있으면 listener 에 의해서 [UserService.instance.user] 가 업데이트 되고,
/// [UserService.instance.changes] 이벤트가 발생한다.
///
/// 사용자 로그인을 하지 않았거나, 로그인 중이거나, 사용자 문서가 존재하지 않으면, builder 파라메타로
/// 전달되는 House User 는 null 이 될 수 있다.
///
/// 사용자가 로그 아웃이나 계정을 변경하는 경우, [UserService.instance.user] 가 변하고,
/// [UserService.instance.changes] 이벤트가 발생하여 잘 동작한다.
///
/// [initialData] 에 [UserService.instance.changes] 를 사용하여, 깜빡거림이 없도록 한다.
///
class MyDoc extends StatelessWidget {
  const MyDoc({super.key, required this.builder});
  final Widget Function(User?) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: UserService.instance.user,
      stream: UserService.instance.changes,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return const SizedBox.shrink();
        }
        if (snapshot.hasError) return Text(snapshot.error.toString());

        return builder(snapshot.data);
      },
    );
  }
}
