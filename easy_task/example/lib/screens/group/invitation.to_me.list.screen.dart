import 'package:easy_task/easy_task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InvitationToMeListScreen extends StatelessWidget {
  const InvitationToMeListScreen({super.key});

  String? get myUid => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invitations"),
      ),
      body: InvitationListView(
        queryOptions: InvitationQueryOptions(uid: myUid),
      ),
    );
  }
}
