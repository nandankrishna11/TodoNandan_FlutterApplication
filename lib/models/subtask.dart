class SubTask {
  final String id;
  final String title;
  final bool isCompleted;
  final String? parentTaskId;

  SubTask({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.parentTaskId,
  });

  factory SubTask.fromMap(Map<String, dynamic> map, String id) {
    return SubTask(
      id: id,
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      parentTaskId: map['parentTaskId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'parentTaskId': parentTaskId,
    };
  }
} 