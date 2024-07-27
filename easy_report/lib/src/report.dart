import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String reporter;
  final String reportee;
  final DocumentReference documentReference;
  final String reason;
  final DateTime createdAt;

  Report({
    required this.reporter,
    required this.reportee,
    required this.documentReference,
    required this.reason,
    required this.createdAt,
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      reporter: map['reporter'],
      reportee: map['reportee'],
      documentReference: map['documentReference'],
      reason: map['reason'],
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reporter': reporter,
      'reportee': reportee,
      'documentReference': documentReference,
      'reason': reason,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'Report(${toMap()})';
  }
}
