import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/author_model.dart';
import 'firebase_storage_service.dart';

class FirebaseFirestoreService {
  static final firestore = FirebaseFirestore.instance;

  static Future<void> createUser({
    required String name,
    required String image,
    required String email,
    required String uid,
  }) async {
    final author = Author(
      uid: uid,
      email: email,
      name: name,
      image: image,
    );

    await firestore
        .collection('users')
        .doc(uid)
        .set(author.toJson());
  }

}
