import 'package:app/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends ChangeNotifier {
  User? _currentUser;
  final List<User> _users = [];

  // getters
  User get currentUser => _currentUser ?? User.empty();
  bool get isLoggedIn => currentUser.id.isNotEmpty;
  List<User> get users => List.unmodifiable(_users);

  //CRUD 
  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  User? getUserById(String id) {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  //session
  Future<void> setCurrentUser(String id) async {
    _currentUser = getUserById(id);
    notifyListeners();

    if (_currentUser != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('currentUserId', id);
    }
  }

  Future<void> restoreCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString('currentUserId');
    if (savedId != null) {
      _currentUser = getUserById(savedId);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUserId');
    notifyListeners();
  }

  //Auth
  static String _hashPassword(String password) {
    return password.codeUnits.fold(0, (a, b) => a + b).toString();
  }

  Future<bool> login(String name, String password) async {
    final user = _users.firstWhere(
      (u) => u.name.toLowerCase() == name.toLowerCase(),
      orElse: () => User.empty(),
    );

    if (user.id.isEmpty) return false;
    if (user.passwordHash != _hashPassword(password)) return false;

    await setCurrentUser(user.id);
    return true;
  }

  String? register(String name, String password) {
    if (name.trim().isEmpty || password.length < 4) {
      return "Username or password is invalid";
    }

    final exists = _users.any(
      (u) => u.name.toLowerCase() == name.toLowerCase(),
    );

    if (exists) return "Username already exists";

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      email: '$name@example.com',
      passwordHash: _hashPassword(password),
    );

    _users.add(newUser);
    setCurrentUser(newUser.id);
    notifyListeners();
    return null;
  }

  bool verifyPassword(String password) {
    return _hashPassword(password) == currentUser.passwordHash;
  }

  //sample users
  void addSampleUsers() {
    addUser(User(
      id: "u1",
      name: "BadGumball",
      email: "bad@ahh.com",
      passwordHash: _hashPassword("admin"),
    ));
    addUser(User(
      id: "u2",
      name: "Jane",
      email: "jane@example.com",
      passwordHash: _hashPassword("1234"),
    ));
  }
}
