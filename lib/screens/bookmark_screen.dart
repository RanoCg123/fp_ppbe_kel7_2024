import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/services/bookmark_service.dart';
import 'package:fp_forum_kel7_ppbe/widgets/own_post_widget.dart';
import 'package:fp_forum_kel7_ppbe/widgets/post_widget.dart';

import '../models/post_model.dart';
import '../services/post_service.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  List<Post> bookmarkPosts = [];
  BookmarkService bookmarkService = BookmarkService();
  final user = FirebaseAuth.instance.currentUser!;
  bool isLoaded = true;

  void getPosts() async {
    setState(() {
      isLoaded = true;
    });

    final posts = await bookmarkService.getBookmarkedPost(user.uid);

    setState(() {
      isLoaded = false;
      bookmarkPosts = posts;
    });
  }

  void removePostFromList(Post post) {
    setState(() {
      bookmarkPosts.remove(post);
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
          "Bookmark Post",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoaded
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: bookmarkPosts.map((post) {
                  if (post.author.uid == user.uid) {
                    return OwnPostWidget(
                        post: post, removeFromList: removePostFromList);
                  } else {
                    return PostWidget(post: post);
                  }
                }).toList(),
              ),
      ),
    );
  }
}
