import 'dart:async';

import 'package:app/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends ChangeNotifier {
  User? _currentUser;
  final List<User> _users = [];
  final FirestoreService _firestoreService = FirestoreService();
  StreamSubscription? _usersStreamSubscription;

  // FIXED: Changed to nullable User? and added non-nullable getter
  User? get currentUser => _currentUser;
  User get currentUserOrEmpty => _currentUser ?? User.empty;
  
  List<User> get users => List.unmodifiable(_users);

  UserController() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadUsersFromFirestore();
    await _loadLocalProfilePicture();
  }

  Future<void> _loadUsersFromFirestore() async {
    try {
      _usersStreamSubscription = _firestoreService.streamUsers().listen((firestoreUsers) {
        _users.clear();
        _users.addAll(firestoreUsers);
        
        if (_currentUser != null) {
          final updatedUser = firestoreUsers.firstWhere(
            (user) => user.id == _currentUser!.id,
            orElse: () => _currentUser!,
          );
          if (updatedUser != _currentUser) {
            _currentUser = updatedUser;
            notifyListeners();
          }
        }
      });
    } catch (e) {
      print('Error loading users from Firestore: $e');
    }
  }

  Future<void> _loadLocalProfilePicture() async {
    if (_currentUser == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    final avatarPath = prefs.getString('profile_avatar_${_currentUser!.id}');
    
    if (avatarPath != null && _currentUser != null) {
      _currentUser = _currentUser!.copyWith(profilePictureUrl: avatarPath);
      notifyListeners();
    }
  }

  Future<void> setFromFirebaseUser(fb.User firebaseUser) async {
    final existingUser = await _firestoreService.getUserById(firebaseUser.uid);
    
    if (existingUser != null) {
      _currentUser = existingUser;
      if (!_users.any((u) => u.id == existingUser.id)) {
        _users.add(existingUser);
      }
    } else {
      final newUser = User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? _nameFromEmail(firebaseUser.email) ?? "New User",
        email: firebaseUser.email ?? "",
        profilePictureUrl: 'assets/images/default_profile.png',
      );
      
      await _firestoreService.addOrUpdateUser(newUser);
      _currentUser = newUser;
      _users.add(newUser);
    }

    await _loadLocalProfilePicture();
    notifyListeners();
  }

  String? _nameFromEmail(String? email) {
    if (email == null || !email.contains('@')) return null;
    return email.split('@').first;
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateUser(User user) async {
    try {
      await _firestoreService.addOrUpdateUser(user);
      
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
      } else {
        _users.add(user);
      }
      
      if (_currentUser?.id == user.id) {
        _currentUser = user;
      }
      
      notifyListeners();
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // NEW METHOD: Update profile picture from image picker
  Future<void> updateProfilePicture(String imagePath) async {
    if (_currentUser == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_avatar_${_currentUser!.id}', imagePath);

    final updatedUser = _currentUser!.copyWith(
      profilePictureUrl: imagePath,
    );

    await updateUser(updatedUser);
  }

  // NEW METHOD: Remove profile picture
  Future<void> removeProfilePicture() async {
    if (_currentUser == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_avatar_${_currentUser!.id}');

    final defaultAvatar = 'assets/images/default_profile.png';
    final updatedUser = _currentUser!.copyWith(
      profilePictureUrl: defaultAvatar,
    );

    await updateUser(updatedUser);
  }

  // FIXED: Updated method signature to match usage
  Future<void> updateCurrentUserProfile({
    String? name,
    String? bio,
    String? profilePictureUrl,
  }) async {
    if (_currentUser == null) return;

    final updatedUser = _currentUser!.copyWith(
      name: name ?? _currentUser!.name,
      bio: bio ?? _currentUser!.bio,
      profilePictureUrl: profilePictureUrl ?? _currentUser!.profilePictureUrl,
    );

    await updateUser(updatedUser);
  }

  List<String> getAvailableAvatars() {
    return [
      'assets/images/default_profile.png',
      'assets/images/profile1.png',
      'assets/images/profile2.png',
      'assets/images/profile3.png',
      'assets/images/profile4.png',
      'assets/images/profile5.png',
      'assets/images/profile6.png',
      'assets/images/profile7.png',
      'assets/images/profile8.png',
      'assets/images/profile9.png',
    ];
  }

  User? getUserById(String id) {
    try {
      return _users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  void addUser(User user) {
    if (!_users.any((u) => u.id == user.id)) {
      _users.add(user);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _usersStreamSubscription?.cancel();
    super.dispose();
  }
}