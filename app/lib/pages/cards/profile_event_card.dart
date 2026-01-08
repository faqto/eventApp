import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/event_controller.dart'; // Add this import
import 'package:app/models/events_model.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileEventCard extends StatelessWidget {
  final Event event;

  const ProfileEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppController>().currentUser;
    final eventController = context.read<EventController>(); // Get EventController

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.eventDetails,
          arguments: event,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMd().format(event.dateTime),
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  'Location: ${event.location}',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Conditional modify button for upcoming events
                if (event.hostId == currentUser!.id && event.status == EventStatus.upcoming)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.modifyEvent,
                        arguments: event,
                      );
                    },
                    child: const Text("Modify"),
                  ),
                
                const SizedBox(width: 8),
                
                // Conditional delete button for ended/cancelled events
                if (event.hostId == currentUser.id && 
                    (event.status == EventStatus.ended || event.status == EventStatus.cancelled))
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red color for delete
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context, eventController, event.id, currentUser.id);
                    },
                    child: const Text("Delete"),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context, 
    EventController eventController, 
    String eventId, 
    String userId
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Event"),
        content: const Text("Are you sure you want to delete this event? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final success = eventController.deleteEventByHost(eventId, userId);
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Event deleted successfully")),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Failed to delete event")),
                );
              }
              Navigator.pop(context);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}