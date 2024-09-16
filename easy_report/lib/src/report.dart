import 'package:easy_report/easy_report.dart';
import 'package:firebase_database/firebase_database.dart';

class Report {
  final String id;
  final String reporter;
  final String reportee;
  final String path;
  final String reason;
  final String type;
  final String summary;
  final DateTime createdAt;

  DatabaseReference get ref => ReportService.instance.reportsRef.child(id);

  Report({
    required this.id,
    required this.reporter,
    required this.reportee,
    required this.path,
    required this.reason,
    required this.type,
    required this.summary,
    required this.createdAt,
  });

  factory Report.fromSnapshot(DataSnapshot snapshot) {
    return Report.fromJson(
      snapshot.value as Map<String, dynamic>,
      snapshot.key!,
    );
  }

  factory Report.fromJson(Map<String, dynamic> json, String id) {
    return Report(
      id: id,
      reporter: json['reporter'],
      reportee: json['reportee'],
      path: json['path'],
      reason: json['reason'],
      type: json['type'],
      summary: json['summary'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reporter': reporter,
      'reportee': reportee,
      'path': path,
      'reason': reason,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'Report(${toJson()})';
  }
}
