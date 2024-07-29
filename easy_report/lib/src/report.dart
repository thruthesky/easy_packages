import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_report/easy_report.dart';

class Report {
  final String id;
  final String reporter;
  final String reportee;
  final DocumentReference documentReference;
  final String reason;
  final DateTime createdAt;

  DocumentReference get ref => ReportService.instance.col.doc(id);

  Report({
    required this.id,
    required this.reporter,
    required this.reportee,
    required this.documentReference,
    required this.reason,
    required this.createdAt,
  });

  factory Report.fromSnapshot(DocumentSnapshot snapshot) {
    return Report.fromJson(
      snapshot.data() as Map<String, dynamic>,
      snapshot.id,
    );
  }

  factory Report.fromJson(Map<String, dynamic> json, String id) {
    return Report(
      id: id,
      reporter: json['reporter'],
      reportee: json['reportee'],
      documentReference: json['documentReference'],
      reason: json['reason'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporter': reporter,
      'reportee': reportee,
      'documentReference': documentReference,
      'reason': reason,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'Report(${toJson()})';
  }
}
