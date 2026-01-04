import 'package:app/controllers/app_controller.dart';
import 'package:app/models/event_utils.dart';
import 'package:app/models/events_model.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;
  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AppController>().currentUser;
    final isHost = event.hostId == currentUser.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                  Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: EventUtils.statusColor(event.status),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                EventUtils.statusText(event.status),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Text(event.title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 10),
            Text(event.category),
            const SizedBox(height: 10),
            Text(event.description),
            const SizedBox(height: 20),
            isHost ? ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.modifyEvent,
                      arguments: event,
                    );
                  },
                  child: const Text("Edit Event"),
                )
              : ElevatedButton(
                  onPressed: () {
                    // Your join event logic here
                  },
                  child: const Text("Join Event"),
                ),
            
            

          ],
        ),
      ),
    );
  }
}
