import 'package:cloud_firestore/cloud_firestore.dart';

class CommentService {
  static CommentService? _instance;
  static CommentService get instance => _instance ??= CommentService._();

  CommentService._();

  bool initialized = false;
  CollectionReference get col =>
      FirebaseFirestore.instance.collection('comments');
}
