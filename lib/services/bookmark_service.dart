import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fp_forum_kel7_ppbe/models/post_model.dart';
import 'package:fp_forum_kel7_ppbe/services/post_service.dart';

class BookmarkService {
  // get collection of notes
  final CollectionReference users =
    FirebaseFirestore.instance.collection("users");

  Future<List<Post>> getBookmarkedPost(String userId) async {
    List<Post> bookmarkedPost = [];
    final postService = PostService();

    QuerySnapshot bookmarkQuery = await users.doc(userId).collection("bookmark").get();

    for (final doc in bookmarkQuery.docs) {
      final data = doc.data() as Map<String, dynamic>;
      Post? post = await postService.getPostById(data['post']);
      if (post != null) {
        bookmarkedPost.add(post);
      }
    }

    return bookmarkedPost;
  }

  Future<List<String>> getBookmarkedPostId(String userId) async {
    List<String> bookmarkedPostId = [];
    final postService = PostService();

    QuerySnapshot bookmarkQuery = await users.doc(userId).collection("bookmark").get();

    for (final doc in bookmarkQuery.docs) {
      final data = doc.data() as Map<String, dynamic>;
      bookmarkedPostId.add(data['post']);
    }

    return bookmarkedPostId;
  }

  Future<bool> isPostBookmarked({required String userId, required String postId}) async {
    final postBookmarkSnapshot =
      await users.doc(userId).collection("bookmark").where("post", isEqualTo: postId).get();

    return postBookmarkSnapshot.docs.isNotEmpty;
  }

  Future<void> bookmarkPost({required String userId, required String postId}) async {
    final bookmarksRef = users.doc(userId).collection("bookmark");

    isPostBookmarked(userId: userId, postId: postId).then((isBookmarked) async {
      // if bookmarked, ...
      if (isBookmarked) {
        QuerySnapshot bookmarksSnapshot = await bookmarksRef.where('post', isEqualTo: postId).get();
        for (final doc in bookmarksSnapshot.docs) {
          doc.reference.delete();
        }
      }
      else {
        await bookmarksRef.add({'post': postId});
      }
    });
  }
}