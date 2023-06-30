class Group {

  final int id;
  final String name;

  const Group({
    required this.id,
    required this.name,
  });

  static Group fromJson(Map<String, dynamic> json, String currentUid) {
    final user1 = User.fromJson(json['user1']);
    final user2 = User.fromJson(json['user2']);
    return Group(
      id: json['id'] as int,
      name: user1.id == currentUid ? user2.username : user1.username,
    );
  }

}

class User {

  final String id;
  final String username;

  const User({
    required this.id,
    required this.username,
  });

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
    );
  }

}