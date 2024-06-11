import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/author_model.dart';
import '../models/post_model.dart';
import '../models/replies_model.dart';
import 'package:intl/intl.dart';

class PostService {
  // get collection of notes
  final CollectionReference posts =
      FirebaseFirestore.instance.collection("posts");

  // CREATE: new note
  Future<void> addPost({
    required String question,
    required String content,
    required Author author,
  }) {
    return posts.add({
      "author": author.name,
      "content": content,
      "created_at": DateFormat('dd-MM-yyyy').format(DateTime.now()),
      "question": question,
      "repliesCount": 0,
      "views": 0,
      "votes": 0,
    });
  }

  //
  Future<List<Post>> getPosts() async {
    try {
      List<Post> questions = [];
      await posts.get().then((event) {
        for (var doc in event.docs) {
          var data = doc.data() as Map<String, dynamic>;
          questions.add(Post(
            id: doc.id,
            question: data['question'],
            content: data['content'],
            votes: data['votes'],
            repliesCount: data['repliesCount'],
            views: data['views'],
            created_at: data['created_at'],
            author: Author(image: "", email: "", name: data['author'], uid: ""),
            replies: [],
          ));
        }
      });

      return questions;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  Future<void> updatePost(String postId, Post post) async {
    await posts.doc(postId).update(post.toMap());
  }

  Future<void> deletePost(String postId) async {
    await posts.doc(postId).delete();
  }
}
