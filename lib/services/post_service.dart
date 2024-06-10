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

  // Stream<List<Question>> getPost() {
  //   final postStream = posts.snapshots().map((querySnapshot) {
  //     return querySnapshot.docs.map((doc) {
  //       return Question.fromMap(doc.data() as Map<String, dynamic>);
  //     }).toList();
  //   });
  //
  //   print("tes\n");
  //   print(postStream);
  //
  //   return postStream;
  // }
  Stream<QuerySnapshot> getPost() {
    final postStream = posts.orderBy("views", descending: true).snapshots();

    return postStream;
  }

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //
  Future<List<Question>> getQuestions() async {
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
            author: mark,
            replies: reply,
          ));
        }
      });
      print("Service \n\n\n\n");

      return questions;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }
}
