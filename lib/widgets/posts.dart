import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/util/dialog_util.dart';
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
  Color color = Colors.grey.withOpacity(0.6);

  void vote() {
    setState(() {
      color == Colors.grey.withOpacity(0.6)
          ? color = Colors.blueAccent
          : color = Colors.grey.withOpacity(0.6);
    });
  }

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
          handler: bookmarkPost)
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
                .map((post) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PostScreen(
                              question: post,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 180,
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26.withOpacity(0.05),
                                  offset: Offset(0.0, 6.0),
                                  blurRadius: 10.0,
                                  spreadRadius: 0.10)
                            ]),
                        child: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                height: 70,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(post.author.image),
                                          radius: 22,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.65,
                                                child: Text(
                                                  post.question,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: .4),
                                                ),
                                              ),
                                              SizedBox(height: 2.0),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    post.author.name,
                                                    style: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.6)),
                                                  ),
                                                  SizedBox(width: 15),
                                                  Text(
                                                    post.created_at,
                                                    style: TextStyle(
                                                        color: Colors.grey
                                                            .withOpacity(0.6)),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: IconButton(
                                        onPressed: () {
                                          showOptions(post);
                                        },
                                        // padding: EdgeInsets.all(0.0),
                                        icon: Icon(
                                          // Icons.delete,
                                          Icons.more_vert,
                                          size: 26,
                                        ),
                                      ),
                                    ),
                                    // Icon(
                                    //   Icons.delete,
                                    //   color: Colors.grey.withOpacity(0.6),
                                    //   size: 26,
                                    // )
                                  ],
                                ),
                              ),
                              Container(
                                height: 50,
                                child: Center(
                                  child: Text(
                                    post.content.length > 80
                                        ? "${post.content.substring(0, 80)}.."
                                        : "${post.content}",
                                    style: TextStyle(
                                        color: Colors.grey.withOpacity(0.8),
                                        fontSize: 16,
                                        letterSpacing: .3),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                    onTap: vote,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.arrow_upward,
                                          color: color,
                                          size: 22,
                                        ),
                                        SizedBox(width: 4.0),
                                        Text(
                                          "${post.votes.length} votes",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: color,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.email,
                                        color: Colors.grey.withOpacity(0.6),
                                        size: 16,
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        "${post.repliesCount} replies",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.grey.withOpacity(0.6)),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.visibility,
                                        color: Colors.grey.withOpacity(0.6),
                                        size: 18,
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                        "${post.views.length} views",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Colors.grey.withOpacity(0.6)),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
                .toList());
  }
}
