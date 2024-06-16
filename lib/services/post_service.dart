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
    required String authorUid,
  }) async {
    DocumentReference postReference = await posts.add({
      "author": authorUid,
      "content": content,
      "created_at": DateTime.now(),
      "question": question,
      "repliesCount": 0,
      "views": 0,
      "votes": 0,
    });

    DocumentSnapshot doc = await postReference.get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // get the data of author
    var postAuthorDoc = await users.doc(data['author']).get();
    Map<String, dynamic> postAuthorData = postAuthorDoc.data() as Map<String, dynamic>;
    final postAuthor = Author.fromJson(postAuthorData);

    // get the number of replies
    var repliesSnapshot = await posts.doc(doc.id).collection('replies').get();
    var repliesCount = repliesSnapshot.docs.length;

    // convert timestamp to datetime
    Timestamp timestamp = data['created_at'];
    DateTime createdAt = timestamp.toDate();

    final post = Post(
      id: doc.id,
      question: data['question'],
      content: data['content'],
      votes: data['votes'],
      repliesCount: repliesCount,
      views: data['views'],
      created_at: DateFormat('dd-MM-yyyy').format(createdAt),
      author: postAuthor,
      replies: [],
    );

    return post;
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
}
