import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_nandan_flutter/models/task.dart';
import 'package:flutter/foundation.dart';
import '../models/subtask.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  TaskCategory? _selectedCategory;
  TaskPriority? _selectedPriority;
  String _searchQuery = '';
  String _sortBy = 'Priority';
  bool _showCompleted = false;

  // Getters
  List<Task> get tasks => List.unmodifiable(_tasks);
  TaskCategory? get selectedCategory => _selectedCategory;
  TaskPriority? get selectedPriority => _selectedPriority;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  bool get showCompleted => _showCompleted;

  List<Task> get filteredTasks {
    List<Task> filtered = List.from(_tasks);

    // Apply filters
    if (!_showCompleted) {
      filtered = filtered.where((task) => !task.isCompleted).toList();
    }

    if (_selectedCategory != null) {
      filtered = filtered.where((task) => task.category == _selectedCategory).toList();
    }

    if (_selectedPriority != null) {
      filtered = filtered.where((task) => task.priority == _selectedPriority).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((task) =>
        task.title.toLowerCase().contains(query) ||
        task.description.toLowerCase().contains(query)
      ).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'Priority':
        filtered.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case 'Due Date':
        filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case 'Name':
        filtered.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Status':
        filtered.sort((a, b) {
          if (a.isCompleted == b.isCompleted) return 0;
          return a.isCompleted ? 1 : -1;
        });
        break;
    }

    return filtered;
  }

  void setSortBy(String sortBy) {
    _sortBy = sortBy;
    notifyListeners();
  }

  void setCategoryFilter(TaskCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setPriorityFilter(TaskPriority? priority) {
    _selectedPriority = priority;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setShowCompleted(bool show) {
    _showCompleted = show;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedPriority = null;
    _searchQuery = '';
    notifyListeners();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks') ?? [];
    _tasks = tasksJson.map((json) => Task.fromJson(jsonDecode(json))).toList();
    notifyListeners();
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    saveTasks();
    notifyListeners();
  }

  void toggleTaskCompletion(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
      saveTasks();
      notifyListeners();
    }
  }

  // Subtasks
  void addSubtask(String taskId, SubTask subtask) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].subtasks.add(subtask);
      notifyListeners();
    }
  }

  void removeSubtask(String taskId, String subtaskId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].subtasks.removeWhere((s) => s.id == subtaskId);
      notifyListeners();
    }
  }

  // Reminders
  void setReminder(String taskId, DateTime? reminder) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(reminder: reminder);
      notifyListeners();
    }
  }

  // Attachments
  void addAttachment(String taskId, String path) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].attachments.add(path);
      notifyListeners();
    }
  }

  void removeAttachment(String taskId, String path) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].attachments.remove(path);
      notifyListeners();
    }
  }

  // Comments
  void addComment(String taskId, String commentId) {
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _tasks[index].commentIds.add(commentId);
      notifyListeners();
    }
  }
} 