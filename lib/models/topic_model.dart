class Topic {
  final String name;
  final int num;

  Topic({
    required this.name,
    required this.num,
  });

  factory Topic.fromMap(Map<String, dynamic> data) {
    return Topic(
      name: data['name'] ?? '',
      num: data['num'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'num': num
    };
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      name: json['name'] ?? '',
      num: json['num'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'num': num
    };
  }
}
