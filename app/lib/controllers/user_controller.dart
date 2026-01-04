import 'package:app/models/user_model.dart';
import 'package:flutter/material.dart';


class UserController extends ChangeNotifier {
  User? _currentUser;
  final List<User> _users = [];

  User get currentUser => _currentUser!;

  void setCurrentUser(String id) {
    _currentUser = _users.firstWhere((u) => u.id == id);
    notifyListeners();
  }

  void addUser(User user) {
    _users.add(user);
  }

  List<User> get users => List.unmodifiable(_users);

  
}
