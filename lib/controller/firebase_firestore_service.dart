import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/author_model.dart';
import 'firebase_storage_service.dart';

class FirebaseFirestoreService {
  static final firestore = FirebaseFirestore.instance;

  // Create a new user in Firestore
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

    await firestore.collection('users').doc(uid).set(author.toJson());
  }

  // Update user profile information in Firestore
  static Future<void> updateUser({
    required String uid,
    required String name,
    required String email,
    required imageUrl,
  }) async {
    final data = {
      'name': name,
      'email': email,
    };

    if (imageUrl != null) {
      data['image'] = imageUrl;
    }

    await firestore.collection('users').doc(uid).update(data);
  }
  static Future<void> deleteUser(String uid) async {
    // Delete user's posts
    QuerySnapshot postsSnapshot = await firestore
        .collection('posts')
        .where('author', isEqualTo: uid)
        .get();

    for (var postDoc in postsSnapshot.docs) {
      await firestore.collection('posts').doc(postDoc.id).delete();
    }

    // Delete user's replies
    QuerySnapshot repliesSnapshot = await firestore
        .collectionGroup('replies')
        .where('author.uid', isEqualTo: uid)
        .get();

    for (var replyDoc in repliesSnapshot.docs) {
      await replyDoc.reference.delete();
    }

   // Delete user bookmark
    QuerySnapshot bookmark = await firestore.collection('users').doc(uid).collection('bookmark').get();
    for (var bookmarkdoc in bookmark.docs) {
      await bookmarkdoc.reference.delete();
    }
    // Delete user doc
    await firestore.collection('users').doc(uid).delete();
  }
}
  // Upload profile image to Firebase Storage and return the UR


