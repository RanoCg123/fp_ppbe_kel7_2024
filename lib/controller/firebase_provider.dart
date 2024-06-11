import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/author_model.dart';
import 'firebase_firestore_service.dart';

class FirebaseProvider extends ChangeNotifier {
  ScrollController scrollController = ScrollController();

  List<Author> authors = [];
  Author? author;
  List<Author> search = [];

  List<Author> getAllUsers() {
    FirebaseFirestore.instance
        .collection('authors')
        .orderBy('lastActive', descending: true)
        .snapshots(includeMetadataChanges: true)
        .listen((authors) {
      this.authors = authors.docs
          .map((doc) => Author.fromJson(doc.data()))
          .toList();
      notifyListeners();
    });
    return authors;
  }

  Author? getUserById(String authorId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(authorId)
        .snapshots(includeMetadataChanges: true)
        .listen((author) {
      this.author = Author.fromJson(author.data()!);
      // notifyListeners();
    });
    return this.author;
  }



  void scrollDown() =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.jumpTo(
              scrollController.position.maxScrollExtent);
        }
      });

}
