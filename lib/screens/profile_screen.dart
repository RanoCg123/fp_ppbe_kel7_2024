import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/my_post_screen.dart';

import 'bookmark_screen.dart';

import '../models/author_model.dart';
import '../widgets/top_bar.dart';
import '../controller/firebase_provider.dart';
import '../models/author_model.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  void fetchCurrentUser() async {
    FirebaseProvider userProvider = FirebaseProvider();
    var currentUser = await userProvider.getCurrentUser();
    if (currentUser != null) {
      print('Current user: ${currentUser.name}');
    } else {
      print('No user logged in');
    }
  }
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
      child: ListView(
        children: <Widget>[
          Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        onPressed: signUserOut,
                        icon: Icon(Icons.logout, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(user.photoURL ?? ''),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName ?? 'User Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            user.email ?? '',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(35.0),
                topRight: Radius.circular(35.0),
              ),
            ),
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
    );
  }
}