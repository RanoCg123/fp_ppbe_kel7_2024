import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/controller/firebase_provider.dart';
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
  final firebaseProvider = FirebaseProvider();
  final user = FirebaseAuth.instance.currentUser!;
  final contentController = TextEditingController();
  final questionController = TextEditingController();

  void createPost() {
    postService.addPost(
      content: contentController.text,
      question: questionController.text,
      authorUid: user.uid,
    );
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
