import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/screens/my_post_screen.dart';

import 'bookmark_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;

  // sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void goToMyPost() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MyPostPage(),
      ),
    );
  }

  void goToBookmark() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookmarkPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            IconButton(
              onPressed: signUserOut,
              icon: const Icon(Icons.logout),
            ),
            TextButton(
              onPressed: goToMyPost,
              child: Text("My Posts"),
            ),
            TextButton(
              onPressed: goToBookmark,
              child: Text("Bookmark"),
            ),
          ],
        ),
      ),
    );
  }
}
