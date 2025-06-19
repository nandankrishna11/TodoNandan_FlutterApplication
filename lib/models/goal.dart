class Goal {
  final String id;
  final String userId;
  final String title;
  final String description;
  final int targetCount;
  final int currentCount;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCompleted;

  Goal({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.targetCount,
    required this.currentCount,
    required this.startDate,
    required this.endDate,
    this.isCompleted = false,
  });

  factory Goal.fromMap(Map<String, dynamic> map, String id) {
    return Goal(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      targetCount: map['targetCount'] ?? 0,
      currentCount: map['currentCount'] ?? 0,
      startDate: DateTime.parse(map['startDate'] ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(map['endDate'] ?? DateTime.now().toIso8601String()),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
} 