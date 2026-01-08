import 'package:app/controllers/app_controller.dart';
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
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

              // Conditional modify button
              if (event.hostId == currentUser!.id && event.status == EventStatus.upcoming)
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.modifyEvent,
                        arguments: event,
                      );
                    },
                    child: const Text("Modify"),
                  ),
                ),  
              ],
            ),
          ],
        ),
      ),
    );
  }
}
