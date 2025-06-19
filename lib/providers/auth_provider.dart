import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  AppUser? _user;
  AppUser? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> signInWithGoogle() async {
    // TODO: Implement Google sign-in with Firebase
    // Placeholder user for now
    _user = AppUser(id: '1', name: 'Demo User', email: 'demo@example.com', photoUrl: null);
    notifyListeners();
  }

  Future<void> signOut() async {
    // TODO: Implement sign out
    _user = null;
    notifyListeners();
  }
} 