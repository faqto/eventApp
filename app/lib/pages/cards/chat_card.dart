import 'package:app/models/event_utils.dart';
import 'package:app/models/events_model.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final Event event;

  const ChatCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(event.title),
        subtitle: Text(event.location),
        trailing: Text(event.status.name),
        leadingAndTrailingTextStyle: TextStyle(
            color: EventUtils.statusColor(event.status),
        )
        ,
        titleTextStyle: TextStyle(
          fontSize: 18
        ),
        onTap: () {
          Navigator.pushNamed(
                  context,
                  Routes.eventChat,
                  arguments: event,
                );
        },
      ),
    );
  }
}
