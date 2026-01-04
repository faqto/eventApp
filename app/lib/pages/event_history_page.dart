import 'package:flutter/material.dart';

class EventHistoryPage extends StatelessWidget {
  const EventHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Event History"),
      ),
      body: Center(
        child: Text("Event History Page"),
      ),
    );
  }
}