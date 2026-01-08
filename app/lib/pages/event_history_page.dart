import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/event_controller.dart';
import 'package:app/models/events_model.dart';
import 'package:app/pages/cards/history_event_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventHistoryPage extends StatelessWidget {
  const EventHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppController>();
    final events = context.watch<EventController>();

    final user = app.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'Please log in to view event history',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }
    
    final userId = user.id;
    
    // Get user's past events (hosted or attended)
    final pastEvents = events.events.where((event) {
      final isHost = event.hostId == userId;
      final isAttended = event.attendeeIds.contains(userId);
      final isPast = event.status == EventStatus.ended || 
                     event.status == EventStatus.cancelled;
      
      return (isHost || isAttended) && isPast;
    }).toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime)); // Most recent first

    // Rest of your build method...
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event History'),
      ),
      body: pastEvents.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No past events',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pastEvents.length,
              itemBuilder: (context, index) {
                return HistoryEventCard(event: pastEvents[index]);
              },
            ),
    );
  }
}