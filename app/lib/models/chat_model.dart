class ChatMessage {
  final String id;
  final String eventId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.eventId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}
