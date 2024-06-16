import '../models/author_model.dart';
import '../models/replies_model.dart';

class Post {
  String id;
  String question;
  String content;
  String topic;
  List<String> votes;
  int repliesCount;
  List<String> views;
  String created_at;
  Author author;
  List<Reply> replies;

  Post({
    required this.id,
    required this.question,
    required this.content,
    required this.topic,
    required this.votes,
    required this.repliesCount,
    required this.views,
    required this.created_at,
    required this.author,
    required this.replies,
  });

  // factory Post.fromJson(Map<String, dynamic> json) =>
  //     Post(
  //       id: json['id'],
  //       question: json['question'],
  //       content: json['content'],
  //       votes: json['votes'] as int,
  //       repliesCount: json['repliesCount'] as int,
  //       views: json['views'] as int,
  //       created_at: json['created_at'],
  //       author: Author
  //     );
  //
  // Map<String, dynamic> toJson() => {
  //   'uid': uid,
  //   'name': name,
  //   'image': image,
  //   'email': email,
  // };

//   factory Question.fromMap(Map<String, dynamic> data) {
//     return Question(
//       question: data['question'] ?? '',
//       content: data['content'] ?? '',
//       votes: data['votes'] ?? 0,
//       repliesCount: data['repliesCount'] ?? 0,
//       views: data['views'] ?? 0,
//       created_at: data['created_at'] ?? '',
//       author: Author(image: "", email: "", name: "", uid: ""),
//       replies: [],
//     );
//   }

  factory Post.fromMap(Map<String, dynamic> data) {
    return Post(
      id: data['id'] ?? '',
      question: data['question'] ?? '',
      content: data['content'] ?? '',
      topic: data['topic'] ?? '',
      votes: data['votes'] ?? [],
      repliesCount: data['repliesCount'] ?? 0,
      views: data['views'] ?? [],
      created_at: data['created_at'] ?? '',
      author: Author.fromMap(data['author']),
      replies: List<Reply>.from(
        data['replies']?.map((item) => Reply.fromMap(item)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'content': content,
      'topic': topic,
      'votes': votes,
      'repliesCount': repliesCount,
      'views': views,
      'created_at': created_at,
      'author': author.toMap(),
      'replies': replies.map((reply) => reply.toMap()).toList(),
    };
  }

  bool isCreatedBy(String userId) {
    return author.uid == userId;
  }

  void addReply(Reply reply) {
    replies.add(reply);
  }

  void updateReply(Reply updatedReply) {
    final index = replies.indexWhere((reply) => reply.id == updatedReply.id);
    if (index != -1) {
      replies[index] = updatedReply;
    }
  }

  void deleteReply(Reply reply) {
    replies.removeWhere((r) => r.id == reply.id);
  }
}

// List<Question> questions = [
//   Question(
//     id: '1',
//     author: mike,
//     question: 'C ## In A Nutshell',
//     content: "Lorem  i've been using c## for a whole decade now, if you guys know how to break the boring feeling of letting to tell everyne of what happed in the day",
//     created_at: "1h ago",
//     views: 120,
//     votes: 100,
//     repliesCount: 80,
//     replies: replies
//   ),
//   Question(
//     id: '2',
//     author: john,
//     question: 'List<Dynamic> is not a subtype of Lits<Container>',
//     content: "Lorem  i've been using c## for a whole decade now, if you guys know how to break the boring feeling of letting to tell everyne of what happed in the day",
//     created_at: "2h ago",
//     views: 20,
//     votes: 10,
//     repliesCount: 10,
//     replies: replies
//   ),
//   Question(
//     id: '3',
//     author: sam,
//     question: 'React a basic error 404 is not typed',
//     content: "Lorem  i've been using c## for a whole decade now, if you guys know how to break the boring feeling of letting to tell everyne of what happed in the day",
//     created_at: "4h ago",
//     views: 220,
//     votes: 107,
//     repliesCount: 67,
//     replies: replies
//   ),
//   Question(
//     id: '4',
//     author: mark,
//     question: 'Basic understanding of what is not good',
//     content: "Lorem  i've been using c## for a whole decade now, if you guys know how to break the boring feeling of letting to tell everyne of what happed in the day",
//     created_at: "10h ago",
//     views: 221,
//     votes: 109,
//     repliesCount: 67,
//     replies: replies
//   ),
//   Question(
//     id: '5',
//     author: justin,
//     question: 'Luther is not author in here',
//     content: "Lorem  i've been using c## for a whole decade now, if you guys know how to break the boring feeling of letting to tell everyne of what happed in the day",
//     created_at: "24h ago",
//     views: 325,
//     votes: 545,
//     repliesCount: 120,
//     replies: replies
//   ),
// ];