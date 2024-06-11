import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/models/author_model.dart';
import 'package:fp_forum_kel7_ppbe/models/post_model.dart';
import 'package:fp_forum_kel7_ppbe/widgets/my_button.dart';

import '../services/post_service.dart';
import '../widgets/text_field.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final postService = PostService();
  final contentController = TextEditingController();
  final questionController = TextEditingController();

  void createPost() {
    Question question = Question(
      question: questionController.text,
      content: contentController.text,
      votes: 120,
      repliesCount: 80,
      views: 200,
      created_at: "1 hour ago",
      author: Author(uid: "", name: "Mark", email: "", image: ""),
      replies: [],
    );

    postService.addPost(question);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50),

          // welcome back, you've been missed!
          Text(
            'Posts',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 32,
            ),
          ),

          const SizedBox(height: 25),

          // email textfield
          MyTextField(
            controller: questionController,
            hintText: 'question',
            obscureText: false,
          ),

          const SizedBox(height: 10),

          // password textfield
          MyTextField(
            controller: contentController,
            hintText: 'content',
            obscureText: false,
          ),

          const SizedBox(height: 50),

          // sign in button
          MyButton(
            "Create Posts",
            onTap: createPost,
          ),
        ],
      ),
    );
  }
}
