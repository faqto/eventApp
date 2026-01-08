import 'package:app/pages/widgets/create_event/category_picker.dart';
import 'package:app/pages/widgets/create_event/date_time_picker.dart';
import 'package:app/pages/widgets/create_event/duration_picker.dart';
import 'package:app/pages/widgets/create_event/event_form.dart';
import 'package:flutter/material.dart';
import 'package:app/controllers/app_controller.dart';
import 'package:app/controllers/event_controller.dart';
import 'package:provider/provider.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime? _selectedDateTime;
  int _hoursDuration = 1;
  int _minutesDuration = 0;
  String _selectedCategory = '';

  final List<String> categories = [
    "Gaming", "Food", "Culture", "Environment",
    "Sports", "Music", "Tech", "Community",
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );
    });
  }

  void _createEvent(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select event date and time')),
      );
      return;
    }

    final duration = Duration(hours: _hoursDuration, minutes: _minutesDuration);
    final endTime = _selectedDateTime!.add(duration);

    final app = context.read<AppController>();
    final events = context.read<EventController>();
    
    final user = app.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to create events')),
      );
      return;
    }

    events.createEvent(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      dateTime: _selectedDateTime!,
      endTime: endTime,
      location: _locationController.text.trim(),
      hostId: user.id,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: EventForm(
          formKey: _formKey,
          titleController: _titleController,
          descriptionController: _descriptionController,
          locationController: _locationController,
          children: [
            CategoryPicker(
              selectedCategory: _selectedCategory,
              categories: categories,
              onCategoryChanged: (category) {
                setState(() => _selectedCategory = category);
              },
            ),
            const SizedBox(height: 20),

            DateTimePicker(
              selectedDateTime: _selectedDateTime,
              onPickDateTime: () => _pickDateTime(context),
            ),
            const SizedBox(height: 20),

            DurationPicker(
              hoursDuration: _hoursDuration,
              minutesDuration: _minutesDuration,
              selectedDateTime: _selectedDateTime,
              onHoursChanged: (hours) {
                setState(() => _hoursDuration = hours);
              },
              onMinutesChanged: (minutes) {
                setState(() => _minutesDuration = minutes);
              },
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _createEvent(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Create Event',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}