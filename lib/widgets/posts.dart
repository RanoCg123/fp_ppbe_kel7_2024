import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/widgets/post_widget.dart';
import '../models/post_model.dart';
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
