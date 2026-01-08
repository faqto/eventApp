import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/event_controller.dart';
import 'package:app/models/events_model.dart';
import 'package:app/pages/widgets/event_action_section.dart';
import 'package:app/pages/widgets/event_info_section.dart';
import 'package:app/pages/widgets/event_title_section.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event; 
  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Event Details",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 2,
        shadowColor: Colors.grey.shade300,
      ),
      body: Consumer<EventController>(
        builder: (context, controller, _) {
          
          final latestEvent = controller.getEventById(event.id);
          if (latestEvent == null) return const Center(child: Text("Event not found"));

          final app = context.read<AppController>();
          final isHost = latestEvent.hostId == app.currentUser!.id;
          final hasJoined = app.hasJoined(latestEvent.id);
          final hostName = app.getEventHostName(latestEvent);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventTitleSection(
                  title: latestEvent.title,
                  hostName: hostName,
                  category: latestEvent.category,
                  status: latestEvent.status,
                ),

                EventInfoSection(
                  location: latestEvent.location,
                  dateTime: latestEvent.dateTime,
                  endDateTime: latestEvent.endTime,
                  description: latestEvent.description,
                ),
                EventActionsSection(
                  event: latestEvent,
                  isHost: isHost,
                  hasJoined: hasJoined,
                  joinedCount: latestEvent.attendeeIds.length,
                  savedCount: latestEvent.savedByIds.length,
                  onEditPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.modifyEvent,
                      arguments: latestEvent,
                    );
                  },
                  onJoinPressed: () {
                    app.joinEvent(latestEvent.id);
                  },
                  onSavePressed: () {
                    app.saveEvent(latestEvent.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Event saved")),
                    );
                  },
                  onChatPressed: () {
                    Navigator.pushNamed(
                      context,
                      Routes.eventChat,
                      arguments: latestEvent,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}