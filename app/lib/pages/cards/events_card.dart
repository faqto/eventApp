import 'package:app/models/events_model.dart';
import 'package:app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventsCard extends StatelessWidget {
  final Event event;

  const EventsCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.eventDetails,
            arguments: event,
          );
        },
        child: Container(
          margin: const EdgeInsets.all(16),
          height: 190,
          decoration: BoxDecoration(
          color: const Color(0xFFB39DFF),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              const Color(0xFF7F5DFB),
              
              Colors.white,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7F5DFB).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    event.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
        
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
        
                    const SizedBox(height: 8),
        
                    Text(
                      event.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
        
                    const Spacer(),
        
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 14),
                        const SizedBox(width: 6),
                        Text(
                           DateFormat.yMMMd().format(event.dateTime),
                        ),
        
                        const SizedBox(width: 16),
        
                        const Icon(Icons.location_on, size: 14),
                        const SizedBox(width: 6),
                        Expanded(child: Text(event.location)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

