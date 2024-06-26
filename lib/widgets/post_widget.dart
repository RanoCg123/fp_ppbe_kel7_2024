import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/bookmark_service.dart';

import '../models/post_model.dart';
import '../screens/post_screen.dart';
import '../services/post_service.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final postService = PostService();
  final bookmarkService = BookmarkService();
  final user = FirebaseAuth.instance.currentUser!;
  Color voteButtonColor = Colors.black.withOpacity(0.6);
  IconData bookmarkIcon = Icons.bookmark_border;
  Post? post;
  List<String> bookmarkedPostId = [];
  int? numVotes;
  int? repliesCount;

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

  void fetchRepliesCount() async {
    int count = await postService.getRepliesCount(widget.post.id);
    setState(() {
      repliesCount = count;
    });
  }
  void bookmark() async {
    bookmarkService.bookmarkPost(
      userId: user.uid,
      postId: post!.id,
    );
    setState(() {
      if (bookmarkedPostId.contains(post!.id)) {
        bookmarkedPostId.remove(post!.id);
      } else {
        bookmarkedPostId.add(post!.id);
      }
    });
  }

  void getBookmarked() async {
    final posts = await bookmarkService.getBookmarkedPostId(user.uid);
    setState(() {
      bookmarkedPostId = posts;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBookmarked();
    fetchRepliesCount();
    post = widget.post;
  }

  @override
  Widget build(BuildContext context) {
    if (post!.votes.contains(user.uid)) {
      voteButtonColor = Colors.blueAccent;
    } else {
      voteButtonColor = Colors.black.withOpacity(0.6);
    }

    if (bookmarkedPostId.contains(post!.id)) {
      bookmarkIcon = Icons.bookmark;
    } else {
      bookmarkIcon = Icons.bookmark_border;
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
                          color: voteButtonColor,
                          size: 22,
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          "$numVotes votes",
                          style: TextStyle(
                            fontSize: 14,
                            color: voteButtonColor,
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
                        "$repliesCount replies",
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
                    child: Icon(bookmarkIcon),
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
