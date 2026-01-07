import 'package:flutter/material.dart';
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


  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    _selectedDateTime = widget.event.dateTime;

  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedEvent = widget.event.copyWith(
      description: _descriptionController.text,
      location: _locationController.text,
      dateTime: _selectedDateTime,
    );

    context.read<EventController>().updateEvent(updatedEvent);
    Navigator.pop(context); // go back to previous page
  }
    Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );

    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }
      Future<void> _confirmCancelEvent() async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Cancel Event"),
            content: const Text("Are you sure you want to cancel this event?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  "Yes, cancel",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        );

      if (confirmed == true) {
        final cancelledEvent = widget.event.copyWith(
          status: EventStatus.cancelled,
        );

        context.read<EventController>().updateEvent(cancelledEvent);
        Navigator.pop(context);
      }
    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
            controller: TextEditingController(text: widget.event.title),
            enabled: false, 
            decoration: const InputDecoration(
              labelText: "Title",
              disabledBorder: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
      
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text("Event Schedule"),
            subtitle: Text(
              _selectedDateTime.toString(),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _pickDateTime,
            ),
          ),
      
            const SizedBox(height: 12),
            TextField(
              maxLines: null,
              minLines: 2,
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: "Description",
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text("Save Changes"),
                ),
                const SizedBox(width: 12),
                
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: _confirmCancelEvent,
                child: const Text(
                  "Cancel Event",
                  style: TextStyle(color: Colors.white),
                ),
                      ),
              ],
            ),
      
          ],
        ),
      ),
    );
  }
}
