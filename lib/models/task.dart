import 'package:uuid/uuid.dart';
import 'subtask.dart';

enum TaskPriority { low, medium, high }
enum TaskCategory { work, personal, shopping, health, education }

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskCategory category;
  final bool isCompleted;
  final DateTime? createdAt;
  final DateTime? completedAt;
  // New fields
  final List<SubTask> subtasks;
  final bool isRecurring;
  final String? recurrenceRule;
  final DateTime? reminder;
  final List<String> attachments;
  final List<String> commentIds;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.category,
    this.isCompleted = false,
    this.createdAt,
    this.completedAt,
    this.subtasks = const [],
    this.isRecurring = false,
    this.recurrenceRule,
    this.reminder,
    this.attachments = const [],
    this.commentIds = const [],
  });

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dueDate: DateTime.parse(map['dueDate'] ?? DateTime.now().toIso8601String()),
      priority: TaskPriority.values.firstWhere((e) => e.toString() == map['priority'], orElse: () => TaskPriority.medium),
      category: TaskCategory.values.firstWhere((e) => e.toString() == map['category'], orElse: () => TaskCategory.personal),
      isCompleted: map['isCompleted'] ?? false,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
      subtasks: map['subtasks'] != null ? List<SubTask>.from((map['subtasks'] as List).map((s) => SubTask.fromMap(s, s['id']))) : [],
      isRecurring: map['isRecurring'] ?? false,
      recurrenceRule: map['recurrenceRule'],
      reminder: map['reminder'] != null ? DateTime.parse(map['reminder']) : null,
      attachments: map['attachments'] != null ? List<String>.from(map['attachments']) : [],
      commentIds: map['commentIds'] != null ? List<String>.from(map['commentIds']) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.toString(),
      'category': category.toString(),
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'subtasks': subtasks.map((s) => s.toMap()).toList(),
      'isRecurring': isRecurring,
      'recurrenceRule': recurrenceRule,
      'reminder': reminder?.toIso8601String(),
      'attachments': attachments,
      'commentIds': commentIds,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority.toString(),
      'category': category.toString(),
      'isCompleted': isCompleted,
      'createdAt': createdAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      priority: TaskPriority.values.firstWhere(
        (e) => e.toString() == json['priority'],
      ),
      category: TaskCategory.values.firstWhere(
        (e) => e.toString() == json['category'],
      ),
      isCompleted: json['isCompleted'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskCategory? category,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? completedAt,
    List<SubTask>? subtasks,
    bool? isRecurring,
    String? recurrenceRule,
    DateTime? reminder,
    List<String>? attachments,
    List<String>? commentIds,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      subtasks: subtasks ?? this.subtasks,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      reminder: reminder ?? this.reminder,
      attachments: attachments ?? this.attachments,
      commentIds: commentIds ?? this.commentIds,
    );
  }
} 