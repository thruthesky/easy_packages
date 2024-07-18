import 'package:firebase_auth/firebase_auth.dart';

User? get currentUser => FirebaseAuth.instance.currentUser;
