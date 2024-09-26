import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

/// Value
///
/// Rebuild the widget when the node is changed.
///
/// [path] is the path of the node. If the node does not exist, pass null to builder().
/// [path] 는 노드의 경로이다. 만약 해당 노드가 존재하지 않으면 null 을 builder() 로 전달한다.
///
/// [ref] is the reference of the node. If the node does not exist, pass null to builder().
///
/// [builder] is the widget builder.
///
/// [initialData] is the initial data to show when waiting for the data. This
/// is useful to prevent the screen flickering.
///
/// [onLoading] is the widget to show when waiting for the data.
///
/// Example: below will get the snapshot of /path/to/node
///
/// ```dart
/// Value(path: 'path/to/node', builder: (value) {
///  return Text(value);
/// });
///
class Value<T> extends StatelessWidget {
  const Value({
    super.key,
    required this.ref,
    required this.builder,
    this.initialData,
    this.onLoading,
    this.sync = true,
  });

  // TODO deprecate
  // const Value.once({
  //   super.key,
  //   required this.ref,
  //   required this.builder,
  //   this.initialData,
  //   this.onLoading,
  // }) : sync = false;

  final DatabaseReference ref;

  final dynamic initialData;

  /// [dynamic] is the value of the node.
  /// [String] is the path of the node.
  final Widget Function(dynamic value, DatabaseReference ref) builder;
  final Widget? onLoading;

  final bool sync;

  @override
  Widget build(BuildContext context) {
    if (sync) {
      return StreamBuilder<dynamic>(
        initialData: initialData,
        stream: ref.onValue.map((event) {
          return event.snapshot.value;
        }),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            log('Error; path: ${ref.path}, message: ${snapshot.error}');
            return Text('Error; path: ${ref.path}, message: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting && snapshot.hasData == false) {
            // log('--> Value() -> Waiting; path: ${ref.path} connectionState: ${snapshot.connectionState}, hasData: ${snapshot.hasData}');
            return onLoading ?? const SizedBox.shrink();
          }

          // value may be null.
          return builder(snapshot.data as T, ref);
        },
      );
    } else {
      return FutureBuilder<dynamic>(
        initialData: initialData,
        future: ref.once().then((event) => event.snapshot.value),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && snapshot.hasData == false) {
            return onLoading ?? const SizedBox.shrink();
          }
          if (snapshot.hasError) {
            log('---> Value.once() -> Error; path: ${ref.path}, message: ${snapshot.error}');
            return Text('Error; ${snapshot.error}');
          }

          return builder(snapshot.data as T, ref);
        },
      );
    }
  }
}
