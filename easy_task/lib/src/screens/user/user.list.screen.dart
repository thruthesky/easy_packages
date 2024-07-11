import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//  review should we include this in export?
class UserListScreen extends StatelessWidget {
  const UserListScreen({
    super.key,
    this.onTap,
  });

  final Function(String uid)? onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: FirestoreQueryBuilder(
        query: FirebaseFirestore.instance.collection('users'),
        builder: (context, snapshot, _) {
          if (snapshot.isFetching) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            log('Something went wrong! ${snapshot.error}');
            return Text('Something went wrong! ${snapshot.error}');
          }

          if (snapshot.hasData && snapshot.docs.isEmpty && !snapshot.hasMore) {
            return const Center(child: Text('todo list is empty'));
          }

          return ListView.builder(
            itemCount: snapshot.docs.length,
            itemBuilder: (context, index) {
              // if we reached the end of the currently obtained items, we try to
              // obtain more items
              if (snapshot.hasMore && index + 1 == snapshot.docs.length) {
                // Tell FirestoreQueryBuilder to try to obtain more items.
                // It is safe to call this function from within the build method.
                snapshot.fetchMore();
              }

              final user = snapshot.docs[index].data();
              final userUid = snapshot.docs[index].id;
              final userDisplayName = user['displayName'];

              return Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  border: Border.all(width: 1),
                ),
                child: ListTile(
                  title: Text("Uid: $userUid"),
                  subtitle: Text("Name: $userDisplayName"),
                  onTap: () {
                    onTap?.call(userUid);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
