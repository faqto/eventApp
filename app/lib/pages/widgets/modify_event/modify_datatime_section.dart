import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModifyDateTimeSection extends StatefulWidget {
  final DateTime selectedDateTime;
  final Function(DateTime) onDateTimeChanged;

  const ModifyDateTimeSection({
    super.key,
    required this.selectedDateTime,
    required this.onDateTimeChanged,
  });

  @override
  State<ModifyDateTimeSection> createState() => _ModifyDateTimeSectionState();
}

class _ModifyDateTimeSectionState extends State<ModifyDateTimeSection> {
  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: widget.selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
          ),
          child: child!,
        );
      },
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(widget.selectedDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
          ),
          child: child!,
        );
      },
    );
    if (time == null) return;

    final newDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    widget.onDateTimeChanged(newDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: const Color(0xFF7F5DFB)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Event Schedule",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy · hh:mm a').format(widget.selectedDateTime),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit_calendar,
              color: const Color(0xFF7F5DFB),
            ),
            onPressed: _pickDateTime,
          ),
        ],
      ),
    );
  }
}