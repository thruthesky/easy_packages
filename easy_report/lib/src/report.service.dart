import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';
import 'package:easy_locale/easy_locale.dart';
import 'package:easy_report/easy_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Report service
class ReportService {
  static ReportService? _instance;
  static ReportService get instance => _instance ??= ReportService._();
  ReportService._();

  CollectionReference col = FirebaseFirestore.instance.collection('reports');

  User? get currentUser => FirebaseAuth.instance.currentUser;

  /// Callback after report is created. usage, eg. push notification after report to admin or user
  Function(Report)? onCreate;

  init({
    Function(Report)? onCreate,
  }) {
    this.onCreate = onCreate;
  }

  /// Report
  ///
  /// It reports the [otherUid] user with the [documentReference] document reference.
  ///
  /// Use this method to report a user.
  ///
  /// Refer to README.md for details.
  Future<void> report({
    required BuildContext context,
    required DocumentReference documentReference,
    required String otherUid,
  }) async {
    if (currentUser == null) {
      if (context.mounted) {
        toast(context: context, message: Text('You are not signed in'.t));
      }
      return;
    }

    if (currentUser?.uid == otherUid) {
      if (context.mounted) {
        toast(context: context, message: Text('You cannot report yourself'.t));
      }
      return;
    }

    // Check if the user has already reported by you.
    final snapshot = await col
        .where('reporter', isEqualTo: currentUser!.uid)
        .where('reportee', isEqualTo: otherUid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      if (context.mounted) {
        toast(
            context: context,
            message: Text('You have already reported this user'.t));
      }
      return;
    }

    String? reason;

    if (context.mounted) {
      reason = await showDialog<String>(
        context: context,
        builder: (context) => ReportDialog(
          reportee: otherUid,
          documentReference: documentReference,
        ),
      );

      if (reason == null) return;
    }

    final data = {
      'reporter': currentUser!.uid,
      'reportee': otherUid,
      'reason': reason,
      'documentReference': documentReference,
      'createdAt': FieldValue.serverTimestamp(),
    };

    final ref = await col.add(data);

    /// if onCreate is set, then call the call back.
    onCreate?.call(Report.fromJson(data, ref.id));

    if (context.mounted) {
      toast(
          context: context, message: Text('You have reported this user now'.t));
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
