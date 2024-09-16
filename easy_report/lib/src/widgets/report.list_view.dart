import 'package:easy_report/easy_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_database/firebase_ui_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:easy_helpers/easy_helpers.dart';

class ReportListView extends StatelessWidget {
  const ReportListView({
    super.key,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.itemBuilder,
    this.emptyBuilder,
  });

  final Axis scrollDirection;
  final bool reverse;
  final ScrollController? controller;
  final bool? primary;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;
  final double? cacheExtent;
  final DragStartBehavior dragStartBehavior;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final String? restorationId;
  final Clip clipBehavior;
  final Widget Function(Report, int)? itemBuilder;
  final Widget Function()? emptyBuilder;
  @override
  Widget build(BuildContext context) {
    return FirebaseDatabaseListView(
      scrollDirection: scrollDirection,
      reverse: reverse,
      controller: controller,
      primary: primary,
      physics: physics,
      shrinkWrap: shrinkWrap,
      padding: padding,
      addAutomaticKeepAlives: addAutomaticKeepAlives,
      addRepaintBoundaries: addRepaintBoundaries,
      addSemanticIndexes: addSemanticIndexes,
      cacheExtent: cacheExtent,
      dragStartBehavior: dragStartBehavior,
      keyboardDismissBehavior: keyboardDismissBehavior,
      restorationId: restorationId,
      clipBehavior: clipBehavior,
      query: ReportService.instance.reportsRef.orderByChild('reporter').equalTo(FirebaseAuth.instance.currentUser!.uid),
      itemBuilder: (context, snapshot) {
        final report = Report.fromSnapshot(snapshot);
        return ListTile(
          // leading: UserAvatar.fromUid(uid: report.reportee),
          // title: UserDoc(
          //   uid: report.reportee,
          //   builder: (user) {
          //     if (user == null) {
          //       return const SizedBox.shrink();
          //     }
          //     return DisplayName(user: user);
          //   },
          // ),
          /// TODO: get user data from RTDB and display
          title: const Text('TODO: get user data from RTDB and display'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(report.reason),
              Text(report.createdAt.yMdjm),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              report.ref.remove();
            },
          ),
        );
      },
      errorBuilder: (context, error, StackTrace? stackTrace) {
        return Center(
          child: Text('Error: $error'),
        );
      },
    );
  }
}
