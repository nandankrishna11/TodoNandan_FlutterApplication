class Achievement {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String icon;
  final DateTime achievedAt;

  Achievement({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.icon,
    required this.achievedAt,
  });

  factory Achievement.fromMap(Map<String, dynamic> map, String id) {
    return Achievement(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      achievedAt: DateTime.parse(map['achievedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'icon': icon,
      'achievedAt': achievedAt.toIso8601String(),
    };
  }
} 