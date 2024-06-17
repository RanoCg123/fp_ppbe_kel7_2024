import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/author_model.dart';
import '../models/replies_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> likeReply(String postId, String replyId, String userId) async {
    final replyRef = _db.collection('posts').doc(postId).collection('replies').doc(replyId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(replyRef);
      if (!snapshot.exists) {
        throw Exception("Reply does not exist!");
      }

      final likedBy = List<String>.from(snapshot.data()!['likedBy'] ?? []);
      if (!likedBy.contains(userId)) {
        likedBy.add(userId);
        transaction.update(replyRef, {
          'likes': snapshot.data()!['likes'] + 1,
          'likedBy': likedBy,
        });
      }
    });
  }

  Future<void> unlikeReply(String postId, String replyId, String userId) async {
    final replyRef = _db.collection('posts').doc(postId).collection('replies').doc(replyId);

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(replyRef);
      if (!snapshot.exists) {
        throw Exception("Reply does not exist!");
      }

      final likedBy = List<String>.from(snapshot.data()!['likedBy'] ?? []);
      if (likedBy.contains(userId)) {
        likedBy.remove(userId);
        transaction.update(replyRef, {
          'likes': snapshot.data()!['likes'] - 1,
          'likedBy': likedBy,
        });
      }
    });
  }

  Future<Author?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        return Author(
          name: doc['name'],
          image: doc['image'],
          uid: doc['uid'],
          email: doc['email'],
        );
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null;
  }


  Future<String> addReply(String questionId, Reply reply) async {
    try {
      DocumentReference docRef = _db
          .collection('posts')
          .doc(questionId)
          .collection('replies')
          .doc();
      reply.id = docRef.id; // Set the generated ID to the reply object
      await docRef.set({
        'id': reply.id,
        'author': {
          'name': reply.author.name,
          'image': reply.author.image,
          'uid': reply.author.uid,
          'email': reply.author.email,
        },
        'content': reply.content,
        'created_at': reply.created_at,
        'likes': reply.likes,
      });
      await _db.collection('posts').doc(questionId).update({
        'repliesCount': FieldValue.increment(1),
      });
      return reply.id;
    } catch (e) {
      print('Error adding reply: $e');
      throw e; // Throw the error to be caught in the calling function
    }
  }

  Future<void> updateReply(String questionId, String replyId, Reply reply) async {
    await _db
        .collection('posts')
        .doc(questionId)
        .collection('replies')
        .doc(replyId)
        .update(reply.toMap());
  }


  Future<void> deleteReply(String questionId, String replyId) async {
    try {
      await _db.collection('posts')
          .doc(questionId)
          .collection('replies')
          .doc(replyId).delete();
      await _db.collection('posts').doc(questionId).update({
        'repliesCount': FieldValue.increment(-1),
      });
    } catch (e) {
      print('Error deleting reply: $e');
      throw e; // throw error untuk ditangkap di tempat pemanggilan
    }
  }

  Future<List<Reply>> getReplies(String questionId) async {
    var snapshot = await _db
        .collection('posts')
        .doc(questionId)
        .collection('replies')
        .orderBy('created_at')
        .get();

    return snapshot.docs.map((doc) => Reply.fromMap(doc.data())).toList();
  }

  updateReplyLikes(String id, String id2, int i) {}

}
