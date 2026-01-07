import 'package:app/models/chat_model.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  final Map<String, List<ChatMessage>> _messagesByEvent = {};

  List<ChatMessage> getMessages(String eventId) {
    return _messagesByEvent[eventId] ?? [];
  }

  void sendMessage(ChatMessage message) {
    _messagesByEvent.putIfAbsent(message.eventId, () => []);
    _messagesByEvent[message.eventId]!.add(message);
    notifyListeners();
  }

    void clearState() {
    _messagesByEvent.clear();
    notifyListeners();
  }

}
