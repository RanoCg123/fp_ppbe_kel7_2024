import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/util/dialog_util.dart';
import '../controller/firebase_provider.dart';
import '../models/post_model.dart';
import '../widgets/create_post_button.dart';
import '../screens/post_screen.dart';

import '../services/post_service.dart';
import '../widgets/create_post_textfield.dart';
import '../util/snackbar_util.dart';

class CreatePostPage extends StatefulWidget {
  final Function() setToHome;

  const CreatePostPage({super.key, required this.setToHome});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final postService = PostService();
  final firebaseProvider = FirebaseProvider();
  final user = FirebaseAuth.instance.currentUser!;
  final contentController = TextEditingController();
  final questionController = TextEditingController();
  final topicController = TextEditingController();

  void goToCreatedPost(Post post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PostScreen(
          question: post,
        ),
      ),
    );
  }

  void createPost() async {
    if (topicController.text == "") {
      showSnackBar(
        context,
        "Post\'s topic must be filled",
        type: "warning",
      );
    } else if (questionController.text == "") {
      showSnackBar(
        context,
        "Post\'s title must be filled",
        type: "warning",
      );
    } else if (contentController.text == "") {
      showSnackBar(
        context,
        "Post\'s content must be filled",
        type: "warning",
      );
    } else {
      try {
        // showSuccessDialog(context, "content");
        showSnackBar(
          context,
          "Success to create post",
          type: "success",
        );
        final post = await postService.addPost(
          content: contentController.text,
          question: questionController.text,
          topic: topicController.text.toLowerCase(),
          authorId: user.uid,
        );

        contentController.text = "";
        questionController.text = "";
        topicController.text = "";

        widget.setToHome();
        goToCreatedPost(post);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // welcome back, you've been missed!
            const Center(
              child: Text(
                'New Posts',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                ),
              ),
            ),

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
              "Create Posts",
              onTap: createPost,
            ),
          ],
        ),
      ),
    );
  }
}
