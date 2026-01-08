// event_actions_section.dart
import 'package:app/models/events_model.dart';
import 'package:flutter/material.dart';

class EventActionsSection extends StatelessWidget {
  final Event event;
  final bool isHost;
  final bool hasJoined;
  final int joinedCount;
  final int savedCount;
  
  final VoidCallback onEditPressed;
  final VoidCallback onJoinPressed;
  final VoidCallback onSavePressed;
  final VoidCallback onChatPressed;
  
  const EventActionsSection({
    super.key,
    required this.event,
    required this.isHost,
    required this.hasJoined,
    required this.joinedCount,
    required this.savedCount,
    required this.onEditPressed,
    required this.onJoinPressed,
    required this.onSavePressed,
    required this.onChatPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people, size: 20, color: Colors.blue.shade600,),
              const SizedBox(width: 4),
              Text(
                "$joinedCount joined",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.star, size: 20, color: Colors.yellow.shade700),
              const SizedBox(width: 4),
              Text(
                "$savedCount saved",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),

          if (isHost && event.status == EventStatus.upcoming)
            _buildFullWidthButton(
              onPressed: onEditPressed,
              backgroundColor: Colors.green.shade600,
              text: "Edit Event",
            ),

          // non-host action buttons
          if (!isHost && event.status == EventStatus.upcoming) 
            Column(
              children: [
                _buildFullWidthButton(
                  onPressed: onJoinPressed,
                  backgroundColor: Colors.green.shade600,
                  text: hasJoined ? "Leave Event" : "Join Event",
                ),
                
                const SizedBox(height: 12),
                
                _buildOutlinedButton(
                  onPressed: onSavePressed,
                  text: "Save Event",
                ),
              ],
            ),

          const SizedBox(height: 16),

          // Chat Button (only if joined or host)
          if (isHost || hasJoined)
            _buildFullWidthIconButton(
              onPressed: onChatPressed,
              icon: Icons.chat,
              text: "Open Event Chat",
            ),
        ],
      ),
    );
  }

  Widget _buildFullWidthButton({
    required VoidCallback onPressed,
    required Color backgroundColor,
    required String text,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w300,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton({
    required VoidCallback onPressed,
    required String text,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }

  Widget _buildFullWidthIconButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String text,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}