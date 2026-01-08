import 'package:app/models/events_model.dart';
import 'package:flutter/material.dart';

class ModifyEventTitleSection extends StatelessWidget {
  final Event event;

  const ModifyEventTitleSection({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.event, color: const Color(0xFF7F5DFB)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              event.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}