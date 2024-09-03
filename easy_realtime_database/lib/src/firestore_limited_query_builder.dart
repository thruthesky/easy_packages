import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

/// DatabaseLimitedQueryBuilder
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
class DatabaseLimitedQueryBuilder extends StatelessWidget {
  const DatabaseLimitedQueryBuilder({
    super.key,
    required this.ref,
    required this.limit,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    required this.builder,
  });

  final DatabaseReference ref;
  final int limit;

  final Widget Function()? loadingBuilder;
  final Widget Function(String)? errorBuilder;
  final Widget Function()? emptyBuilder;
  final Widget Function(List<DataSnapshot>) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: ref.limitToLast(limit).onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log('Something went wrong: ${snapshot.error}');
          return errorBuilder?.call('${snapshot.error}') ??
              Text('${'something went wrong'}: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.hasData == false) {
          return Center(
            child: loadingBuilder?.call() ??
                const CircularProgressIndicator.adaptive(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return emptyBuilder?.call() ?? const SizedBox.shrink();
        }

        final docs = snapshot.data!.snapshot.value as List<DataSnapshot>;

        return builder(docs);
      },
    );
  }
}
