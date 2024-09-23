import 'dart:developer';

import 'package:easy_like/easy_like.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LikeTestService {
  static LikeTestService? _instance;
  static LikeTestService get instance => _instance ??= LikeTestService._();

  FirebaseDatabase get database => FirebaseDatabase.instance;

  LikeTestService._();

  static get currentUser => FirebaseAuth.instance.currentUser;

  /// Write a test for the Like model.
  runTests() async {
    log('--> Like tests');

    final documentReference = database.ref('tmp').child('like-test-${DateTime.now().millisecondsSinceEpoch}');
    await documentReference.set({
      'title': 'a',
    });

    final like = Like(
      parentReference: documentReference,
    );

    await like.like();

    await Future.delayed(const Duration(seconds: 1));

    final gotSnapshot = await documentReference.get();
    final gotData = gotSnapshot.value as Map;
    assert(gotData['likeCount'] == 1);

    final refSnapshot = await like.ref.get();
    final dynamic refData = refSnapshot.value as Map;
    assert(refData['likeCount'] == 1);
    assert(refData['likedBy'].length == 1);
    assert(refData['likedBy'].contains(currentUser!.uid));

    await like.like();

    await Future.delayed(const Duration(seconds: 1));

    final gotSnapshot2 = await documentReference.get();
    final gotData2 = gotSnapshot2.value as Map;
    assert(gotData2['likeCount'] == 0);

    final refSnapshot2 = await like.ref.get();
    final dynamic refData2 = refSnapshot2.value as Map;
    assert(refData2['likeCount'] == 0);
    assert(refData2['likedBy'].length == 0);
    assert(refData2['likedBy'].contains('uid-a') == false);

    log('--> Test is done !');
  }
}
