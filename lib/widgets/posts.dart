import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/post_widget.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';
import '../util/snackbar_util.dart';
import '../util/modal_util.dart';

import '../models/author_model.dart';
import '../models/replies_model.dart';
import '../screens/post_screen.dart';

class Posts extends StatefulWidget {
  // final List<Post>? posts;
  // final Function() deletePost;

  const Posts({super.key});

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  List<Post>? posts;
  bool postLoaded = false;
  final postService = PostService();
  Post? selectedPost;
  final user = FirebaseAuth.instance.currentUser!;

  void getPosts() async {
    setState(() {
      postLoaded = false;
    });
    posts = await postService.getPosts();
    setState(() {
      postLoaded = true;
    });
  }

//   void deletePost() {
//     try {
//       postService.deletePost(selectedPost!.id);
//       setState(() {
//         posts!.remove(selectedPost!);
//       });
//       showSnackBar(context, 'You have delete this post' , type: "success");
//     } catch (e) {
//       showSnackBar(context, 'failed to delete post: $e', type: "warning");
//     }
//   }

//   void updatePost() {}

//   void bookmarkPost() {}

//   void showOptions(Post post) {
//     selectedPost = post;
//     List<Option> options;
//     if (selectedPost!.author.uid == user.uid) {
//       options = [
//         Option(text: "Edit post", icon: Icons.edit, handler: updatePost),
//         Option(text: "Delete post", icon: Icons.delete, handler: deletePost),
//       ];
//       showBottomOptionModal(context, options, 130.0);
//     } else {
//       options = [Option(
//         text: "Bookmark this post",
//         icon: Icons.bookmark,
//         handler: bookmarkPost,
//       ),];
//       showBottomOptionModal(context, options, 80.0);
//     }
//   }
//   void deletePost(String postId) {
//     postService.deletePost(postId);
//     getQuestions();
//   }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: !postLoaded
            ? [
                const Center(
                  child: CircularProgressIndicator(),
                )
              ]
            : posts!
                .map((post) => PostWidget(post: post,))
                .toList());
  }
}
