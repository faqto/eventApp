import 'package:app/controllers/app_controller.dart';
import 'package:app/models/events_model.dart';
import 'package:app/pages/widgets/event_action_section.dart';
import 'package:app/pages/widgets/event_info_section.dart';
import 'package:app/pages/widgets/event_title_section.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventDetailsPage extends StatefulWidget {
  final Event event;
  const EventDetailsPage({super.key, required this.event});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final app = context.read<AppController>();
    final currentUser = app.currentUser;
    final isHost = widget.event.hostId == currentUser.id;
    final hostName = app.getEventHostName(widget.event);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Event Details",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        elevation: 2,
        shadowColor: Colors.grey.shade300,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventTitleSection(
              title: widget.event.title,
              hostName: hostName,
              category: widget.event.category,
              status: widget.event.status,
            ),
            EventInfoSection(
              location: widget.event.location,
              dateTime: widget.event.dateTime,
              description: widget.event.description,
            ),
            
            EventActionsSection(
              event: widget.event,
              isHost: isHost,
              hasJoined: app.hasJoined(widget.event.id),
              joinedCount: widget.event.attendeeIds.length,
              savedCount: widget.event.savedByIds.length,
              onEditPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.modifyEvent,
                  arguments: widget.event,
                );
              },
              onJoinPressed: () {
                app.joinEvent(widget.event.id);
                setState(() {});
              },
              onSavePressed: () {
                app.saveEvent(widget.event.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Event saved")),
                );
                setState(() {});
              },
              onChatPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.eventChat,
                  arguments: widget.event,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}