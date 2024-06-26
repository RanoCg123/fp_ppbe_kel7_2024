import 'package:cloud_firestore/cloud_firestore.dart';
import '../controller/firebase_provider.dart';
import '../models/author_model.dart';
import '../models/post_model.dart';
import '../models/replies_model.dart';
import 'package:intl/intl.dart';

import '../models/topic_model.dart';

class PostService {
  // get collection of notes
  final CollectionReference posts =
  FirebaseFirestore.instance.collection("posts");

  // get collection of notes
  final CollectionReference topics =
  FirebaseFirestore.instance.collection("topics");

  // get collection of users
  final CollectionReference users =
  FirebaseFirestore.instance.collection("users");

  // CREATE: new note
  Future<Post> addPost({
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
      "numVotes": 0,
    });

    // add or set topic
    QuerySnapshot topicSnapshot =
        await topics.where('name', isEqualTo: topic).get();
    if (topicSnapshot.docs.isEmpty) {
      topics.add({
        "name": topic,
        'num': 1,
      });
    } else {
      for (final doc in topicSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        doc.reference.update({
          "num": data["num"] + 1,
        });
      }
    }

    var postAuthor = await users.doc(authorId).get();
    var postAuthorData =
        Author.fromJson(postAuthor.data() as Map<String, dynamic>);

