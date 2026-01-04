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
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController = TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final updatedEvent = widget.event.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
    );

    context.read<EventController>().updateEvent(updatedEvent);
    Navigator.pop(context); // go back to previous page
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
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Title"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
