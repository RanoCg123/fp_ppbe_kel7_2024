import 'package:fp_forum_kel7_ppbe/models/author_model.dart';
import 'package:fp_forum_kel7_ppbe/models/replies_model.dart';

class Question{
  String question;
  String content;
  int votes;
  int repliesCount;
  int views;
  String created_at;
  Author author;
  List<Reply> replies;

  Question({
    required this.question,
    required this.content,
    required this.votes,
    required this.repliesCount,
    required this.views,
    required this.created_at,
    required this.author,
    required this.replies
  });
}
