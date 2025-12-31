import 'package:app/pages/cards/chat_card.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ListView(
        children: [
          ChatCard(),
        ],
      )
    );
  }
}