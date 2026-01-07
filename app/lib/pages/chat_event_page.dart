import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/chat_controller.dart';
import 'package:app/models/chat_model.dart';
import 'package:app/models/events_model.dart';
import 'package:app/pages/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventChatPage extends StatefulWidget {
  final Event event;
  const EventChatPage({super.key, required this.event});

  @override
  State<EventChatPage> createState() => _EventChatPageState();
}

class _EventChatPageState extends State<EventChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

 
  @override
Widget build(BuildContext context) {
  final chatController = context.watch<ChatController>();
  final app = context.read<AppController>();
  final currentUser = app.currentUser;

  // Get messages for this event
  final messages = chatController.getMessages(widget.event.id);

  return Scaffold(
    appBar: AppBar(
      title: Text(widget.event.title),
      backgroundColor: const Color.fromARGB(255, 143, 111, 255),
    ),
    body: Column(
      children: [
        // Messages list
        Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index]; 
                final isMe = msg.senderId == currentUser.id;

                return ChatBubble(message: msg, isMe: isMe);
              },
            ),
          ),


        // Input field
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.grey.shade100,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: "Type a message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.blue),
                onPressed: () {
                  final text = _messageController.text.trim();
                  if (text.isEmpty) return;
                   final currentUser = context.read<AppController>().currentUser;
                   
                  final message = ChatMessage(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    eventId: widget.event.id,
                    senderId: currentUser.id,
                    text: text,
                    timestamp: DateTime.now(),
                  );

                  chatController.sendMessage(message);
                  _messageController.clear();
                  
                  _scrollController.animateTo(
                    0.0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );

                },
              )
            ],
          ),
        ),
      ],
    ),
  );
}

}
