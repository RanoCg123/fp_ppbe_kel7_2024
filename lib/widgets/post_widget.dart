import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../screens/post_screen.dart';
import '../services/post_service.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final Function(Post) showOptions;

  const PostWidget({super.key, required this.post, required this.showOptions});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final postService = PostService();
  final user = FirebaseAuth.instance.currentUser!;
  Color color = Colors.black.withOpacity(0.6);
  Post? post;
  int? numVotes;

  void vote() async {
    List<String> votes = await postService.votePost(widget.post.id, user.uid);
    setState(() {
      post!.votes = votes;
    });
  }

  void goToPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostScreen(
          question: widget.post,
        ),
      ),
    );
  }

  void view() async {
    List<String> views = await postService.viewPost(widget.post.id, user.uid);

    setState(() {
      post!.views = views;
    });

    goToPost();
  }

  void bookmark() async {
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    if (post!.votes.contains(user.uid)) {
      color = Colors.blueAccent;
    } else {
      color = Colors.black.withOpacity(0.6);
    }
    numVotes = post!.votes.length;
    return GestureDetector(
      onTap: view,
      child: Container(
        height: 180,
        margin: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26.withOpacity(0.05),
                  offset: const Offset(0.0, 6.0),
                  blurRadius: 10.0,
                  spreadRadius: 0.10)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.post.author.image),
                          radius: 22,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: Text(
                                  widget.post.question,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: .4),
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.post.author.name,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6)),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    widget.post.created_at,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.6)),
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
                          widget.showOptions(widget.post);
                        },
                        // padding: EdgeInsets.all(0.0),
                        icon: const Icon(
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
              SizedBox(
                height: 50,
                child: Center(
                  child: Text(
                    widget.post.content.length > 80
                        ? "${widget.post.content.substring(0, 80)}.."
                        : widget.post.content,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.8),
                        fontSize: 16,
                        letterSpacing: .3),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  InkWell(
                    onTap: vote,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.arrow_upward,
                          color: color,
                          size: 22,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          "${numVotes} votes",
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
                        color: Colors.black.withOpacity(0.6),
                        size: 16,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        "${widget.post.repliesCount} replies",
                        style: TextStyle(
                            fontSize: 14, color: Colors.black.withOpacity(0.6)),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.visibility,
                        color: Colors.black.withOpacity(0.6),
                        size: 18,
                      ),
                      const SizedBox(width: 4.0),
                      Text(
                        "${widget.post.views.length} views",
                        style: TextStyle(
                            fontSize: 14, color: Colors.black.withOpacity(0.6)),
                      )
                    ],
                  ),
                  InkWell(
                    onTap: bookmark,
                    child: Icon(Icons.bookmark_border),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
