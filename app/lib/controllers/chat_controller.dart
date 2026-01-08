import 'dart:async';
import 'package:app/firestore_service.dart';
import 'package:app/models/chat_model.dart';
import 'package:app/models/events_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  final Map<String, List<ChatMessage>> _messagesByEvent = {};
  final Map<String, bool> _loadingStates = {};
  final Map<String, StreamSubscription> _subscriptions = {};
  final FirestoreService _firestoreService = FirestoreService();
  
  Future<void> loadChatMessages(String eventId) async {
    _clearExistingData(eventId);
    
    _loadingStates[eventId] = true;
    notifyListeners();

    try {
      final existingMessages = await _firestoreService.loadAllChatMessages(eventId);
      _messagesByEvent[eventId] = existingMessages;
      _setupRealtimeListener(eventId);
      
      _loadingStates[eventId] = false;
      notifyListeners();

    } catch (e) {
  
      _loadingStates[eventId] = false;
      notifyListeners();
    }
  }

  void _clearExistingData(String eventId) {
    _messagesByEvent.remove(eventId);
    _loadingStates.remove(eventId);
   
    if (_subscriptions.containsKey(eventId)) {
      _subscriptions[eventId]?.cancel();
      _subscriptions.remove(eventId);
    }
  }

  void _setupRealtimeListener(String eventId) {
    _subscriptions[eventId]?.cancel();

    _subscriptions[eventId] = _firestoreService
        .streamChatMessages(eventId)
        .listen((messages) {
      _messagesByEvent[eventId] = messages;
      notifyListeners();
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
    
    try {

      await _firestoreService.addChatMessage(message);
    } catch (e) {

      _messagesByEvent[eventId]!.remove(message);
      notifyListeners();
      rethrow;
    }
  }

  ChatMessage createMessage({
    required String eventId,
    required String currentUserId,
    required String currentUserName,
    required String text,
  }) {
    return ChatMessage(
      id: '${DateTime.now().millisecondsSinceEpoch}_$currentUserId',
      eventId: eventId,
      senderId: currentUserId,
      senderName: currentUserName,
      text: text,
      timestamp: DateTime.now(),
    );
  }

  void clearEventChat(String eventId) {
    _clearExistingData(eventId);
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
  Future<void> debugChatSystem(String eventId) async {
 
      final firestore = FirebaseFirestore.instance;
      final query = await firestore
          .collection('chat_messages')
          .where('eventId', isEqualTo: eventId)
          .orderBy('timestamp', descending: false)
          .get();
      
      if (query.docs.isNotEmpty) {
        for (var doc in query.docs) {
          final data = doc.data();
        
          data.forEach((key, value) {
          
          });
        }
      } else {
        final allDocs = await firestore.collection('chat_messages').limit(5).get();
        for (var doc in allDocs.docs) {
          final data = doc.data();
          print('${doc.id} - eventId: ${data['eventId']}');
        }
      }
      
    
  }
}