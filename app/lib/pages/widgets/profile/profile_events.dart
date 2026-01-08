import 'package:app/models/events_model.dart';
import 'package:app/pages/cards/profile_event_card.dart';
import 'package:flutter/material.dart';

class ProfileEvents extends StatelessWidget {
  final List<Event> upcomingEvents;
  final List<Event> pastEvents;
  
  const ProfileEvents({
    super.key,
    required this.upcomingEvents,
    required this.pastEvents,
  });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "My Events",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(thickness: 1, color: Colors.grey),
        
        // Upcoming Events
        if (upcomingEvents.isNotEmpty) ...[
          ...upcomingEvents
              .map((event) => ProfileEventCard(event: event))
              .toList(),
        ] else
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Icon(Icons.event, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  "No upcoming events",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
          ),
        
        const SizedBox(height: 20),
        
        // Past Events
        if (pastEvents.isNotEmpty)
          ExpansionTile(
            title: const Text(
              "Past Events",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            initiallyExpanded: false,
            children: [
              ...pastEvents
                  .map(
                    (event) => Opacity(
                      opacity: 0.7,
                      child: ProfileEventCard(event: event),
                    ),
                  )
                  .toList(),
            ],
          ),
      ],
    );
  }
}