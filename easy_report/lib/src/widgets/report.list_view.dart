import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_realtime_database/easy_realtime_database.dart';
import 'package:easy_report/easy_report.dart';
import 'package:firebase_database/firebase_database.dart';
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
      query: ReportService.instance.myReportsRef.orderByKey(),
      itemBuilder: (context, snapshot) {
        final report = Report.fromSnapshot(snapshot);
        return ListTile(
          leading: Value(
            sync: false,
            ref: FirebaseDatabase.instance
                .ref(ReportService.instance.userNamePath.replaceFirst('{uid}', report.reportee)),
            builder: (v, r) {
              if (v == null) {
                return const SizedBox.shrink();
              }
              return CircleAvatar(child: CachedNetworkImage(imageUrl: (v as String).thumbnail));
            },
          ),
          title: Value(
            sync: false,
            ref: FirebaseDatabase.instance
                .ref(ReportService.instance.userNamePath.replaceFirst('{uid}', report.reportee)),
            builder: (v, r) {
              if (v == null) {
                return const SizedBox.shrink();
              }
              return Text('$v');
            },
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${report.reason} ${report.type} ${report.summary}'),
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
