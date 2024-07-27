import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {
  static ReportService? _instance;
  static ReportService get instance => _instance ??= ReportService._();
  ReportService._();

  CollectionReference col = FirebaseFirestore.instance.collection('reports');

  // Future<void> showReportDialog({
  //   required BuildContext context,
  //   required DocumentReference documentReference,
  // }) async {
  //   final re = await showDialog<String>(
  //     context: context,
  //     builder: (context) => ReportDialog(documentReference: documentReference),
  //   );
  //   if (re == null) return;
  //   await documentReference.collection('reports').add({
  //     'uid': i.auth.currentUser!.uid,
  //     'reason': re,
  //     'createdAt': FieldValue.serverTimestamp(),
  //   });
  // }
}
