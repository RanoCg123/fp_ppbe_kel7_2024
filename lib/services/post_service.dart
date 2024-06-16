import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_forum_kel7_ppbe/controller/firebase_provider.dart';
import 'package:fp_forum_kel7_ppbe/models/author_model.dart';
import 'package:fp_forum_kel7_ppbe/models/post_model.dart';
import 'package:fp_forum_kel7_ppbe/models/replies_model.dart';
import 'package:intl/intl.dart';

class PostService {
  // get collection of notes
  final CollectionReference posts =
  FirebaseFirestore.instance.collection("posts");

  // get collection of users
  final CollectionReference users =
  FirebaseFirestore.instance.collection("users");

  // CREATE: new note
  Future<Post> addPost ({
    required String question,
    required String content,
    required String topic,
    required String authorId,
  }) async {
    DateTime now = DateTime.now();
    DocumentReference postReference = await posts.add({
      "author": authorId,
      "topic": topic,
      "content": content,
      "created_at": DateTime.now(),
      "question": question,
      "repliesCount": 0,
      "views": [],
      "votes": [],
    });

    var postAuthor = await users.doc(authorId).get();
    var postAuthorData = Author.fromJson(postAuthor.data() as Map<String, dynamic>);

    return Post(
      id: postReference.id,
      question: question,
      content: content,
      topic: topic,
      votes: [],
      repliesCount: 0,
      views: [],
      created_at: DateFormat('dd-MM-yyyy').format(now),
      author: postAuthorData,
      replies: [],
    );
  }

  //
  Future<List<Post>> getPosts() async {
    try {
      List<Post> questions = [];
      await posts.orderBy('created_at', descending: true).get().then((event) async {
        for (var doc in event.docs) {
          var data = doc.data() as Map<String, dynamic>;

          // get the data of author
          var postAuthorDoc = await users.doc(data['author']).get();
          Map<String, dynamic> postAuthorData = postAuthorDoc.data() as Map<String, dynamic>;
          final postAuthor = Author.fromJson(postAuthorData);

          // convert timestamp to datetime
          Timestamp timestamp = data['created_at'];
          DateTime createdAt = timestamp.toDate();

          // get votes
          List<String> votes = List<String>.from(data["views"]);
          List<String> views = List<String>.from(data["votes"]);

          questions.add(Post(
            id: doc.id,
            question: data['question'],
            content: data['content'],
            topic: data['topic'],
            votes: votes,
            repliesCount: data['repliesCount'],
            views: views,
            created_at: DateFormat('dd-MM-yyyy').format(createdAt),
            author: postAuthor,
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

  Future<void> votePost(String postId, String userId) async {
    try {
      DocumentReference postRef = posts.doc(postId);

      // Fetch the document
      DocumentSnapshot postSnapshot = await postRef.get();

      if (postSnapshot.exists) {
        // Get the current array
        List<dynamic> array = postSnapshot.get('votes');

        // Check if user has been vote the post
        if (array.contains(userId)) {
          // Un vote the post
          await postRef.update({
            'votes': FieldValue.arrayRemove([userId])
          });
        }
        // user hasn't been vote the post
        else {
          // Vote the post
          await postRef.update({
            'votes': FieldValue.arrayUnion([userId])
          });
        }
      }
    }
    catch (e) {
      print(e);
    }
  }

  Future<void> viewPost(String postId, String userId) async {
    try {
      DocumentReference postRef = posts.doc(postId);

      // Fetch the document
      DocumentSnapshot postSnapshot = await postRef.get();

      if (postSnapshot.exists) {
        // Get the current array
        List<dynamic> array = postSnapshot.get('views');

        // If user hasn't been views, add uid to views list
        if (!array.contains(userId)) {
          await postRef.update({
            'views': FieldValue.arrayUnion([userId])
          });
        }
      }
    }
    catch (e) {
      print(e);
    }
  }
}
