import 'package:easy_firestore/easy_firestore.dart';
import 'package:flutter/material.dart';

class Setting extends StatelessWidget {
  const Setting({super.key, required this.id, required this.builder});

  final String id;
  final Widget Function(DocumentModel) builder;

  @override
  Widget build(BuildContext context) {
    return Document(
        collectionName: 'settings',
        id: id,
        builder: (model) {
          return builder(model);
        });
  }
}
