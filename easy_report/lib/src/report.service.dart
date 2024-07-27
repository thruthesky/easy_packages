import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_report/easy_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReportService {
  static ReportService? _instance;
  static ReportService get instance => _instance ??= ReportService._();
  ReportService._();

  CollectionReference col = FirebaseFirestore.instance.collection('reports');

  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<void> report({
    required BuildContext context,
    required DocumentReference documentReference,
    String? otherUid,
    String? reason,
  }) async {
    final re = await showDialog<String>(
      context: context,
      builder: (context) => ReportDialog(documentReference: documentReference),
    );
    if (re == null) return;

    /// TODO 여기서 부터.
    await documentReference.collection('reports').add({
      'reporter': currentUser!.uid,
      'reportee': otherUid,
      'reason': re,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
