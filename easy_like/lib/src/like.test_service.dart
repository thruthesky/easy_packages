import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_like/easy_like.dart';

class LikeTestService {
  static LikeTestService? _instance;
  static LikeTestService get instance => _instance ??= LikeTestService._();

  final db = FirebaseFirestore.instance;

  LikeTestService._();

  /// Write a test for the Like model.
  runTests() async {
    log('--> Like tests');

    final documentReference = db.collection('tmp').doc('a');
    await documentReference.set({
      'title': 'a',
    });

    final like = Like(
      uid: 'uid-a',
      documentReference: documentReference,
    );

    await like.like();

    await Future.delayed(const Duration(seconds: 1));

    final gotSnapshot = await documentReference.get();
    final gotData = gotSnapshot.data()!;
    assert(gotData['likes'] == 1);

    final refSnapshot = await like.ref.get();
    final dynamic refData = refSnapshot.data()!;
    assert(refData['likes'] == 1);
    assert(refData['likedBy'].length == 1);
    assert(refData['likedBy'].contains('uid-a'));

    await like.like();

    await Future.delayed(const Duration(seconds: 1));

    final gotSnapshot2 = await documentReference.get();
    final gotData2 = gotSnapshot2.data()!;
    assert(gotData2['likes'] == 0);

    final refSnapshot2 = await like.ref.get();
    final dynamic refData2 = refSnapshot2.data()!;
    assert(refData2['likes'] == 0);
    assert(refData2['likedBy'].length == 0);
    assert(refData2['likedBy'].contains('uid-a') == false);
  }
}
