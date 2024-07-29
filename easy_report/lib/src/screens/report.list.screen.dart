import 'package:easy_report/easy_report.dart';
import 'package:easyuser/easyuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

class ReportListScreen extends StatefulWidget {
  static const String routeName = '/ReportList';
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Report List'),
      ),
      body: FirestoreListView(
        query: ReportService.instance.col.where('reporter',
            isEqualTo: FirebaseAuth.instance.currentUser!.uid),
        itemBuilder: (context, snapshot) {
          final report = Report.fromSnapshot(snapshot);
          return ListTile(
            leading: UserAvatar.fromUid(uid: report.reportee),
            title: Text(report.reportee),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(report.reason),
                Text(report.createdAt.toString()),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                report.ref.delete();
              },
            ),
          );
        },
      ),
    );
  }
}
