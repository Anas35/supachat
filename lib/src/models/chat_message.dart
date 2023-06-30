class ChatMessage {
  final int id;
  final bool isSender;
  final String message;
  final String userId;
  final int roomId;
  final String? file;
  final DateTime createdAt;

  ChatMessage({
    required this.id,
    this.isSender = true,
    required this.message,
    required this.userId,
    required this.roomId,
    required this.createdAt,
    this.file,
  });

  factory ChatMessage.forRequest({
    required String message,
    required String userId,
    required int groupId,
    String? file,
  }) {
    return ChatMessage(
      id: 0,
      message: message, 
      userId: userId, 
      roomId: groupId, 
      file: file,
      createdAt: DateTime.now(),
    );
  }

  static ChatMessage fromJson(Map<String, dynamic> json, String uid) {
    return ChatMessage(
      id: json['id'] as int, 
      message: json['message'] as String, 
      file: json['file'],
      userId: json['user_id'] as String, 
      roomId: json['room_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      isSender: json['user_id'] == uid,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "user_id": userId,
      "room_id": roomId,
      "file": file,
    };
  }
}
