import 'dart:async';

import 'package:app/controllers/user_controller.dart';
import 'package:app/firestore_service.dart';
import 'package:app/models/chat_model.dart';
import 'package:app/models/events_model.dart';
import 'package:app/models/user_model.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  final Map<String, List<ChatMessage>> _messagesByEvent = {};
  final Map<String, bool> _loadingStates = {};
  final Map<String, StreamSubscription> _subscriptions = {};
  final FirestoreService _firestoreService = FirestoreService();
  
  // Store users by ID for quick access
  final Map<String, User> _usersById = {};
  
  Future<void> loadChatMessages(String eventId, {UserController? userController}) async {
    if (_loadingStates[eventId] == true || _subscriptions.containsKey(eventId)) {
      return;
    }

    _loadingStates[eventId] = true;
    notifyListeners();

    try {
      // If we have a user controller, pre-load users
      if (userController != null) {
        _cacheUsers(userController.users);
      }
      
      final existingMessages = await _firestoreService.loadAllChatMessages(eventId);
      _messagesByEvent[eventId] = existingMessages;
      _setupRealtimeListener(eventId);
      
      _loadingStates[eventId] = false;
      notifyListeners();
    } catch (e) {
      _loadingStates[eventId] = false;
      print('Error loading chat messages: $e');
      notifyListeners();
    }
  }

  // Cache users for quick lookup
  void _cacheUsers(List<User> users) {
    for (final user in users) {
      _usersById[user.id] = user;
    }
  }

  // Get user info for a sender
  User? getUserInfo(String userId) {
    return _usersById[userId];
  }

  void _setupRealtimeListener(String eventId) {
    _subscriptions[eventId]?.cancel();
    _subscriptions[eventId] = _firestoreService
        .streamChatMessages(eventId)
        .listen((messages) {
      _messagesByEvent[eventId] = messages;
      notifyListeners();
    }, onError: (error) {
      print('Error in chat stream: $error');
    });
  }

  List<ChatMessage> getMessages(String eventId) {
    return _messagesByEvent[eventId] ?? [];
  }

  bool isLoading(String eventId) {
    return _loadingStates[eventId] ?? false;
  }

  Future<void> sendMessage(ChatMessage message) async {
    final eventId = message.eventId;
    _messagesByEvent.putIfAbsent(eventId, () => []);
    _messagesByEvent[eventId]!.add(message);
    notifyListeners();
    await _firestoreService.addChatMessage(message);
  }

  // Helper method to create message with user info
  ChatMessage createMessage({
    required String eventId,
    required User currentUser,
    required String text,
  }) {
    return ChatMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}_${currentUser.id}',
      eventId: eventId,
      senderId: currentUser.id,
      senderName: currentUser.name,
      senderProfilePic: currentUser.profilePictureUrl ?? 'assets/images/default_profile.png',
      text: text,
      timestamp: DateTime.now(),
    );
  }

  void clearEventChat(String eventId) {
    _messagesByEvent.remove(eventId);
    _loadingStates.remove(eventId);
    _subscriptions[eventId]?.cancel();
    _subscriptions.remove(eventId);
    notifyListeners();
  }
  
  bool canChat(Event event) {
    return event.status == EventStatus.ongoing ||
        event.status == EventStatus.upcoming;
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }
}
