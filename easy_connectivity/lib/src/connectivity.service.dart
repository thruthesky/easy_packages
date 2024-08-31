import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// 인터넷 연결 상태를 확인하는 서비스
///
/// 인터넷이 연결될 때 마다 ready() 함수를 실행하고, isOnline 가 true 되어, notify 를 한다.
/// 인터넷이 접속되지 않았거나 끊어졌을 때, isOnline 은 false 로 notify 를 한다.
///
/// 사용법:
/// ValueListenableBuilder(
///   valueListenable: ConnectivityService.instance.isOnline,
///     builder: (_, value, __) {
///       if (value) {
///         return DoSomething();
///       }
///       return DoSomethingElse();
///     },
/// )
///
class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance =>
      _instance ??= ConnectivityService._();
  ConnectivityService._();

  /// ValueNotifier 를 통해서 상태 관리를 할 수 있다.
  /// ValueListenableBuilder 를 사용하여 UI 를 업데이트 할 수 있고,
  /// ConnectivityService.instance.isOnline.addListener(() { setState(() {}); }); 를 사용하여
  /// 인터넷이 연결되었을 때, 원하는 작업을 할 수 있다.
  ValueNotifier<bool> isOnline = ValueNotifier<bool>(false);

  /// 인터넷 연결 확인
  ///
  /// 참고로 인터넷 연결 상태 확인 Subscription 이 앱이 실행동안 항상 실행되어야 한다면,
  /// 굳이 Unsubscribe 할 필요 없다. 하지만, 최초 1회만 실행하고자 한다면, Unsubscribe 를 해야 한다.
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;
  init({
    Function()? ready,
  }) async {
    ///
    connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> connectivityResult) {
      /// 인터넷 연결 상태
      log('---> connectivityResult: $connectivityResult');

      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        /// 모바일 데이터 인터넷 연결 됨. (3G, 4G, 5G 등 무선 인터넷)
      } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
        /// 와이파이 연결 됨.
        /// 참고, 안드로이드에서 모바일와 와이파이 둘 다 enable 된 경우, active network type 으로 wifi 만 인식된다.
      } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
        /// 이더넷 연결 됨. (랜선으로 랜카드 연결)
      } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
        /// VPN 연결 됨.
        /// iOS 나 macOS 에는 VPN 네트워크 인터페이스가 있다. 이것은 [other] 로 표시될 수 있으며, Simulator 에서도 동일하다.
      } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
        /// 블루투스로 인터넷 연결 됨.
      } else if (connectivityResult.contains(ConnectivityResult.other)) {
        /// 위의 인터네이 아닌 다른 인터넷으로 연결 됨.
      } else if (connectivityResult.contains(ConnectivityResult.none)) {
        /// 연결된 인터넷이 없다.
      }

      /// 인터넷에 연결되었는가?
      if (connectivityResult.contains(ConnectivityResult.none)) {
        /// 인터넷이 연결되지 않았으면 여기서 작업한다.
        log('---> ConnectionService::init(): It is NOT connected to the internet.');

        /// 오프라인 상태라고 알림.
        isOnline.value = false;
      } else {
        /// 인터넷이 연결되었으면 여기서 작업한다.
        log('---> ConnectionService::init(): It is connected to the internet.');

        /// 온라인 상태라고 알림.
        isOnline.value = true;
        ready?.call();
      }
    });
  }
}
