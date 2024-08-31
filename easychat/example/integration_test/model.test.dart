// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:example/firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';

// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//   late FirebaseFirestore firestore;

//   setUpAll(() async {
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform);
//     firestore = FirebaseFirestore.instance;
//   });

//   group('Chat Room Test', () {
//     late String collectionName;

//     test('Chat Room Model Test', () async {
//       // When: 첫 번째 문서 가져오기 및 fromJson 매핑
//       final querySnapshot =
//           await firestore.collection(collectionName).limit(1).get();

//       //   expect(fetchedData, isNotNull, reason: 'fetchedData는');
//     });
//   });
// }
