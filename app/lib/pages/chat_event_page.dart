import 'package:app/controllers/chat_controller.dart';
import 'package:app/controllers/user_controller.dart';
import 'package:app/models/chat_model.dart';
import 'package:app/models/events_model.dart';
import 'package:app/pages/widgets/chat_bubble.dart';
import 'package:app/routes/routes.dart';
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
  late bool _canChat;
  bool _isSending = false;
  bool _initialLoadComplete = false;

  @override
  void initState() {
    super.initState();
    _canChat = false;
    
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final chatController = context.read<ChatController>();


      await chatController.debugChatSystem(widget.event.id);
      _canChat = chatController.canChat(widget.event);
      
     
      if (_canChat) {
        await chatController.loadChatMessages(widget.event.id);
      }
      
      if (mounted) {
        setState(() {
          _initialLoadComplete = true;
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  void dispose() {
    context.read<ChatController>().clearEventChat(widget.event.id);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending || !_canChat) return;

    final userController = context.read<UserController>();
    final currentUser = userController.currentUser;
    final chatController = context.read<ChatController>();

    if (currentUser == null) return;

    setState(() => _isSending = true);

    try {
      final message = chatController.createMessage(
        eventId: widget.event.id,
        currentUserId: currentUser.id,
        currentUserName: currentUser.name,
        text: text,
      );

      await chatController.sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send message: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  Widget _buildMessageList(List<ChatMessage> messages, BuildContext context) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              _canChat
                  ? "No messages yet. Start the conversation!"
                  : "Chat is not available for this event.",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final userController = context.read<UserController>();
        final currentUser = userController.currentUser;
        final isMe = currentUser != null && msg.senderId == currentUser.id;
        final showSenderInfo = 
            index == 0 || messages[index - 1].senderId != msg.senderId;
        
        final isSenderHost = msg.senderId == widget.event.hostId;

        return ChatBubble(
          message: msg,
          isMe: isMe,
          showSenderInfo: showSenderInfo,
          isSenderHost: isSenderHost,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final chatController = context.watch<ChatController>();
    final messages = chatController.getMessages(widget.event.id);
    final isLoading = chatController.isLoading(widget.event.id) || !_initialLoadComplete;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event.title),
        backgroundColor: const Color(0xFF7F5DFB),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            tooltip: 'Event Details',
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.eventDetails,
                arguments: widget.event,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_canChat)
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.orange.shade50,
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Chat is only available for upcoming and ongoing events",
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildMessageList(messages, context),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: _canChat && !_isSending,
                    decoration: InputDecoration(
                      hintText: _canChat ? "Type a message..." : "Chat closed",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: _canChat && !_isSending
                          ? Colors.grey.shade50
                          : Colors.grey.shade200,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    onSubmitted: _canChat && !_isSending
                        ? (_) => _sendMessage()
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _canChat && !_isSending
                        ? const Color.fromARGB(255, 143, 111, 255)
                        : Colors.grey,
                  ),
                  child: IconButton(
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: _canChat && !_isSending ? _sendMessage : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}