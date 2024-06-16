import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/util/dialog_util.dart';
import 'package:fp_forum_kel7_ppbe/widgets/post_widget.dart';
import '../models/author_model.dart';
import '../models/post_model.dart';
import '../models/replies_model.dart';
import '../screens/post_screen.dart';
import '../services/post_service.dart';
import '../util/snackbar_util.dart';
import '../util/modal_util.dart';

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

  void deletePost() {
    try {
      postService.deletePost(selectedPost!.id);
      setState(() {
        posts!.remove(selectedPost!);
      });
    } catch (e) {
      showSnackBar(context, 'failed to delete post: $e');
    }
  }

  void updatePost() {}

  void bookmarkPost() {}

  void showOptions(Post post) {
    selectedPost = post;
    List<Option> options = [
      Option(text: "Edit this post", icon: Icons.edit, handler: updatePost),
      Option(text: "Delete this post", icon: Icons.delete, handler: deletePost),
      Option(
        text: "Bookmark this post",
        icon: Icons.bookmark,
        handler: bookmarkPost,
      ),
    ];
    showBottomOptionModal(context, options, 180.0);
  }

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
                .map((post) => PostWidget(
                      post: post,
                      showOptions: showOptions,
                    ))
                .toList());
  }
}
