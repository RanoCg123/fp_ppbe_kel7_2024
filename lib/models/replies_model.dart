import 'package:fp_forum_kel7_ppbe/models/author_model.dart';

class Reply {
  Author author;
  String content;
  int likes;

  Reply({
    required this.author,
    required this.content,
    required this.likes
  });
}

