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

  // report
  Future<void> report({
    required BuildContext context,
    required DocumentReference documentReference,
    required String otherUid,
  }) async {
    // Check if the user has already reported by you.
    final snapshot = await col
        .where('reporter', isEqualTo: currentUser!.uid)
        .where('reportee', isEqualTo: otherUid)
        .get();
    if (snapshot.docs.isNotEmpty) {
      if (context.mounted) {
        toast(
            context: context, message: 'You have already reported this user'.t);
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

    await col.add({
      'reporter': currentUser!.uid,
      'reportee': otherUid,
      'reason': reason,
      'documentReference': documentReference,
      'createdAt': FieldValue.serverTimestamp(),
    });

    if (context.mounted) {
      toast(context: context, message: 'You have reported this user now'.t);
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
