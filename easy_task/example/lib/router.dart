import 'package:example/screens/home/home.screen.dart';
import 'package:example/screens/task_list/task_list.screen.dart';
import 'package:example/screens/test/test.screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();
BuildContext get globalContext => globalNavigatorKey.currentContext!;

/// GoRouter
final router = GoRouter(
  navigatorKey: globalNavigatorKey,
  routes: [
    GoRoute(
      path: HomeScreen.routeName,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: TaskListScreen.routeName,
      builder: (context, state) => const TaskListScreen(),
    ),
    GoRoute(
      path: TestScreen.routeName,
      builder: (context, state) => const TestScreen(),
    ),
  ],
);
