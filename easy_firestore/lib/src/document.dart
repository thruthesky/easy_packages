import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firestore/easy_firestore.dart';
import 'package:flutter/material.dart';

/// Document
class Document extends StatelessWidget {
  const Document({
    super.key,
    required this.collectionName,
    required this.id,
    this.initialData,
    required this.builder,
  });

  final String collectionName;
  final String id;
  final Map<String, dynamic>? initialData;
  final Widget Function(DocumentModel) builder;

  DocumentReference get ref =>
      FirebaseFirestore.instance.collection(collectionName).doc(id);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>?>(
      initialData: initialData,
      stream: ref.snapshots().map((snapshot) {
        return snapshot.data() as Map<String, dynamic>?;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return const CircularProgressIndicator.adaptive();
        }
        if (snapshot.hasError) {
          debugPrint("Error: ${snapshot.error}");
          return Text("Error: ${snapshot.error}");
        }

        return builder(
          DocumentModel.fromJson(
            collectionName,
            id,
            snapshot.data ?? {},
          ),
        );
      },
    );
  }
}
