import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatelessWidget {
  final DateTime? selectedDateTime;
  final VoidCallback onPickDateTime;

  const DateTimePicker({
    super.key,
    required this.selectedDateTime,
    required this.onPickDateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onPickDateTime,
            icon: const Icon(Icons.calendar_today),
            label: Text(
              selectedDateTime == null
                  ? 'Select Date & Time'
                  : DateFormat('yyyy-MM-dd HH:mm').format(selectedDateTime!.toLocal())
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}