import 'package:app/models/event_utils.dart';
import 'package:app/models/events_model.dart';
import 'package:app/pages/event_details_page.dart';
import 'package:flutter/material.dart';

class HistoryEventCard extends StatelessWidget {
  final Event event;
  const HistoryEventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EventDetailsPage(event: event)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      event.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    EventUtils.statusText(event.status),
                    style: TextStyle(
                      color: EventUtils.statusColor(event.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(event.location),
              const SizedBox(height: 6),
              Text(
                "${event.dateTime.month}-${event.dateTime.day}-${event.dateTime.year}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
