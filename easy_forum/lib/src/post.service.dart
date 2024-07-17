import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_helpers/easy_helpers.dart';

class PostService {
  static PostService? _instance;

  static PostService get instance => _instance ??= PostService._();
  PostService._();

  String collectionName = 'posts';
  bool initialized = false;
  CollectionReference get col =>
      FirebaseFirestore.instance.collection(collectionName);

  init({
    String? collectionName,
  }) {
    if (initialized) {
      dog('PostService is already initialized; It will not initialize again.');
      return;
    }

    initialized = true;
    if (collectionName != null) {
      this.collectionName = collectionName;
    }
  }
}