    return Post(
      id: postReference.id,
      question: question,
      content: content,
      topic: topic,
      votes: [],
      numVotes: 0,
      repliesCount: 0,
      views: [],
      created_at: DateFormat('dd-MM-yyyy').format(now),
      author: postAuthorData,
      replies: [],
    );
  }

  // get post
  Future<List<Post>> getPosts({
    final String? authorId,
    final String? topic,
    final String? title,
    final String? content,
    final int? limit,
    final String? orderBy,
    final bool descending = true,
  }) async {
    try {
      List<Post> questions = [];
      Query query = posts;

      if (authorId != null) {
        query = query.where("author", isEqualTo: authorId);
      }
      if (topic != null) {
        query = query.where("topic", isEqualTo: topic);
      }
      if (orderBy != null) {
        query = query.orderBy(orderBy, descending: descending);
      }
      if (limit != null) {
        query = query.limit(limit);
      }

      await query.get().then((event) async {
        for (var doc in event.docs) {
          var data = doc.data() as Map<String, dynamic>;

          // add if the title and content suitable
          if (suitedWithSearch(title, data["question"]) ||
              suitedWithSearch(content, data["content"])) {
            // get the data of author
            var postAuthorDoc = await users.doc(data['author']).get();
            Map<String, dynamic> postAuthorData =
                postAuthorDoc.data() as Map<String, dynamic>;
            final postAuthor = Author.fromJson(postAuthorData);

            // convert timestamp to datetime
            Timestamp timestamp = data['created_at'];
            DateTime createdAt = timestamp.toDate();


            if(data['numVotes'] == null) {
              print("numvotes null");
            }
            if(data['repliesCount'] == null) {
              print('repliescount null');
            }

            questions.add(Post(
              id: doc.id,
              question: data['question'],
              content: data['content'],
              topic: data['topic'],
              votes: List<String>.from(data['votes']),
              numVotes: data['numVotes'],
              repliesCount: data['repliesCount'],
              views: List<String>.from(data['views']),
              created_at: DateFormat('dd-MM-yyyy').format(createdAt),
              author: postAuthor,
              replies: [],
            ));
            print("end");
          }
        }
      });

      return questions;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  Future<Post?> getPostById(String postId) async {
    DocumentSnapshot postSnapshot = await posts.doc(postId).get();

    if (postSnapshot.exists) {
      final data = postSnapshot.data() as Map<String, dynamic>;

      // get the data of author
      var postAuthorDoc = await users.doc(data['author']).get();
      Map<String, dynamic> postAuthorData =
      postAuthorDoc.data() as Map<String, dynamic>;
      final postAuthor = Author.fromJson(postAuthorData);

      // convert timestamp to datetime
      Timestamp timestamp = data['created_at'];
      DateTime createdAt = timestamp.toDate();

      return Post(
        id: postSnapshot.id,
        question: data['question'],
        content: data['content'],
        topic: data['topic'],
        votes: List<String>.from(data['votes']),
        numVotes: data['numVotes'],
        repliesCount: data['repliesCount'],
        views: List<String>.from(data['views']),
        created_at: DateFormat('dd-MM-yyyy').format(createdAt),
        author: postAuthor,
        replies: [],
      );
    } else {
      return null;
    }
  }

  Future<void> updatePost(String postId, Map<String, dynamic> data) async {
    final post = await getPostById(postId);

    await posts.doc(postId).update(data);

    if (post != null && post.topic != data["topic"]) {
      final oldTopic = post.topic;
      final newTopic = data["topic"];

      if (oldTopic != newTopic) {
        // decrease old topic count
        QuerySnapshot topicSnapshot =
          await topics.where('name', isEqualTo: post.topic).get();
        if (topicSnapshot.docs.isNotEmpty) {
          for (final doc in topicSnapshot.docs) {
            final topicData = doc.data() as Map<String, dynamic>;

            doc.reference.update({
              "num": topicData["num"] - 1,
            });
          }
        }

        // increase new topic count
        topicSnapshot =
          await topics.where('name', isEqualTo: data["topic"]).get();
        if (topicSnapshot.docs.isNotEmpty) {
          for (final doc in topicSnapshot.docs) {
            final topicData = doc.data() as Map<String, dynamic>;

            doc.reference.update({
              "num": topicData["num"] + 1,
            });
          }
        }
      }
    }
  }

  Future<void> deletePost(String postId) async {
    final post = await getPostById(postId);
    if (post != null) {
      await posts.doc(post.id).delete();

      // decrease topic count
      QuerySnapshot topicSnapshot =
        await topics.where('name', isEqualTo: post.topic).get();
      if (topicSnapshot.docs.isNotEmpty) {
        for (final doc in topicSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          doc.reference.update({
            "num": data["num"] - 1,
          });
        }
      }
    }
  }

  Future<List<String>> votePost(String postId, String userId) async {
    try {
      DocumentReference postRef = posts.doc(postId);

      // Fetch the document
      DocumentSnapshot postSnapshot = await postRef.get();

      if (postSnapshot.exists) {
        // Get the current array
        List<dynamic> array = postSnapshot.get('votes');

        // Check if user has been vote the post
        if (array.contains(userId)) {
          array.remove(userId);

          // Un vote the post
          await postRef.update({
            'votes': FieldValue.arrayRemove([userId]),
            'numVotes': array.length,
          });

          return List<String>.from(array);
        }
        // user hasn't been vote the post
        else {
          array.add(userId);

          // Vote the post
          await postRef.update({
            'votes': FieldValue.arrayUnion([userId]),
            'numVotes': array.length,
          });

          return List<String>.from(array);
        }
      }

      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<String>> viewPost(String postId, String userId) async {
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

          array.add(userId);
        }

        return List<String>.from(array);
      } else {
        print("Post doesn't exist");
        return [];
      }
    } catch (e) {
      print("Error: $e\n\n\n\n\n");
      return [];
    }
  }

  Future<List<Topic>> getPopularTopic(int num) async {
    try {
      List<Topic> popularTopics = [];

      QuerySnapshot querySnapshot =
          await topics.orderBy('num', descending: true).limit(num).get();

      for (final doc in querySnapshot.docs) {
        final topic = doc.data() as Map<String, dynamic>;

        if (topic['num'] <= 0) {
          break;
        }

        popularTopics.add(Topic.fromMap(topic));
      }

      return popularTopics;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<String>> getTopics() async {
    try {
      List<String> popularTopics = [];

      QuerySnapshot querySnapshot =
        await topics.orderBy('num', descending: true).get();

      for (final doc in querySnapshot.docs) {
        final topic = doc.data() as Map<String, dynamic>;
        final String topicName = topic['name'].toString();

        popularTopics.add(topicName);
      }

      return popularTopics;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // utility function
  //
  bool suitedWithSearch(String? searched, String data) {
    if (searched == null) {
      return true;
    } else if (data.toLowerCase().contains(searched.toLowerCase())) {
      return true;
    } else {
      return false;
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> updateRepliesCount(String postId, int newRepliesCount) async {
    try {
      await posts.doc(postId).update({
        'repliesCount': newRepliesCount,
      });
    } catch (e) {
      print('Error updating repliesCount: $e');
    }
  }

  Future<int> getRepliesCount(String postId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('replies')
          .get();
      return snapshot.size;
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
