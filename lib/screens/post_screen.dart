import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/firebase_provider.dart';
import '../models/author_model.dart';
import '../models/post_model.dart';
import '../models/replies_model.dart';
import 'reply_screen.dart';
import '../services/reply_service.dart';

class PostScreen extends StatefulWidget {
  final Post question;

  PostScreen({required this.question});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  TextEditingController _replyController = TextEditingController();
  late FirestoreService _firestoreService;
  final user = FirebaseAuth.instance.currentUser!;
  List<Reply> _replies = [];

  @override
  void initState() {
    super.initState();
    _firestoreService = FirestoreService();
    _loadReplies();
  }

  void _loadReplies() async {
    List<Reply> replies = await _firestoreService.getReplies(widget.question.id);
    setState(() {
      _replies = replies;
    });
  }

  void _addReply() async {
    final newReply = Reply(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      // author: Author(
      //   name: 'Current User',
      //   image: 'assets/images/default_user.png',
      // ),
      author: FirebaseProvider().getUserById(user.uid)!,
      content: _replyController.text,
      created_at: DateTime.now().toIso8601String(),
      likes: 0,
    );
    await _firestoreService.addReply(widget.question.id, newReply);
    setState(() {
      _replies.add(newReply);
      _replyController.clear();
    });
  }

  void _editReply(Reply reply) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ReplyScreen(
          reply: reply,
          onSave: (updatedReply) async {
            await _firestoreService.updateReply(updatedReply.id, updatedReply);
            setState(() {
              int index = _replies.indexWhere((r) => r.id == updatedReply.id);
              if (index != -1) {
                _replies[index] = updatedReply;
              }
            });
            Navigator.pop(context);
          },
          onDelete: (deletedReply) async {
            await _firestoreService.deleteReply(deletedReply.id);
            setState(() {
              _replies.removeWhere((r) => r.id == deletedReply.id);
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Colors.black,
                      )),
                  SizedBox(width: 5.0),
                  Text(
                    "View Post",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26.withOpacity(0.05),
                      offset: Offset(0.0, 6.0),
                      blurRadius: 10.0,
                      spreadRadius: 0.10)
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 60,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: AssetImage(widget.question.author.image),
                                radius: 22,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        widget.question.author.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: .4),
                                      ),
                                    ),
                                    SizedBox(height: 2.0),
                                    Text(
                                      widget.question.created_at,
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              )
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
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        widget.question.question,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.black.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      widget.question.content,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 17,
                          letterSpacing: .2),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.thumb_up,
                                color: Colors.grey.withOpacity(0.5),
                                size: 22,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                "${widget.question.votes} votes",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: 15.0),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.visibility,
                                color: Colors.grey.withOpacity(0.5),
                                size: 18,
                              ),
                              SizedBox(width: 4.0),
                              Text(
                                "${widget.question.views} views",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 20.0, bottom: 10.0),
              child: Text(
                "Replies (${_replies.length})",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Column(
              children: _replies
                  .map((reply) => Container(
                margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black26.withOpacity(0.03),
                        offset: Offset(0.0, 6.0),
                        blurRadius: 10.0,
                        spreadRadius: 0.10)
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 60,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: AssetImage(reply.author.image),
                                  radius: 18,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        reply.author.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: .4,
                                        ),
                                      ),
                                      SizedBox(height: 2.0),
                                      Text(
                                        reply.created_at,
                                        style: TextStyle(
                                          color: Colors.grey.withOpacity(0.4),
                                        ),
                                      ),
                                    ],
//               children: widget.question.replies.map((reply) =>
//                 Container(
//                   margin: EdgeInsets.only(left:15.0, right: 15.0, top: 20.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10.0),
//                     boxShadow: [BoxShadow(
//                       color: Colors.black26.withOpacity(0.03),
//                       offset: Offset(0.0,6.0),
//                       blurRadius: 10.0,
//                       spreadRadius: 0.10
//                     )],
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(15.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Container(
//                           height: 60,
//                           color: Colors.white,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: <Widget>[
//                               Row(
//                                 children: <Widget>[
//                                   CircleAvatar(
//                                     backgroundImage: AssetImage(reply.author.image),
//                                     radius: 18,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                _editReply(reply);
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.grey.withOpacity(0.6),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          reply.content,
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.thumb_up,
                            color: Colors.grey.withOpacity(0.5),
                            size: 20,
                          ),
                          SizedBox(width: 5.0),
                          Text(
                            "${reply.likes}",
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ))
                  .toList(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add a Reply",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: "Write your reply here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: _addReply,
                    child: Text("Reply"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

