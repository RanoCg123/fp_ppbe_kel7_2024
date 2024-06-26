import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fp_forum_kel7_ppbe/widgets/post_widget.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';
import '../util/snackbar_util.dart';
import '../util/modal_util.dart';
import 'own_post_widget.dart';

class TrendingPosts extends StatefulWidget {
  // final List<Post>? posts;
  // final Function() deletePost;

  const TrendingPosts({super.key});

  @override
  _TrendingPostsState createState() => _TrendingPostsState();
}

class _TrendingPostsState extends State<TrendingPosts> {
  List<Post>? posts;
  bool postLoaded = false;
  final postService = PostService();
  Post? selectedPost;
  final user = FirebaseAuth.instance.currentUser!;

  void getTrendingPosts() async {
    setState(() {
      postLoaded = false;
    });
    posts = await postService.getPosts(
      orderBy: 'numVotes',
      descending: true,
      limit: 5,
    );
    setState(() {
      postLoaded = true;
    });
  }

//   void deletePost() {
//     try {
//       postService.deletePost(selectedPost!.id);
//       setState(() {
//         posts!.remove(selectedPost!);
//       });
//       showSnackBar(context, 'You have delete this post' , type: "success");
//     } catch (e) {
//       showSnackBar(context, 'failed to delete post: $e', type: "warning");
//     }
//   }

//   void updatePost() {}

//   void bookmarkPost() {}

//   void showOptions(Post post) {
//     selectedPost = post;
//     List<Option> options;
//     if (selectedPost!.author.uid == user.uid) {
//       options = [
//         Option(text: "Edit post", icon: Icons.edit, handler: updatePost),
//         Option(text: "Delete post", icon: Icons.delete, handler: deletePost),
//       ];
//       showBottomOptionModal(context, options, 130.0);
//     } else {
//       options = [Option(
//         text: "Bookmark this post",
//         icon: Icons.bookmark,
//         handler: bookmarkPost,
//       ),];
//       showBottomOptionModal(context, options, 80.0);
//     }
  void removePost(Post post) {
    getTrendingPosts();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTrendingPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: !postLoaded
            ? [
          const Center(
            child: CircularProgressIndicator(),
          )
        ]
            : posts!
            .map((Post post) {
              // other user's post
              if (post.author.uid != user.uid) {
                return PostWidget(post: post);
              }
              // owner post
              else {
                return OwnPostWidget(post: post, removeFromList: removePost,);
              }
            })
            .toList());
  }
}
