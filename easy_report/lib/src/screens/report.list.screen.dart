import 'package:easy_report/easy_report.dart';
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
      body: const ReportListView(),
    );
  }
}
