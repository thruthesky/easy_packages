import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_report/easy_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// Report service
class ReportService {
  static ReportService? _instance;
  static ReportService get instance => _instance ??= ReportService._();
  ReportService._();

  DatabaseReference reportsRef = FirebaseDatabase.instance.ref('reports');
  DatabaseReference get myReportsRef => reportsRef.child(FirebaseAuth.instance.currentUser!.uid);

  User? get currentUser => FirebaseAuth.instance.currentUser;

  /// Callback after report is created.
  /// Usage: e.g. send push notification after report to admin or user
  Function(Report)? onCreate;

  String get userNamePath => 'mirror-users/{uid}/displayName';
  String get userPhotoUrlPath => 'mirror-users/{uid}/photoUrl';

  init({
    Function(Report)? onCreate,
    String userNamePath = 'mirror-users/{uid}/displayName',
    String userPhotoUrlPath = 'mirror-users/{uid}/photoUrl',
  }) {
    this.onCreate = onCreate;
  }

  /// Report
  ///
  /// It reports the [reportee] user with the [path] document reference.
  ///
  /// Use this method to report a user.
  ///
  /// Refer to README.md for details.
  Future<void> report({
    required BuildContext context,
    required String path,
    required String reportee,
    required String type,
    required String summary,
  }) async {
    if (currentUser == null) {
      if (context.mounted) {
        toast(context: context, message: Text('You are not signed in'.t));
      }
      return;
    }

    if (currentUser?.uid == reportee) {
      if (context.mounted) {
        toast(context: context, message: Text('You cannot report yourself'.t));
      }
      return;
    }

    // Check if the login user has already reported the same data(user, post, comment, chat room, etc)
    final snapshot = await myReportsRef.orderByChild('path').equalTo(path).get();
    if (snapshot.value != null) {
      if (context.mounted) {
        toast(context: context, message: Text('You have already reported this'.t));
      }
      return;
    }

    String? reason;

    if (context.mounted) {
      reason = await showDialog<String>(
        context: context,
        builder: (context) => ReportDialog(
          reportee: reportee,
          path: path,
          type: type,
          summary: summary,
        ),
      );

      if (reason == null) return;
    }

    final data = {
      'reporter': currentUser!.uid,
      'reportee': reportee,
      'reason': reason,
      'path': path,
      'type': type,
      'summary': summary,
      'createdAt': ServerValue.timestamp,
    };

    final ref = myReportsRef.push();

    await ref.set(data);

    /// if onCreate is set, then call the call back.
    onCreate?.call(Report.fromJson(data, ref.key!));

    if (context.mounted) {
      toast(context: context, message: Text('You have reported this user now'.t));
    }
  }

  /// Show post list screen
  void showReportListScreen(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) => const ReportListScreen(),
    );
  }
}
