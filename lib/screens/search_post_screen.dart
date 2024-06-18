import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/widgets/dropdown_topic_widget.dart';
import '../services/post_service.dart';
import '../widgets/own_post_widget.dart';

import '../models/post_model.dart';

class SearchPostPage extends StatefulWidget {
  final String searched;
  final String topic;

  const SearchPostPage(
      {super.key, required this.searched, required this.topic});

  @override
  State<SearchPostPage> createState() => _SearchPostPageState();
}

class _SearchPostPageState extends State<SearchPostPage> {
  List<Post> myPosts = [];
  List<String> topics = [""];
  PostService postService = PostService();
  final user = FirebaseAuth.instance.currentUser!;
  TextEditingController searchController = TextEditingController();
  String searched = "";
  String topicSelected = "";

  void selectTopics(String topic) {
    topicSelected = topic;
    getSearchedPosts();
  }

  void searchPost(String text) {
    searched = text;
    getSearchedPosts();
  }

  void getSearchedPosts() async {
    final List<Post> posts;
    if (topicSelected == "") {
      posts = await postService.getPosts(
        content: searched,
        title: searched,
        orderBy: "created_at",
        descending: true,
      );
    } else {
      posts = await postService.getPosts(
        topic: topicSelected,
        content: searched,
        title: searched,
        orderBy: "created_at",
        descending: true,
      );
    }


    setState(() {
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
    searched = widget.searched;
    topicSelected = widget.topic;
    searchController.text = searched;
    getSearchedPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Posts",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 15.0,
                  ),
                  child: SearchBar(
                    padding: WidgetStateProperty.all(EdgeInsets.all(10.0)),
                    onSubmitted: (text) => searchPost(text),
                    controller: searchController,
                    hintText: "Search posts",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Topic",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      DropdownTopicWidget(
                        changeTopic: selectTopics,
                        defaultTopic: topicSelected,
                      ),
                    ],
                  ),
                ),
              ] +
              myPosts
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
