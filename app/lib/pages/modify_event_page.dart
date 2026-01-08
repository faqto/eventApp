import 'package:app/pages/widgets/modify_event/modify_actionbuttons_section.dart';
import 'package:app/pages/widgets/modify_event/modify_datatime_section.dart';
import 'package:app/pages/widgets/modify_event/modify_description_section.dart';
import 'package:app/pages/widgets/modify_event/modify_duration_section.dart';
import 'package:app/pages/widgets/modify_event/modify_location_section.dart';
import 'package:app/pages/widgets/modify_event/modify_title_section.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app/controllers/event_controller.dart';
import 'package:app/models/events_model.dart';

class ModifyEventPage extends StatefulWidget {
  final Event event;

  const ModifyEventPage({super.key, required this.event});

  @override
  State<ModifyEventPage> createState() => _ModifyEventPageState();
}

class _ModifyEventPageState extends State<ModifyEventPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late DateTime _selectedDateTime;
  late Duration _eventDuration;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.event.description,
    );
    _locationController = TextEditingController(text: widget.event.location);
    _selectedDateTime = widget.event.dateTime;
    _eventDuration = widget.event.endTime.difference(widget.event.dateTime);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final endTime = _selectedDateTime.add(_eventDuration);
    
    final updatedEvent = widget.event.copyWith(
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      dateTime: _selectedDateTime,
      endTime: endTime,
    );

    context.read<EventController>().updateEvent(updatedEvent);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Event updated successfully"),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );

    Navigator.pop(context, true);
  }

  Future<void> _confirmCancelEvent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Cancel Event",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        content: const Text(
          "Are you sure you want to cancel this event? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Keep Event"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text("Cancel Event"),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    if (!mounted || confirmed != true) return;

    final controller = context.read<EventController>();
    final success = controller.cancelEvent(
      widget.event.id,
      widget.event.hostId,
    );

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Event cancelled"),
          backgroundColor: Colors.orange.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cannot cancel this event"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onDateTimeChanged(DateTime newDateTime) {
    setState(() {
      _selectedDateTime = newDateTime;
    });
  }

  void _onDurationChanged(Duration newDuration) {
    setState(() {
      _eventDuration = newDuration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ModifyEventTitleSection(event: widget.event),
              const SizedBox(height: 24),

              ModifyDateTimeSection(
                selectedDateTime: _selectedDateTime,
                onDateTimeChanged: _onDateTimeChanged,
              ),
              const SizedBox(height: 20),

              ModifyDurationSection(
                initialDuration: _eventDuration,
                onDurationChanged: _onDurationChanged,
              ),
              const SizedBox(height: 20),

              if (_eventDuration.inMinutes > 0)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.blue.shade600, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                        "Event will end: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedDateTime.add(_eventDuration).toLocal())}",
                            style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              ModifyDescriptionSection(controller: _descriptionController),
              const SizedBox(height: 20),

              ModifyLocationSection(controller: _locationController),
              const SizedBox(height: 20),

              ModifyActionButtonsSection(
                onSave: _saveChanges,
                onCancelEvent: _confirmCancelEvent,
                isSaveEnabled: _eventDuration.inMinutes > 0, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}