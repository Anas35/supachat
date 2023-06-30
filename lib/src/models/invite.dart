import 'package:supa_chat/src/models/group.dart';

class Invite {
  final int id;
  final User user;
  final DateTime createdAt;
  final bool? accept;

  Invite({
    required this.id,
    required this.user,
    required this.createdAt,
    this.accept,
  });

  static Invite fromJson(Map<String, dynamic> json) {
    return Invite(
      id: json['id'] as int,
      user: json['from'] is Map ? User.fromJson(json['from']) : User.fromJson(json['to']),
      createdAt: DateTime.parse(json['created_at'] as String),
      accept: json['accept'] as bool?,
    );
  }
}