import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/services/post_service.dart';
import 'package:fp_forum_kel7_ppbe/util/snackbar_util.dart';

import '../models/post_model.dart';
import '../widgets/create_post_button.dart';
import '../widgets/create_post_textfield.dart';

class EditPostPage extends StatefulWidget {
  final Post post;

  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  final topicController = TextEditingController();
  final questionController = TextEditingController();
  final contentController = TextEditingController();
  final postService = PostService();

  void editPost() {
    try {
      final data = {
        'topic': topicController.text,
        'question': questionController.text,
        'content': contentController.text,
      };
      postService.updatePost(widget.post.id, data);
      Navigator.pop(context, data);
      showSnackBar(context, "You have edit this post", type: "success");
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    topicController.text = widget.post.topic;
    questionController.text = widget.post.question;
    contentController.text = widget.post.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit post"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              const Text(
                "Topic",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              // question text field
              CreatePostTextField(
                controller: topicController,
                hintText: 'Enter your discussion\'s topic ...',
                obscureText: false,
                maxLine: 1,
              ),

              const SizedBox(height: 25),

              const Text(
                "Title",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              // question text field
              CreatePostTextField(
                controller: questionController,
                hintText: 'Enter your discussion\'s title ...',
                obscureText: false,
                maxLine: 1,
              ),

              const SizedBox(height: 25),

              const Text(
                "Content",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),

              // content text field
              CreatePostTextField(
                controller: contentController,
                hintText: 'Enter the details of your posts ...',
                obscureText: false,
                maxLine: 10,
              ),

              const SizedBox(height: 50),

              // sign in button
              CreatePostButton(
                "Edit Posts",
                onTap: editPost,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
