import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_forum_kel7_ppbe/models/author_model.dart';
import 'package:fp_forum_kel7_ppbe/models/post_model.dart';
import 'package:fp_forum_kel7_ppbe/models/replies_model.dart';

class PostService {
  // get collection of notes
  final CollectionReference posts =
      FirebaseFirestore.instance.collection("posts");

  // CREATE: new note
  Future<void> addPost(Question post) {
    return posts.add({
      "author": post.author.name,
      "content": post.content,
      "created_at": post.created_at,
      "question": post.question,
      "repliesCount": post.replies,
      "views": post.views,
      "votes": post.votes
    });
  }

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  Future<List<Question>> getPosts() async {
    try {
      List<Question> questions = [];
      await posts.get().then((event) {
        for (var doc in event.docs) {
          var data = doc.data() as Map<String, dynamic>;
          questions.add(Question(
            question: data['question'],
            content: data['content'],
            votes: data['votes'],
            repliesCount: data['repliesCount'],
            views: data['views'],
            created_at: data['created_at'],
            author: Author(image: "", email: "", name: "Mark", uid: ""),
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
}
