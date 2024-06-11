import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/replies_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addReply(String questionId, Reply reply) async {
    await _db.collection('replies').doc(reply.id).set({
      ...reply.toMap(),
      'questionId': questionId,
    });
  }

  Future<void> updateReply(String replyId, Reply reply) async {
    await _db.collection('replies').doc(replyId).update(reply.toMap());
  }

  Future<void> deleteReply(String replyId) async {
    await _db.collection('replies').doc(replyId).delete();
  }

  Future<List<Reply>> getReplies(String questionId) async {
    var snapshot = await _db
        .collection('replies')
        .where('questionId', isEqualTo: questionId)
        .orderBy('created_at')
        .get();

    return snapshot.docs.map((doc) => Reply.fromMap(doc.data())).toList();
  }
}
