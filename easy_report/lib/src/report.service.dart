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
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => ReportDialog(documentReference: documentReference),
    );
    if (reason == null) return;

    /// TODO 여기서 부터, Firestore 의 /reports 에 권한을 주고,
    /// TODO 신고를 했는지 확인해서, 신고를 했으면, 이미 신고했다고 알려준다.
    /// TODO 신고 대상사의 이름과 사진을 보여준다.

    await col.add({
      'reporter': currentUser!.uid,
      'reportee': otherUid,
      'reason': reason,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
