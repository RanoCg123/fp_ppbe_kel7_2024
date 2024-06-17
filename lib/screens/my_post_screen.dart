import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/post_service.dart';
import '../widgets/own_post_widget.dart';

import '../models/post_model.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({super.key});

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  List<Post> myPosts = [];
  PostService postService = PostService();
  final user = FirebaseAuth.instance.currentUser!;
  bool isLoaded = true;

  void getPosts() async {
    setState(() {
      isLoaded = true;
    });

    final posts = await postService.getPosts(authorId: user.uid);

    setState(() {
      isLoaded = false;
      myPosts = posts;
    });
  }

  void removePostFromList(Post post) {
    setState(() {
      myPosts.remove(post);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Post",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoaded
            ? const Center(child: CircularProgressIndicator(),)
            : ListView(
                children: myPosts
                    .map((post) => OwnPostWidget(
                          post: post,
                          removeFromList: removePostFromList,
                        ))
                    .toList(),
              ),
      ),
    );
  }
}
