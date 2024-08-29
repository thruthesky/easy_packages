import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// FirestoreLimitedListView
///
/// Why:
/// If you want to display the 10 most new documents from Firetore, It's not
/// easy with [FirestoreListView] and [FirestoreQueryBuilder]. So, this widget
/// is created to solve this problem.
///
/// Purpose:
/// To display a limited number of documents from Firestore.
///
/// This rebuilds the items in realtime as the data changes.
///
/// [builder] is a function that will be called after the query.
/// Note that the list of [QueryDocumentSnapshot] will be passed over the callback.
///
/// [loadingBuilder] is a function that will be called when the query is loading.
///
/// [errorBuilder] is a function that will be called when the query has an error.
///
/// [emptyBuilder] is a function that will be called when the query has no data.
/// ```
class FirestoreLimitedQueryBuilder extends StatelessWidget {
  const FirestoreLimitedQueryBuilder({
    super.key,
    required this.query,
    required this.limit,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    required this.builder,
  });

  final Query query;
  final int limit;

  final Widget Function()? loadingBuilder;
  final Widget Function(String)? errorBuilder;
  final Widget Function()? emptyBuilder;
  final Widget Function(List<QueryDocumentSnapshot>) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.limit(limit).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log('Something went wrong: ${snapshot.error}');
          return errorBuilder?.call('${snapshot.error}') ??
              Text('${'something went wrong'}: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return Center(
            child: loadingBuilder?.call() ??
                const CircularProgressIndicator.adaptive(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return emptyBuilder?.call() ?? const SizedBox.shrink();
        }

        final docs = snapshot.data!.docs;

        return builder(docs);
      },
    );
  }
}
