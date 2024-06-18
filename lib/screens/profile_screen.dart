import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/my_post_screen.dart';
import 'bookmark_screen.dart';
import '../models/author_model.dart';
import '../widgets/top_bar.dart';
import '../controller/firebase_provider.dart';
import '/screens/auth.dart';
import 'package:provider/provider.dart';
import '../controller/media_service.dart';
import '../widgets/my_textfield.dart';
import '../widgets/my_button.dart';
import 'package:flutter/services.dart';
import '../controller/firebase_firestore_service.dart';
import '../controller/firebase_storage_service.dart';
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  // text editing controllers
  final nameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Uint8List? file;
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
    final firebaseProvider = Provider.of<FirebaseProvider>(context, listen: false);
    Author? author = firebaseProvider.getUserById(user.uid);
    return Scaffold(
      body: SafeArea(
        child: Center(
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
                            backgroundImage: NetworkImage(author!.image),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                author.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                author.email,
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
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MyButton(
                    'My Posts',
                  onTap: goToMyPost,
                ),
                  MyButton(
                    'My Bookmarks',
                    onTap: goToBookmark,
                  ),
                  ]
              ),
              const SizedBox(height: 50),
              Form(
                    key: formKey,
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              GestureDetector(
              onTap: () async {
              final pickedImage =
              await MediaService.pickImage();
              setState(() => file = pickedImage!);
              },
              child: file != null
              ? CircleAvatar(
              radius: 50,
              backgroundImage: MemoryImage(file!),
              )
                  : CircleAvatar(
              radius: 50,
                backgroundImage: NetworkImage(author!.image),
              ),
              ),
                const SizedBox(height: 50),
                Text(
                  'Edit your account!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: nameController,
                  hintText: author.name,
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: currentPasswordController,
                  hintText: 'Current Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: newPasswordController,
                  hintText: 'New Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm New Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                MyButton(
                'Update Profile',
                onTap: () async {
                  try {
                    if (formKey.currentState!.validate()) {
                      String name = nameController.text.trim();
                      String currentPassword = currentPasswordController.text
                          .trim();
                      String newPassword = newPasswordController.text.trim();
                      String confirmPassword = confirmPasswordController.text
                          .trim();
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.email!, password: currentPassword);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                      if (newPassword == confirmPassword) {
                        String? imageUrl;
                        if (file != null) {
                          imageUrl = await FirebaseStorageService.uploadImage(
                              file!, 'image/profile/${user.uid}');
                        }else{
                          imageUrl = author.image;
                        }
                        if (name.isEmpty) {
                         name = author.name;
                        }
                        await FirebaseFirestoreService.updateUser(
                          uid: user.uid,
                          name: name,
                          image: imageUrl,
                        );
                        if (currentPassword.isNotEmpty &&
                            newPassword.isNotEmpty && (newPassword == confirmPassword) && confirmPassword.isNotEmpty ) {
                          await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
                        }

                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    // pop the loading circle
                    Navigator.pop(context);
                    showErrorMessage(e.code);

                  }
                }
                ),
                const SizedBox(height: 25),
                MyButton(
                  'Delete Account',
                  onTap: () async {

                    bool confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirm Delete'),
                        content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel'),
                            style: TextButton.styleFrom(
                              foregroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirm) {
                      try {
                        if(currentPasswordController.text.isEmpty){
                          return showErrorMessage('input current password');
                        }
                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: user.email!, password: currentPasswordController.text);
                        await FirebaseFirestoreService.deleteUser(user.uid);
                        await user.delete();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AuthPage()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Account deleted successfully')),
                        );
                      } catch (e) {
                        print(e);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to delete account: $e')),
                        );
                      }
                    }

                  },
                ),
              ],
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text(
              message,
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}