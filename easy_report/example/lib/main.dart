import 'package:flutter/material.dart';
import 'package:easy_report/easy_report.dart';

void main() {
  runApp(const EasyReportApp());
}

class EasyReportApp extends StatelessWidget {
  const EasyReportApp({super.key});

  @override
  build(_) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                ReportService.instance.report(
                  context: _,
                  reportee: 'reportee',
                  type: 'type',
                  path: 'user-uid',
                  summary: 'summary',
                );
              },
              child: const Text('Report a user'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Report a Post'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Report a Comment'),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Report a Chat Room'),
            ),
          ],
        ),
      ),
    );
  }
}
