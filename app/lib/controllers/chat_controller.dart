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
    print('\n🚀🚀🚀 CHAT LOAD STARTED 🚀🚀🚀');
    print('EVENT ID: $eventId');
    _clearExistingData(eventId);
    
    _loadingStates[eventId] = true;
    notifyListeners();

    try {
      // Load existing messages from Firestore
      print('📡 Calling FirestoreService.loadAllChatMessages...');
      final existingMessages = await _firestoreService.loadAllChatMessages(eventId);

      if (existingMessages.isNotEmpty) {
        print('📝 Sample messages:');
        for (int i = 0; i < existingMessages.length && i < 3; i++) {
          final msg = existingMessages[i];
          print('   [${i + 1}] "${msg.text}" from ${msg.senderName} at ${msg.timestamp}');
        }
      } else {
        print('📭 No messages found for this event');
      }

      _messagesByEvent[eventId] = existingMessages;
      
      // Set up real-time listener for new messages
      _setupRealtimeListener(eventId);
      
      _loadingStates[eventId] = false;
      notifyListeners();
      
      print('Chat loaded for event $eventId: ${existingMessages.length} messages');
    } catch (e) {
      print('Error loading chat messages: $e');
      _loadingStates[eventId] = false;
      notifyListeners();
    }
  }

  void _clearExistingData(String eventId) {
    // Clear any existing messages for this event
    _messagesByEvent.remove(eventId);
    _loadingStates.remove(eventId);
    
    // Cancel existing subscription if any
    if (_subscriptions.containsKey(eventId)) {
      _subscriptions[eventId]?.cancel();
      _subscriptions.remove(eventId);
    }
  }

  void _setupRealtimeListener(String eventId) {
    // Cancel existing subscription if any
    _subscriptions[eventId]?.cancel();
    
    // Create new subscription
    _subscriptions[eventId] = _firestoreService
        .streamChatMessages(eventId)
        .listen((messages) {
      // Update messages for this event with fresh data
      _messagesByEvent[eventId] = messages;
      notifyListeners();
    }, onError: (error) {
      print('Error in chat stream for event $eventId: $error');
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
    
    // Optimistically add to local list
    _messagesByEvent.putIfAbsent(eventId, () => []);
    _messagesByEvent[eventId]!.add(message);
    notifyListeners();
    
    try {
      // Send to Firestore
      await _firestoreService.addChatMessage(message);
    } catch (e) {
      // Remove from local list if failed
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
    try {
      final firestore = FirebaseFirestore.instance;
      final query = await firestore
          .collection('chat_messages')
          .where('eventId', isEqualTo: eventId)
          .orderBy('timestamp', descending: false)
          .get();
      
      if (query.docs.isNotEmpty) {
        for (var doc in query.docs) {
          final data = doc.data();
          print('  📄 Document ${doc.id}:');
          data.forEach((key, value) {
            print('    $key: $value');
          });
        }
      } else {
        final allDocs = await firestore.collection('chat_messages').limit(5).get();
        for (var doc in allDocs.docs) {
          final data = doc.data();
          print('  📄 ${doc.id} - eventId: ${data['eventId']}');
        }
      }
      
      // Test 2: ChatModel parsing
      print('\n📊 TEST 2: ChatModel Parsing');
      if (query.docs.isNotEmpty) {
        final doc = query.docs.first;
        print('  Parsing document: ${doc.id}');
        try {
          final chatMessage = ChatMessage.fromFirestore(doc);
          print('  ✅ Successfully parsed ChatMessage:');
          print('     Text: "${chatMessage.text}"');
          print('     Sender: ${chatMessage.senderName} (${chatMessage.senderId})');
          print('     Timestamp: ${chatMessage.timestamp}');
        } catch (e) {
          print('  ❌ Failed to parse: $e');
        }
      }
      
      // Test 3: Current state
      print('\n📊 TEST 3: Current Controller State');
      print('  _messagesByEvent[$eventId]: ${_messagesByEvent[eventId]?.length ?? 0} messages');
      print('  _loadingStates[$eventId]: ${_loadingStates[eventId]}');
      print('  _subscriptions[$eventId]: ${_subscriptions.containsKey(eventId)}');
      
      print('\n🎯 DEBUG COMPLETE 🎯\n');
      
    } catch (e) {
      print('❌ DEBUG ERROR: $e');
      print('Stack trace: ${e.toString()}');
    }
  }
}