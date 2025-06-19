class Comment {
  final String id;
  final String userId;
  final String taskId;
  final String content;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.taskId,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromMap(Map<String, dynamic> map, String id) {
    return Comment(
      id: id,
      userId: map['userId'] ?? '',
      taskId: map['taskId'] ?? '',
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'taskId': taskId,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 