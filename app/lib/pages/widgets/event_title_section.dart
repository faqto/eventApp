import 'package:flutter/material.dart';
import 'package:app/models/event_utils.dart';
import 'package:app/models/events_model.dart';

class EventTitleSection extends StatelessWidget {
  final String title;
  final String hostName;
  final String category;
  final EventStatus status;

  const EventTitleSection({
    super.key,
    required this.title,
    required this.hostName,
    required this.category,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "by: $hostName",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _buildBadges(),
          
        ],
      ),
    );
  }

  Widget _buildBadges() {
    return Row(
      children: [
        _buildCategoryBadge(),
        const SizedBox(width: 10),
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        category.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: EventUtils.statusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        EventUtils.statusText(status).toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}