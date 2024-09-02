import 'package:easy_connectivity/easy_connectivity.dart';
import 'package:flutter/material.dart';

/// 인터넷 연결 상태 위젯
///
/// ConnectivityService 를 더 쉽게 사용 할 수 있도록 해 준다. 인터넷이 접속 될 때 마다 builder 를 실행하고,
/// 인터넷이 접속되지 않았을 때, notConnectedBuilder 를 실행한다.
///
/// 사용법:
/// ConnectionReady(
///   builder: () {
///     return Text('Connected');
///   },
///   notConnectedBuilder: () {
///     return Text('Not Connected');
///   },
/// )
class ConnectionReady extends StatelessWidget {
  const ConnectionReady(
      {super.key, required this.builder, this.notConnectedBuilder});

  final Widget Function() builder;
  final Widget Function()? notConnectedBuilder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ConnectivityService.instance.isOnline,
      builder: (_, value, __) {
        if (value) {
          return builder();
        }

        return notConnectedBuilder?.call() ?? const SizedBox.shrink();
      },
    );
  }
}
