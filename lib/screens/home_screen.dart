import 'package:flutter/material.dart';
import '../widgets/popular_topics.dart';
import '../widgets/posts.dart';
import '../widgets/top_bar.dart';
import '../widgets/popular_topics.dart';
import '../widgets/posts.dart';
import '../widgets/top_bar.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currIndex = 0;
  List<Post>? questions;
  bool questionLoaded = false;
  final postService = PostService();

  void getQuestions() async {
    setState(() {
      questionLoaded = false;
    });
    questions = await postService.getPosts();
    setState(() {
      questionLoaded = true;
    });
  }

  void deletePost(String postId) {
    postService.deletePost(postId);
    getQuestions();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuestions();
  }

  // final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  // void signUserOut() {
  //   FirebaseAuth.instance.signOut();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: <Widget>[
          Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Sra, Forum",
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Find Topics you like to read",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14.0,
                        ),
                      ),
                      Icon(
                        Icons.search,
                        size: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currIndex,
//         onTap: (index) {
//           setState(() {
//             currIndex = index;
//           });
//         },
//         items: [
//           BottomNavigationBarItem(
//             icon: IconButton(
//               onPressed: signUserOut,
//               icon: Icon(Icons.home),
//             ),
//             label: 'Home',
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TopBar(),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Popular Topics",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                PopularTopics(),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 10.0),
                  child: Text(
                    "Trending Posts",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Posts()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
