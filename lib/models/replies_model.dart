import 'package:cloud_firestore/cloud_firestore.dart';
import 'author_model.dart';

class Reply {
  final String id;
  final Author author;
  late final String content;
  final String created_at;
  final int likes;

  Reply({
    this.id = '',
    required this.author,
    required this.content,
    required this.created_at,
    required this.likes,
  });

  factory Reply.fromMap(Map<String, dynamic> data) {
    return Reply(
      id: data['id'] ?? '',
      author: Author.fromMap(data['author']),
      content: data['content'] ?? '',
      created_at: data['created_at'] ?? '',
      likes: data['likes'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author.toMap(),
      'content': content,
      'created_at': created_at,
      'likes': likes,
    };
  }
}

List<Reply> replies = [
  Reply(
    author: Author(name: 'User1', imageUrl: 'assets/images/user1.png'),
    content: 'Great post!',
    created_at: '2024-06-10 12:00:00',
    likes: 10,
  ),
  Reply(
    author: Author(name: 'User2', imageUrl: 'assets/images/user2.png'),
    content: 'Thanks for sharing!',
    created_at: '2024-06-10 13:00:00',
    likes: 5,
  ),
];
// List<Reply> replies = [
//   Reply(
//     author: mike,
//     content: 'LMOA try to learn php using udemy or youtube courses if your good enough elrrn from docs',
//     likes: 10
//   ),
//   Reply(
//     author: john,
//     content: 'Officiis iusto dolorum delectus totam. Replioe',
//     likes: 120
//   ),
//   Reply(
//     author: mark,
//     content: 'distinctio nostrum nobis, nisi vel quasi amet laborum nam saepe ullam fuga. ellendus alias rem facere obcaecati.',
//     likes: 67
//   ),
//   Reply(
//     author: sam,
//     content: 'Asperiores quisquam perspiciatis iure commodi quidem vitae modi, nemo optio eos cum labore ',
//     likes: 34
//   ),
//   Reply(
//     author: adam,
//     content: 'nemo totam voluptatum qui error obcaecati assumenda temporibus blanditiis unde, maiores velit tempora neque, porro autem ab eveniet. ',
//     likes: 89
//   ),
//   Reply(
//     author: luther,
//     content: 'amet quo. Accusantium nam reiciendis quisquam voluptate impedit mollitia debitis facilis, ',
//     likes: 12
//   ),
//   Reply(
//     author: justin,
//     content: 'fugiat autem a neque esse error quia itaque molestiae praesentium, totam aspernatur earum dicta, ',
//     likes: 27
//   ),
// ];
//
// var reply = replies;
