import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_like/easy_like.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikeTestService {
  static LikeTestService? _instance;
  static LikeTestService get instance => _instance ??= LikeTestService._();

  final db = FirebaseFirestore.instance;

  LikeTestService._();

  static get currentUser => FirebaseAuth.instance.currentUser;

  /// Write a test for the Like model.
  runTests() async {
    log('--> Like tests');

    final documentReference = db
        .collection('tmp')
        .doc('like-test-${DateTime.now().millisecondsSinceEpoch}');
    await documentReference.set({
      'title': 'a',
    });

    final like = Like(
      documentReference: documentReference,
    );

    await like.like();

    await Future.delayed(const Duration(seconds: 1));

    final gotSnapshot = await documentReference.get();
    final gotData = gotSnapshot.data()!;
    assert(gotData['likeCount'] == 1);

    final refSnapshot = await like.ref.get();
    final dynamic refData = refSnapshot.data()!;
    assert(refData['likeCount'] == 1);
    assert(refData['likedBy'].length == 1);
    assert(refData['likedBy'].contains(currentUser!.uid));

    await like.like();

    await Future.delayed(const Duration(seconds: 1));

    final gotSnapshot2 = await documentReference.get();
    final gotData2 = gotSnapshot2.data()!;
    assert(gotData2['likeCount'] == 0);

    final refSnapshot2 = await like.ref.get();
    final dynamic refData2 = refSnapshot2.data()!;
    assert(refData2['likeCount'] == 0);
    assert(refData2['likedBy'].length == 0);
    assert(refData2['likedBy'].contains('uid-a') == false);

    log('--> Test is done !');
  }
}
