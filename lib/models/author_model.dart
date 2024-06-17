class Author{
  final String uid;
  final String name;
  final String email;
  final String image;

  const Author({
    required this.name,
    required this.image,
    required this.uid,
    required this.email,
  });
  factory Author.fromJson(Map<String, dynamic> json) =>
      Author(
        uid: json['uid'],
        name: json['name'],
        image: json['image'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'image': image,
    'email': email,
  };

  factory Author.fromMap(Map<String, dynamic> data) {
    return Author(
      uid: data['uid'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      image: data['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'image': image,
    };
  }
}
