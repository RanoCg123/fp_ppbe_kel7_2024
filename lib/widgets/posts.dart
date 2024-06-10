import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/models/author_model.dart';
import 'package:fp_forum_kel7_ppbe/models/post_model.dart';
import 'package:fp_forum_kel7_ppbe/models/replies_model.dart';
import 'package:fp_forum_kel7_ppbe/screens/post_screen.dart';
import 'package:fp_forum_kel7_ppbe/services/post_service.dart';

class Posts extends StatefulWidget {
  final List<Question>? questions;

  const Posts(this.questions, {super.key});

  @override
  _PostsState createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  get questions => null;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.questions!
            .map((question) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => PostScreen(
                                  question: question,
                                )));
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage(question.author.imageUrl),
                                      radius: 22,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
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
                                              question.question,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: .4),
                                            ),
                                          ),
                                          SizedBox(height: 2.0),
                                          Row(
                                            children: <Widget>[
                                              Text(
                                                question.author.name,
                                                style: TextStyle(
                                                    color: Colors.grey
                                                        .withOpacity(0.6)),
                                              ),
                                              SizedBox(width: 15),
                                              Text(
                                                question.created_at,
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
                                Icon(
                                  Icons.bookmark,
                                  color: Colors.grey.withOpacity(0.6),
                                  size: 26,
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                question.content.length > 80
                                    ? "${question.content.substring(0, 80)}.."
                                    : "${question.content}",
                                style: TextStyle(
                                    color: Colors.grey.withOpacity(0.8),
                                    fontSize: 16,
                                    letterSpacing: .3),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.thumb_up,
                                    color: Colors.grey.withOpacity(0.6),
                                    size: 22,
                                  ),
                                  SizedBox(width: 4.0),
                                  Text(
                                    "${question.votes} votes",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.withOpacity(0.6),
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
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
                                    "${question.repliesCount} replies",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.withOpacity(0.6)),
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
                                    "${question.views} views",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.withOpacity(0.6)),
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
