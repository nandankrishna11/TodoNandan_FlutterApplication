import 'package:flutter/material.dart';
import '../models/goal.dart';

class GoalProvider extends ChangeNotifier {
  final List<Goal> _goals = [];
  List<Goal> get goals => List.unmodifiable(_goals);

  void addGoal(Goal goal) {
    _goals.add(goal);
    notifyListeners();
  }

  void updateGoal(Goal goal) {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      _goals[index] = goal;
      notifyListeners();
    }
  }

  void removeGoal(String id) {
    _goals.removeWhere((g) => g.id == id);
    notifyListeners();
  }

  // TODO: Add methods for fetching from backend (Firebase)
} 