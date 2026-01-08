import 'package:flutter/material.dart';

class EventForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController locationController;
  final List<Widget> children;

  const EventForm({
    super.key,
    required this.formKey,
    required this.titleController,
    required this.descriptionController,
    required this.locationController,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Field
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Event Title',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter event title';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Description Field
          TextFormField(
            controller: descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter event description';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Location Field
          TextFormField(
            controller: locationController,
            decoration: const InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter event location';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }
}