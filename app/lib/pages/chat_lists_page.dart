import 'package:app/controllers/app_controller.dart';
import 'package:app/pages/cards/chat_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatListsPage extends StatelessWidget {
  const ChatListsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppController>();
    final myEvents = app.myActiveEvents;

    if (myEvents.isEmpty) {
      return Center(
        child: Text(
          "You have no active events yet",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: myEvents.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChatCard(event: myEvents[index]),
        );
      },
    );
  }
}
